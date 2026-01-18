import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'connection_status.dart';
import 'error/ws_error_code.dart';
import 'error/ws_socket_error.dart';
import 'event/event.dart';
import 'event_type.dart';
import 'timer_helper.dart';

/// Typedef which exposes an [Event] as the only parameter.
typedef EventHandler = void Function(Event);

/// Typedef used for connecting to a websocket. Method returns a
/// [WebSocketChannel] and accepts a connection [url] and an optional
/// [Iterable] of `protocols`.
typedef WebSocketChannelProvider =
    WebSocketChannel Function(Uri uri, {Iterable<String>? protocols});

/// A WebSocket connection that reconnects upon failure.
class WebSocket with TimerHelper {
  /// Creates a new websocket
  /// To connect the WS call [connect]
  WebSocket({
    required this.token,
    required this.baseUrl,
    this.handler,
    Logger? logger,
    this.webSocketChannelProvider,
    this.reconnectionMonitorInterval = 10,
    this.healthCheckInterval = 20,
    this.reconnectionMonitorTimeout = 40,
    this.queryParameters = const {},
  }) : _logger = logger;

  ///
  final String token;

  /// Additional query parameters to be added to the websocket url
  final Map<String, Object?> queryParameters;

  /// WS base url
  String baseUrl;

  /// Functions that will be called every time a new event is received from the
  /// connection
  final EventHandler? handler;

  final Logger? _logger;

  /// Connection function
  /// Used only for testing purpose
  @visibleForTesting
  final WebSocketChannelProvider? webSocketChannelProvider;

  /// Interval of the reconnection monitor timer
  /// This checks that it received a new event in the last
  /// [reconnectionMonitorTimeout] seconds, otherwise it considers the
  /// connection unhealthy and reconnects the WS
  final int reconnectionMonitorInterval;

  /// Interval of the health event sending timer
  /// This sends a health event every [healthCheckInterval] seconds in order to
  /// make the server aware that the client is still listening
  final int healthCheckInterval;

  /// The timeout that uses the reconnection monitor timer to consider the
  /// connection unhealthy
  final int reconnectionMonitorTimeout;

  String? _connectionId;
  DateTime? _lastEventAt;
  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _webSocketChannelSubscription;

  ///
  Completer<Event>? connectionCompleter;

  ///
  String? get connectionId => _connectionId;

  final _connectionStatusController = BehaviorSubject.seeded(
    ConnectionStatus.disconnected,
  );

  set _connectionStatus(ConnectionStatus status) =>
      _connectionStatusController.add(status);

  /// The current connection status value
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  /// This notifies of connection status changes
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream.distinct();

  void _initWebSocketChannel(Uri uri) {
    _logger?.i('Initiating connection with $baseUrl');
    if (_webSocketChannel != null) {
      _closeWebSocketChannel();
    }
    _webSocketChannel =
        webSocketChannelProvider?.call(uri) ?? WebSocketChannel.connect(uri);
    _subscribeToWebSocketChannel();
  }

  void _closeWebSocketChannel() {
    _logger?.i('Closing connection with $baseUrl');
    if (_webSocketChannel != null) {
      _unsubscribeFromWebSocketChannel();
      _webSocketChannel?.sink.close(
        _manuallyClosed ? status.normalClosure : status.goingAway,
      );
      _webSocketChannel = null;
    }
  }

  void _subscribeToWebSocketChannel() {
    _logger?.i('Started listening to $baseUrl');
    if (_webSocketChannelSubscription != null) {
      _unsubscribeFromWebSocketChannel();
    }
    _webSocketChannelSubscription = _webSocketChannel?.stream.listen(
      _onDataReceived,
      onError: _onConnectionError,
      onDone: _onConnectionClosed,
    );
  }

  void _unsubscribeFromWebSocketChannel() {
    _logger?.i('Stopped listening to $baseUrl');
    if (_webSocketChannelSubscription != null) {
      _webSocketChannelSubscription?.cancel();
      _webSocketChannelSubscription = null;
    }
  }

  Future<Uri> _buildUri({
    bool refreshToken = false,
    bool includeUserDetails = true,
  }) async {
    final qs = {'Authorization': token, ...queryParameters};
    final isWsUrl = baseUrl.startsWith('ws') || baseUrl.startsWith('wss');
    if (!isWsUrl) {
      const WsSocketError('url is error,pls update');
    }

    return Uri(path: baseUrl, queryParameters: qs);
  }

