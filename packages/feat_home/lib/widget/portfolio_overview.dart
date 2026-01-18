import 'package:feat_home/model/portfolio_chart_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:lib_base/theme/app_colors.dart';
import 'package:lib_base/utils/extensions/context_extensions.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:lib_uikit/widget/common_button.dart';

class PortfolioOverview extends StatelessWidget {
  final bool isLogin;
  final VoidCallback? onLoginTap;
  final PortfolioTimeRange selectedTimeRange;
  final PortfolioChartData chartData;
  final ValueChanged<PortfolioTimeRange>? onTimeRangeChanged;
  final bool isExpanded;
  final VoidCallback? onToggleExpansion;

  const PortfolioOverview({
    super.key,
    this.isLogin = false,
    this.onLoginTap,
    this.selectedTimeRange = PortfolioTimeRange.day,
    required this.chartData,
    this.onTimeRangeChanged,
    this.isExpanded = true,
    this.onToggleExpansion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorExtension>()!;
    return isLogin
        ? _buildLoggedInView(theme, appColors).paddingOnly(left: 16, right: 16)
        : Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildLoggedOutView(appColors),
          );
  }

  Widget _buildLoggedOutView(AppColorExtension appColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Column(
        children: [
          AppText.largeBold('Portfolio Balance'),
          const SizedBox(height: 20),
          AppText.medium(
            'Sign in to view your portfolio',
            color: appColors.secondTextColor,
          ),
          const SizedBox(height: 24),
          CommonButton.primary(
            text: 'Login',
            onPressed: onLoginTap,
            width: 160,
            height: 44,
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInView(ThemeData theme, AppColorExtension appColors) {
    return Column(
      children: [
        const SizedBox(height: 15),
        AppText.mediumBold('Portfolio Balance'),
        const SizedBox(height: 8),
        AppText.heading('\$2,760.23', fontSize: 32),
        const SizedBox(height: 4),
        AppText.mediumBold('+2.60%', color: appColors.upColor),
        const SizedBox(height: 10),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            children: [
              if (isExpanded) ...[
                SizedBox(height: 160, child: _buildChart(theme)),
                const SizedBox(height: 16),
                _buildTimeLabels(appColors),
                const SizedBox(height: 16),
                _buildTimeRangeTabs(theme, appColors),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: IconButton(
            onPressed: onToggleExpansion,
            icon: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: appColors.secondTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRangeTabs(ThemeData theme, AppColorExtension appColors) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: PortfolioTimeRange.values.map((range) {
          final isSelected = range == selectedTimeRange;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTimeRangeChanged?.call(range),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? theme.cardColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: AppText.smallBold(
                  range.label,
                  color: isSelected
                      ? appColors.mainTextColor
                      : appColors.secondTextColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart(ThemeData theme) {
    final primaryColor = theme.primaryColor;
    final spots = chartData.spots;
    final maxX = chartData.maxX;
    final maxY = chartData.maxY;
    final verticalDivisions = chartData.verticalDivisions;

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _GridPainter(
              color: primaryColor,
              verticalDivisions: verticalDivisions,
            ),
          ),
        ),
        LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(
              show: true,
              border: Border(bottom: BorderSide(color: primaryColor, width: 1)),
            ),
            minX: 0,
            maxX: maxX,
            minY: 0,
            maxY: maxY,
            extraLinesData: ExtraLinesData(
              verticalLines: [
                VerticalLine(
                  x: maxX,
                  color: primaryColor.withOpacity(0.5),
                  strokeWidth: 2,
                ),
              ],
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.35,
                color: primaryColor,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, barData) {
                    return spot.x == maxX;
                  },
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 6,
                      color: Colors.white,
                      strokeWidth: 4,
                      strokeColor: primaryColor,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.2),
                      primaryColor.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.white,
                tooltipRoundedRadius: 8,
                tooltipPadding: const EdgeInsets.all(8),
                tooltipBorder: BorderSide(
                  color: primaryColor.withOpacity(0.1),
                  width: 1,
                ),
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    return LineTooltipItem(
                      '\$${barSpot.y.toStringAsFixed(2)}',
                      TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  }).toList();
                },
              ),
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: primaryColor,
                          strokeWidth: 2,
                          dashArray: [4, 2],
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.white,
                              strokeWidth: 4,
                              strokeColor: primaryColor,
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeLabels(AppColorExtension appColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: chartData.bottomLabels
            .map(
              (time) => AppText.xSmall(time, color: appColors.secondTextColor),
            )
            .toList(),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  final int verticalDivisions;

  _GridPainter({required this.color, required this.verticalDivisions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final double interval = size.width / verticalDivisions;

    for (int i = 1; i < verticalDivisions; i++) {
      final double x = i * interval;

      final shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [color.withOpacity(0.2), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(x, 0, 1, size.height));

      paint.shader = shader;

      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return color != oldDelegate.color ||
        verticalDivisions != oldDelegate.verticalDivisions;
  }
}
