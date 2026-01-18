import 'package:get/get.dart';
import 'package:lib_base/lib_base.dart';

class SocketService extends GetxService {
  static SocketService get to => Get.find();

  late WsClient _client;
  WsClient get client => _client;

  /// Initialize the socket service
  /// This should be called during app initialization
  Future<SocketService> init({
    required String baseUrl,
    String token = '',
    Map<String, dynamic> queryParameters = const {},
  }) async {
    _client = WsClient(
      baseUrl: baseUrl,
      token: token,
      queryParameters: queryParameters,
    );
    return this;
  }

  /// Connect to the websocket
  Future<void> connect() async {
    await _client.connect();
  }

  /// Disconnect from the websocket
  void disconnect() {
    _client.closeConnection();
  }

  /// Subscribe to topics
  void subscribe(List<String> topics) {
    _client.subscribe(topics);
  }

  /// Unsubscribe from topics
  void unsubscribe(List<String> topics) {
    _client.unsubscribe(topics);
  }

  /// Stream of events
  Stream<Event> get eventStream => _client.eventStream;

  /// Update the WebSocket URL
  void updateBaseUrl(String newUrl) {
    _client.updateBaseUrl(newUrl);
  }
}
