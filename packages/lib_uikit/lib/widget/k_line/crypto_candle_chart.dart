import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:lib_uikit/widget/k_line/data_util.dart';
import 'package:lib_uikit/widget/k_line/k_line_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum MainState { MA, BOLL, NONE }

enum SubState { VOL, MACD, KDJ, RSI, WR, NONE }

class CryptoCandleChart extends StatefulWidget {
  final List<KLineEntity> datas;
  final bool isFullScreen;
  final VoidCallback? onFullScreenToggle;

  const CryptoCandleChart({
    super.key,
    required this.datas,
    this.isFullScreen = false,
    this.onFullScreenToggle,
  });

  @override
  State<CryptoCandleChart> createState() => _CryptoCandleChartState();
}

class _CryptoCandleChartState extends State<CryptoCandleChart> {
  MainState _mainState = MainState.BOLL;
  SubState _subState = SubState.VOL;

  // 模拟数据
  late List<KLineEntity> _datas;

  // 缩放范围（可视区域的起始索引和结束索引）
  late int _visibleCount;
  late int _startIndex;
  final int _minVisibleCount = 20; // 最少显示20根
  final int _maxVisibleCount = 100; // 最多显示100根

  // 触摸交互状态
  KLineEntity? _selectedEntity;

  @override
  void initState() {
    super.initState();
    _datas = widget.datas.isEmpty
        ? DataUtil.generateRandomData(count: 200) // 生成更多数据以便缩放
        : widget.datas;

    // 初始化显示最后 40 根
    _visibleCount = 40;
    _startIndex = max(0, _datas.length - _visibleCount);
  }