  bool _connectRequestInProgress = false;

  /// Connect the WS using the parameters passed in the constructor
  Future<Event> connect({bool includeUserDetails = false}) async {
    if (_connectRequestInProgress) {
      throw const WsSocketError('''
        You've called connect twice,
        can only attempt 1 connection at the time,
        ''');
    }
    _connectRequestInProgress = true;
    _manuallyClosed = false;

    _connectionStatus = ConnectionStatus.connecting;
    connectionCompleter = Completer<Event>();

    try {
      final uri = await _buildUri(includeUserDetails: includeUserDetails);
      // var uri2 = Uri(path: 'ws://192.168.2.62:9504/ws/chat.io');
      _initWebSocketChannel(uri);
    } catch (e, stk) {
      _onConnectionError(e, stk);
    }

    return connectionCompleter!.future;
  }

  int _reconnectAttempt = 0;
  bool _reconnectRequestInProgress = false;

  void _reconnect({bool refreshToken = false}) async {
    _logger?.i('Retrying connection : $_reconnectAttempt');
    if (_reconnectRequestInProgress) return;
    _reconnectRequestInProgress = true;

    _stopMonitoringEvents();
    // Closing any previously opened web-socket
    _closeWebSocketChannel();

    _reconnectAttempt += 1;
    _connectionStatus = ConnectionStatus.connecting;

    final delay = _getReconnectInterval(_reconnectAttempt);
    setTimer(Duration(milliseconds: delay), () async {
      final uri = await _buildUri(
        refreshToken: refreshToken,
        includeUserDetails: false,
      );
      try {
        _initWebSocketChannel(uri);
      } catch (e, stk) {
        _onConnectionError(e, stk);
      }
    });
  }

  // returns the reconnect interval based on `reconnectAttempt` in milliseconds
  int _getReconnectInterval(int reconnectAttempt) {
    // try to reconnect in 0.25-25 seconds
    // (random to spread out the load from failures)
    final max = math.min(500 + reconnectAttempt * 2000, 25000);
    final min = math.min(math.max(250, (reconnectAttempt - 1) * 2000), 25000);
    return (math.Random().nextDouble() * (max - min) + min).floor();
  }

  void _startMonitoringEvents() {
    _logger?.i('Starting monitoring events');
    // cancel all previous timers
    cancelAllTimers();

    _startHealthCheck();
    _startReconnectionMonitor();
  }

  void _stopMonitoringEvents() {
    _logger?.i('Stopped monitoring events');
    // reset lastEvent
    _lastEventAt = null;

    cancelAllTimers();
  }

  void _handleConnectedEvent(Event event) {
    // updating connectionId and status
    _connectionId = event.connectionId;
    _connectionStatus = ConnectionStatus.connected;

    _logger?.i('Connection successful: $_connectionId');

    // notify user that connection is completed
    final completer = connectionCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(event);
    }

