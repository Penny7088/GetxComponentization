import 'package:lib_uikit/models/i_crypto_card_data.dart';

class CryptoModel implements ICryptoCardData {
  @override
  final String name;
  @override
  final String symbol;
  @override
  final String pair;
  @override
  final String volume;
  @override
  final String topPrice;
  @override
  final String lowPrice;
  @override
  final double currentPrice;
  @override
  final double changePercent;
  @override
  final List<double> chartData;
  @override
  final bool isFavorite;

  CryptoModel({
    required this.name,
    required this.symbol,
    required this.pair,
    required this.volume,
    required this.topPrice,
    required this.lowPrice,
    required this.currentPrice,
    required this.changePercent,
    required this.chartData,
    this.isFavorite = false,
  });
}
