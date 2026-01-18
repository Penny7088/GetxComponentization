class KLineEntity {
  final int time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  // MA 指标
  double? ma5;
  double? ma10;
  double? ma30;

  // MACD 指标
  double? dif;
  double? dea;
  double? macd;

  KLineEntity({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  @override
  String toString() {
    return 'KLineEntity(time: $time, open: $open, high: $high, low: $low, close: $close, volume: $volume)';
  }
}
