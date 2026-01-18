import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lib_base/theme/app_colors.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:lib_uikit/models/i_crypto_card_data.dart';
import 'package:lib_uikit/widget/shadow_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CryptoCard<T extends ICryptoCardData> extends StatelessWidget {
  final Stream<T>? dataStream;
  final T? initialData;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onMove;
  final VoidCallback? onRemove;

  const CryptoCard({
    super.key,
    this.dataStream,
    this.initialData,
    this.onTap,
    this.onFavorite,
    this.onMove,
    this.onRemove,
  }) : assert(
         dataStream != null || initialData != null,
         'Either dataStream or initialData must be provided',
       );

  @override
  Widget build(BuildContext context) {
    if (dataStream != null) {
      return StreamBuilder<T>(
        stream: dataStream!.distinct(), // 过滤掉相同的数据
        initialData: initialData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return RepaintBoundary(child: _buildCard(context, snapshot.data!));
        },
      );
    }
    return _buildCard(context, initialData!);
  }

  Widget _buildCard(BuildContext context, T data) {
    final appColors = Theme.of(context).extension<AppColorExtension>()!;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryColor = Theme.of(context).primaryColor;

    // 涨跌颜色
    final isPositive = data.changePercent >= 0;
    final changeColor = isPositive
        ? appColors.upColor
        : appColors.decreaseColor;
    final changeBgColor = isPositive
        ? const Color(0xFF098C26)
        : const Color(0xFFCD0000);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Slidable(
        key: ValueKey(data.symbol),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: data.isFavorite ? 0.6 : 0.35,
          children: [
            if (data.isFavorite) ...[
              CustomSlidableAction(
                onPressed: (_) => onMove?.call(),
                backgroundColor: const Color(0xFF098C26), // Green
                foregroundColor: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.unfold_more_rounded, size: 28.sp),
                    SizedBox(height: 4.h),
                    AppText.xSmall(
                      'Move',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              CustomSlidableAction(
                onPressed: (_) => onRemove?.call(),
                backgroundColor: const Color(0xFFCD0000), // Red
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline_rounded, size: 28.sp),
                    SizedBox(height: 4.h),
                    AppText.xSmall(
                      'Remove',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ] else
              CustomSlidableAction(
                onPressed: (_) => onFavorite?.call(),
                backgroundColor: const Color(0xFFF7931A), // Orange color
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border_rounded, size: 28.sp),
                    SizedBox(height: 4.h),
                    AppText.xSmall(
                      'Add to Favorites',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
        child: ShadowCard(
          shadowColor: primaryColor.withValues(alpha: 0.15),
          child: Row(
            children: [
              // Left: Symbol & Volume
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: AppText.largeBold(
                              data.symbol,
                              color: appColors.mainTextColor,
                            ),
                          ),
                          WidgetSpan(
                            child: AppText.small(
                              ' /${data.pair}',
                              color: appColors.secondTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AppText.xSmall(
                      'Vol ${data.volume}',
                      color: appColors.secondTextColor,
                    ),
                  ],
                ),
              ),

              // Middle: Chart & Range
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    AppText.xSmallBold(
                      'Top price ${data.topPrice}',
                      color: appColors.mainTextColor,
                    ),
                    5.verticalSpace,
                    SizedBox(
                      height: 30.h,
                      width: double.infinity,
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
                    5.verticalSpace,
                    AppText.xSmallBold(
                      'Low price ${data.lowPrice}',
                      color: appColors.mainTextColor,
                    ),
                  ],
                ),
              ),

              // Right: Price & Change
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText.largeBold(
                      data.currentPrice.toStringAsFixed(3),
                      color: appColors.mainTextColor,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: changeBgColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: AppText.smallBold(
                        '${isPositive ? '+' : ''}${data.changePercent.toStringAsFixed(2)}%',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
