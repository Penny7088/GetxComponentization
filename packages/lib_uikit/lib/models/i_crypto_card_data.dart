abstract class ICryptoCardData {
  String get name;
  String get symbol;
  String get pair;
  String get volume;
  String get topPrice;
  String get lowPrice;
  double get currentPrice;
  double get changePercent;
  List<double> get chartData;
  bool get isFavorite;
}