    // start monitoring health-check events
    _startMonitoringEvents();
  }

  void _handleHealthCheckEvent(Event event) {
    _logger?.i('HealthCheck received : ${event.connectionId}');

    _connectionId = event.connectionId;
    _connectionStatus = ConnectionStatus.connected;
  }

  void _handleStreamError(Map<String, Object?> errorResponse) {
    // resetting connect, reconnect request flag
    _resetRequestFlags();

    final error = WsSocketError.fromStreamError(errorResponse);
    final isTokenExpired = error.errorCode == WsErrorCode.tokenExpired;
    if (isTokenExpired) {
      _logger?.w('Connection failed, token expired');
      return _reconnect(refreshToken: true);
    }

    _logger?.e('Connection failed = ${error.toString()}');

    final completer = connectionCompleter;
    // complete with error if not yet completed
    if (completer != null && !completer.isCompleted) {
      // complete the connection with error
      completer.completeError(error);
      // disconnect the web-socket connection
      return disconnect();
    }

    return _reconnect();
  }

  void _onDataReceived(dynamic data) {
    final jsonData = json.decode(data) as Map<String, Object?>;
    _logger?.i('Event received: $jsonData');
    final error = jsonData['error'] as Map<String, Object?>?;
    if (error != null) return _handleStreamError(error);

    // resetting connect, reconnect request flag
    _resetRequestFlags(resetAttempts: true);

    Event? event;
    try {
      event = Event.fromJson(jsonData);
    } catch (e, stk) {
      _logger?.w('Error parsing an event: $e');
      _logger?.w('Stack trace: $stk');
    }

    if (event == null) return;

    _lastEventAt = DateTime.now();

    if (event.type == EventType.healthCheck) {
      if (event.uid != null) {
        _handleConnectedEvent(event);
      } else {
        _handleHealthCheckEvent(event);
      }
    }

    return handler?.call(event);
  }

  void _onConnectionError(error, [stacktrace]) {
    _logger?.w('Error occurred ${error.toString()}, stacktrace');

    WsSocketError wsError;
    if (error is WebSocketChannelException) {
      wsError = WsSocketError.fromWebSocketChannelError(error);
    } else {
      wsError = WsSocketError(error.toString());
    }

    final completer = connectionCompleter;
    // complete with error if not yet completed
    if (completer != null && !completer.isCompleted) {
      // complete the connection with error
      completer.completeError(wsError);
    }

    // resetting connect, reconnect request flag
    _resetRequestFlags();

    _reconnect();
  }

  bool _manuallyClosed = false;

  void _onConnectionClosed() {
    _logger?.w('Connection closed : $connectionId');

    // resetting connect, reconnect request flag
    _resetRequestFlags();

    // resetting connection
    _connectionId = null;

    // check if we manually closed the connection
    if (_manuallyClosed) return;
    _reconnect();
  }

  bool get _needsToReconnect {
    final lastEventAt = _lastEventAt;
    // means not yet connected or disconnected
    if (lastEventAt == null) return false;

    // means we missed a health check
    final now = DateTime.now();
    return now.difference(lastEventAt).inSeconds > reconnectionMonitorTimeout;
  }

  void _resetRequestFlags({bool resetAttempts = false}) {
    _connectRequestInProgress = false;
    _reconnectRequestInProgress = false;
    if (resetAttempts) _reconnectAttempt = 0;
  }

  void _startReconnectionMonitor() {
    _logger?.i('Starting reconnection monitor');
    setPeriodicTimer(Duration(seconds: reconnectionMonitorInterval), (_) {
      final needsToReconnect = _needsToReconnect;
      _logger?.i('Needs to reconnect : $needsToReconnect');
      if (needsToReconnect) _reconnect();
    }, immediate: true);
  }

  void _startHealthCheck() {
    _logger?.i('Starting health check monitor');
    setPeriodicTimer(Duration(seconds: healthCheckInterval), (_) {
      _logger?.i('Sending Event: ${EventType.healthCheck}');
      final event = Event(
        type: EventType.healthCheck,
        connectionId: connectionId,
      );
      _webSocketChannel?.sink.add(jsonEncode(event));
    }, immediate: true);
  }

  /// Disconnects the WS and releases eventual resources
  void disconnect() {
    if (connectionStatus == ConnectionStatus.disconnected) return;

    _resetRequestFlags(resetAttempts: true);

    _connectionStatus = ConnectionStatus.disconnected;

    _logger?.i('Disconnecting web-socket connection');

    connectionCompleter = null;

    _stopMonitoringEvents();

    _manuallyClosed = true;

    _closeWebSocketChannel();
  }

  /// Sends a message to the websocket
  void send(dynamic message) {
    if (_webSocketChannel == null ||
        connectionStatus != ConnectionStatus.connected) {
      _logger?.w('Cannot send message, socket is not connected');
      return;
    }

    dynamic payload;
    if (message is String) {
      payload = message;
    } else {
      payload = jsonEncode(message);
    }

    _logger?.i('Sending message: $payload');
    _webSocketChannel?.sink.add(payload);
  }

  /// Update base url and reconnect if connected
  void updateBaseUrl(String newUrl) {
    if (baseUrl == newUrl) return;
    baseUrl = newUrl;

    // If currently connected or connecting, reconnect with new URL
    if (connectionStatus == ConnectionStatus.connected ||
        connectionStatus == ConnectionStatus.connecting) {
      disconnect();
      // Small delay to ensure clean disconnect
      Timer(const Duration(milliseconds: 100), () {
        connect();
      });
    }
  }
}
