import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lib_uikit/models/crypto_model.dart';
import 'package:lib_base/theme/app_colors.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:lib_uikit/widget/crypto_smart_builder.dart';
import 'package:lib_uikit/widget/shadow_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CryptoGridCard extends StatelessWidget {
  final Stream<CryptoModel>? dataStream;
  final CryptoModel? initialData;
  final VoidCallback? onTap;

  const CryptoGridCard({
    super.key,
    this.dataStream,
    this.initialData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return CryptoSmartBuilder(
      dataStream: dataStream,
      initialData: initialData,
      builder: (context, data) {
        final appColors = Theme.of(context).extension<AppColorExtension>()!;
        final isPositive = data.changePercent >= 0;
        final changeColor = isPositive
            ? const Color(0xFF098C26)
            : const Color(0xFFCD0000);

        return ShadowCard(
          onTap: onTap,
          width: 160.w,
          borderRadius: 20.r,
          shadowColor: primaryColor.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Info + Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.largeBold(
                          '${data.symbol}/${data.pair}',
                          color: appColors.mainTextColor,
                        ),
                        SizedBox(height: 4.h),
                        AppText.mediumBold(
                          data.currentPrice.toStringAsFixed(2),
                          color: appColors.mainTextColor,
                        ),
                        SizedBox(height: 4.h),
                        AppText.smallBold(
                          '${isPositive ? '+' : ''}${data.changePercent.toStringAsFixed(2)}%',
                          color: changeColor,
                        ),
                      ],
                    ),
                  ),
                  // Placeholder Icon
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2F66F6), Color(0xFF8DA4F6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2F66F6).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: AppText.smallBold(
                      data.symbol.substring(0, 1),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Chart
              SizedBox(
                height: 40.h,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (data.chartData.length - 1).toDouble(),
                    minY: data.chartData.reduce((a, b) => a < b ? a : b),
                    maxY: data.chartData.reduce((a, b) => a > b ? a : b),
                    lineBarsData: [
                      LineChartBarData(
                        spots: data.chartData.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value);
                        }).toList(),
                        isCurved: true,
                        color: const Color(0xFF2F66F6),
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Bottom: Volume
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.xSmall('24H Vol.', color: appColors.secondTextColor),
                  SizedBox(height: 4.h),
                  AppText.smallBold(
                    data.volume,
                    color: appColors.secondTextColor,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