  @override
  void didUpdateWidget(covariant CryptoCandleChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.datas != oldWidget.datas && widget.datas.isNotEmpty) {
      _datas = widget.datas;
      _startIndex = max(0, _datas.length - _visibleCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isLandscape = constraints.maxWidth > constraints.maxHeight;
        if (widget.isFullScreen) isLandscape = true;

        if (isLandscape) {
          return _buildLandscapeLayout();
        } else {
          return _buildPortraitLayout();
        }
      },
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        _buildTopInfo(),
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(flex: 2, child: _buildMainChart()),
                  if (_subState != SubState.NONE) ...[
                    SizedBox(height: 5.h),
                    Expanded(flex: 1, child: _buildSubChart()),
                  ],
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: _buildIndicatorButtons(isPortrait: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildTopInfo(),
              Expanded(flex: 2, child: _buildMainChart()),
              if (_subState != SubState.NONE) ...[
                SizedBox(height: 5.h),
                Expanded(flex: 1, child: _buildSubChart()),
              ],
            ],
          ),
        ),
        Container(
          width: 60.w,
          color: Theme.of(context).cardColor,
          child: _buildIndicatorButtons(isPortrait: false),
        ),
      ],
    );
  }

  Widget _buildTopInfo() {
    final entity = _selectedEntity ?? _datas.last;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Row(
        children: [
          if (_mainState == MainState.MA) ...[
            _buildIndexText('MA5', entity.ma5, const Color(0xFFE9C56A)),
            SizedBox(width: 8.w),
            _buildIndexText('MA10', entity.ma10, const Color(0xFF4DB6AC)),
            SizedBox(width: 8.w),
            _buildIndexText('MA30', entity.ma30, const Color(0xFF9575CD)),
          ],
          if (_mainState == MainState.BOLL)
            _buildIndexText('BOLL', entity.close, Colors.blue),

          SizedBox(width: 20.w),
          if (_subState == SubState.VOL)
            _buildIndexText('VOL', entity.volume, Colors.grey),
          if (_subState == SubState.MACD)
            _buildIndexText('MACD', entity.macd, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildIndexText(String name, double? value, Color color) {
    return AppText.xSmall(
      minFontSize: 6,
      '$name:${value?.toStringAsFixed(2) ?? '--'}',
      color: color,
    );
  }

  Widget _buildIndicatorButtons({required bool isPortrait}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isPortrait) ...[
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: widget.onFullScreenToggle,
          ),
        ] else ...[
          AppText.smallBold('Main'),
          _buildTextBtn(
            'MA',
            _mainState == MainState.MA,
            () => setState(() => _mainState = MainState.MA),
          ),
          _buildTextBtn(
            'BOLL',
            _mainState == MainState.BOLL,
            () => setState(() => _mainState = MainState.BOLL),
          ),
          _buildTextBtn(
            'Hide',
            _mainState == MainState.NONE,
            () => setState(() => _mainState = MainState.NONE),
          ),
          SizedBox(height: 10.h),
          AppText.smallBold('Sub'),
          _buildTextBtn(
            'VOL',
            _subState == SubState.VOL,
            () => setState(() => _subState = SubState.VOL),
          ),
          _buildTextBtn(
            'MACD',
            _subState == SubState.MACD,
            () => setState(() => _subState = SubState.MACD),
          ),
          _buildTextBtn(
            'KDJ',
            _subState == SubState.KDJ,
            () => setState(() => _subState = SubState.KDJ),
          ),
          _buildTextBtn(
            'Hide',
            _subState == SubState.NONE,
            () => setState(() => _subState = SubState.NONE),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.fullscreen_exit),
            onPressed: widget.onFullScreenToggle,
          ),
        ],
      ],
    );
  }

  Widget _buildTextBtn(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: AppText.xSmall(
          text,
          color: isSelected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  // 构建主图 (K线 + MA)
  Widget _buildMainChart() {
    // 获取当前可视区域的数据
    final visibleData = _datas.sublist(
      _startIndex,
      min(_startIndex + _visibleCount, _datas.length),
    );

    double minY = double.infinity;
    double maxY = -double.infinity;
    for (var e in visibleData) {
      minY = min(minY, e.low);
      maxY = max(maxY, e.high);
    }
    double range = maxY - minY;
    minY -= range * 0.1;
    maxY += range * 0.1;

    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          // 处理鼠标滚轮缩放
          final double scale = event.scrollDelta.dy < 0 ? 1.1 : 0.9;
          setState(() {
            int newVisibleCount = (_visibleCount / scale).round();
            newVisibleCount = newVisibleCount.clamp(
              _minVisibleCount,
              min(_maxVisibleCount, _datas.length),
            );

            // 保持中心点缩放
            int centerIndex = _startIndex + _visibleCount ~/ 2;
            int newStartIndex = centerIndex - newVisibleCount ~/ 2;

            _visibleCount = newVisibleCount;
            _startIndex = newStartIndex.clamp(0, _datas.length - _visibleCount);
          });
        }
      },
      child: GestureDetector(
        onScaleUpdate: (details) {
          setState(() {
            // 缩放
            if (details.scale != 1.0) {
              double scale = details.scale;
              int newVisibleCount = (_visibleCount / scale).round();
              newVisibleCount = newVisibleCount.clamp(
                _minVisibleCount,
                min(_maxVisibleCount, _datas.length),
              );

              // 保持中心点缩放
              int centerIndex = _startIndex + _visibleCount ~/ 2;
              int newStartIndex = centerIndex - newVisibleCount ~/ 2;

              _visibleCount = newVisibleCount;
              _startIndex = newStartIndex.clamp(
                0,
                _datas.length - _visibleCount,
              );
            }
            // 平移
            else if (details.pointerCount == 1 && details.scale == 1.0) {
              // 仅处理单指水平移动
              double dx = details.focalPointDelta.dx;
              int moveCount = (dx / 5).round(); // 增加灵敏度 (原为10)
              if (moveCount != 0) {
                _startIndex -= moveCount;
                _startIndex = _startIndex.clamp(
                  0,
                  _datas.length - _visibleCount,
                );
              }
            }
          });
        },
        child: Stack(
          children: [
            // 1. MA 线 (LineChart) - 底层
            if (_mainState == MainState.MA)
              LineChart(
                LineChartData(
                  minY: minY,
                  maxY: maxY,
                  minX: 0,
                  maxX: (visibleData.length - 1).toDouble(),
                  lineBarsData: [
                    _buildLineBarData(
                      visibleData.map((e) => e.ma5).toList(),
                      const Color(0xFFE9C56A),
                    ),
                    _buildLineBarData(
                      visibleData.map((e) => e.ma10).toList(),
                      const Color(0xFF4DB6AC),
                    ),
                    _buildLineBarData(
                      visibleData.map((e) => e.ma30).toList(),
                      const Color(0xFF9575CD),
                    ),
                  ],
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  lineTouchData: LineTouchData(enabled: false),
                ),
              ),

            // 2. K 线图 (CandlestickChart) - 上层，负责交互
            // 注意: fl_chart 最新版可能没有 CandlestickChart，这里暂时使用 BarChart 模拟或注释
            // 如果需要专业的K线图，建议使用 k_chart 库
            // 这里为了解决编译错误，暂时注释掉 CandlestickChart 的使用
            /*
            CandlestickChart(
              CandlestickChartData(
                candlestickSpots: visibleData.asMap().entries.map((e) {
                  final index = e.key;
                  final item = e.value;
                  return CandlestickSpot(
                    x: index.toDouble(),
                    open: item.open,
                    high: item.high,
                    low: item.low,
                    close: item.close,
                  );
                }).toList(),
                minY: minY,
                maxY: maxY,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.withOpacity(0.1)),
                  getDrawingVerticalLine: (value) =>
                      FlLine(color: Colors.grey.withOpacity(0.1)),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                candlestickTouchData: CandlestickTouchData(
                  enabled: false, // 禁用 fl_chart 内置触摸，防止冲突
                ),
              ),
            ),
            */
          ],
        ),
      ),
    );
  }

  LineChartBarData _buildLineBarData(List<double?> values, Color color) {
    return LineChartBarData(
      spots: values.asMap().entries.where((e) => e.value != null).map((e) {
        return FlSpot(e.key.toDouble(), e.value!);
      }).toList(),
      color: color,
      dotData: FlDotData(show: false),
      barWidth: 1,
      isCurved: true,
    );
  }

  // 构建副图 (VOL/MACD)
  Widget _buildSubChart() {
    // 同样只显示可视区域的数据
    final visibleData = _datas.sublist(
      _startIndex,
      min(_startIndex + _visibleCount, _datas.length),
    );

    if (_subState == SubState.VOL) {
      return BarChart(
        BarChartData(
          barGroups: visibleData.asMap().entries.map((e) {
            final index = e.key;
            final item = e.value;
            final isUp = item.close >= item.open;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.volume,
                  color: isUp
                      ? const Color(0xFF00C087)
                      : const Color(0xFFFD5353),
                  width: 4,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox();
                  return Text(
                    '${(value / 1000).toStringAsFixed(0)}k',
                    style: const TextStyle(fontSize: 8, color: Colors.grey),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barTouchData: BarTouchData(
            enabled: true,
            touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
              if (response?.spot != null && event is! FlTapUpEvent) {
                final index = response!.spot!.touchedBarGroupIndex;
                if (index >= 0 && index < visibleData.length) {
                  setState(() {
                    _selectedEntity = visibleData[index];
                  });
                }
              }
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return null; // 不显示默认 tooltip，使用顶部信息栏
              },
            ),
          ),
        ),
      );
    } else if (_subState == SubState.MACD) {
      return BarChart(
        BarChartData(
          barGroups: visibleData.asMap().entries.map((e) {
            final index = e.key;
            final item = e.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.macd ?? 0,
                  color: (item.macd ?? 0) >= 0
                      ? const Color(0xFF00C087)
                      : const Color(0xFFFD5353),
                  width: 4,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barTouchData: BarTouchData(
            enabled: true,
            touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
              if (response?.spot != null && event is! FlTapUpEvent) {
                final index = response!.spot!.touchedBarGroupIndex;
                if (index >= 0 && index < visibleData.length) {
                  setState(() {
                    _selectedEntity = visibleData[index];
                  });
                }
              }
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return null;
              },
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
