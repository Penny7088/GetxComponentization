/// This class defines some basic event types
class EventType {
  /// Indicates any type of events
  static const String any = '*';

  ///
  static const String healthCheck = 'health.check';

  /// Event sent when the connection status changes
  static const String connectionChanged = 'connection.changed';

  /// Event sent when the connection is recovered
  static const String connectionRecovered = 'connection.recovered';

  // --- Market Data Events (Examples) ---

  /// Ticker update
  static const String marketTicker = 'market.ticker';

  /// Trade history update
  static const String marketTrade = 'market.trade';

  /// Depth/OrderBook update
  static const String marketDepth = 'market.depth';

  /// Kline/Candlestick update
  static const String marketKline = 'market.kline';
}
