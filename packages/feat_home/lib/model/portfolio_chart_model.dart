import 'package:fl_chart/fl_chart.dart';

enum PortfolioTimeRange {
  day,
  week,
  month,
  sixMonth,
}

extension PortfolioTimeRangeExt on PortfolioTimeRange {
  String get label {
    switch (this) {
      case PortfolioTimeRange.day:
        return 'Day';
      case PortfolioTimeRange.week:
        return 'Week';
      case PortfolioTimeRange.month:
        return 'Month';
      case PortfolioTimeRange.sixMonth:
        return '6 Months';
    }
  }
}

class PortfolioChartData {
  final List<FlSpot> spots;
  final double maxX;
  final double maxY;
  final List<String> bottomLabels;
  final int verticalDivisions;

  const PortfolioChartData({
    required this.spots,
    required this.maxX,
    required this.maxY,
    required this.bottomLabels,
    required this.verticalDivisions,
  });
}
