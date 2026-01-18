import '../event_type.dart';

class Event {
  /// The connection id in which the event has been sent
  String? connectionId;

  /// The type of the event
  /// [EventType] contains some predefined constant types
  String? type;

  /// The channel/topic of the event (e.g., "market.ticker:BTC-USDT")
  String? channel;

  /// The payload/data of the event
  dynamic data;

  int? uid;
  bool? online;

  Event.fromJson(dynamic json) {
    connectionId = json['connectionId'];
    type = json['type'];
    channel = json['channel'] ?? json['topic'];
    data = json['data'] ?? json['payload'];
    uid = json['uid'];
  }

  Event({
    this.connectionId,
    this.type,
    this.channel,
    this.data,
    this.uid,
    this.online,
  });

  Map<String, dynamic> toJson() {
    return {
      if (connectionId != null) 'connectionId': connectionId,
      if (type != null) 'type': type,
      if (channel != null) 'channel': channel,
      if (data != null) 'data': data,
      if (uid != null) 'uid': uid,
    };
  }
}
