import 'package:flutter/material.dart';
import 'package:lib_base/utils/extensions/context_extensions.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:lib_uikit/widget/shadow_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TabBarStyle {
  pill, // Original style: individual pills
  segment, // New style: connected segment with dividers
}

class CommonTabBar extends StatefulWidget {
  final List<String> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final TabBarStyle style;
  final double? height;

  final Color? unselectedLabelColor;
  final Color? labelColor;
  final EdgeInsetsGeometry? labelPadding;

  const CommonTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.isScrollable = true,
    this.padding,
    this.style = TabBarStyle.pill,
    this.height,
    this.unselectedLabelColor,
    this.labelColor,
    this.labelPadding,
  });

  /// Factory for Pill Style (Default)
  factory CommonTabBar.pill({
    required List<String> tabs,
    TabController? controller,
    ValueChanged<int>? onTap,
    bool isScrollable = true,
    EdgeInsetsGeometry? padding,
    double? height,
    Color? unselectedLabelColor,
    Color? labelColor,
    EdgeInsetsGeometry? labelPadding,
  }) {
    return CommonTabBar(
      tabs: tabs,
      controller: controller,
      onTap: onTap,
      isScrollable: isScrollable,
      padding: padding,
      style: TabBarStyle.pill,
      height: height,
      unselectedLabelColor: unselectedLabelColor,
      labelColor: labelColor,
      labelPadding: labelPadding,
    );
  }

  /// Factory for Segment Style
  factory CommonTabBar.segment({
    required List<String> tabs,
    TabController? controller,
    ValueChanged<int>? onTap,
    EdgeInsetsGeometry? padding,
    double? height,
    Color? unselectedLabelColor,
    Color? labelColor,
    EdgeInsetsGeometry? labelPadding,
  }) {
    return CommonTabBar(
      tabs: tabs,
      controller: controller,
      onTap: onTap,
      isScrollable: false, // Segment usually fixed width
      padding: padding,
      style: TabBarStyle.segment,
      height: height,
      unselectedLabelColor: unselectedLabelColor,
      labelColor: labelColor,
      labelPadding: labelPadding,
    );
  }

  @override
  State<CommonTabBar> createState() => _CommonTabBarState();
}

class _CommonTabBarState extends State<CommonTabBar>
    with TickerProviderStateMixin {
  TabController? _controller;
  bool _isControllerInternal = false;
  int curIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateController();
  }

  @override
  void didUpdateWidget(CommonTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateController();
    }
  }

  void _updateController() {
    final TabController? newController =
        widget.controller ?? DefaultTabController.of(context);

    if (newController == _controller && newController != null) return;

    if (newController == null &&
        _isControllerInternal &&
        _controller?.length == widget.tabs.length) {
      return;
    }

    if (_controller != null) {
      _controller!.removeListener(_handleTabSelection);
      if (_isControllerInternal) {
        _controller!.dispose();
      }
    }

    _controller = newController;

    if (_controller != null) {
      _controller!.addListener(_handleTabSelection);
      _isControllerInternal = false;
      curIndex = _controller!.index;
    } else {
      _controller = TabController(length: widget.tabs.length, vsync: this);
      _controller!.addListener(_handleTabSelection);
      _isControllerInternal = true;
      curIndex = _controller!.index;
    }
  }

  void _handleTabSelection() {
    if (curIndex != _controller!.index) {
      setState(() {
        curIndex = _controller!.index;
      });
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.removeListener(_handleTabSelection);
      if (_isControllerInternal) {
        _controller!.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.style == TabBarStyle.segment) {
      return _buildSegmentStyle(context);
    }
    return _buildPillStyle(context);
  }

  Widget _buildSegmentStyle(BuildContext context) {
    final segmentHeight = widget.height ?? 32.h;
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      margin: widget.padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      height: segmentHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          // Dividers
          Row(
            children: List.generate(widget.tabs.length, (index) {
              return Expanded(
                child: index < widget.tabs.length - 1
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 1,
                          height: 16.h,
                          color: Theme.of(context).dividerColor,
                        ),
                      )
                    : const SizedBox(),
              );
            }),
          ),
          // TabBar
          TabBar(
            controller: _controller,
            isScrollable: false, // Segment style usually not scrollable
            onTap: widget.onTap,
            dividerColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            indicatorPadding: EdgeInsets.all(4.w),
            indicator: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.zero,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabs: List.generate(widget.tabs.length, (index) {
              final tab = widget.tabs[index];
              final isSelected = curIndex == index;
              return Tab(
                child: Center(
                  child: AppText.small(
                    tab,
                    color: isSelected
                        ? widget.labelColor
                        : widget.unselectedLabelColor,
                  ),
                ),
              );
            }),
            labelColor:
                widget.labelColor ??
                Theme.of(context).primaryColor, // Selected text color
            unselectedLabelColor:
                widget.unselectedLabelColor ??
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(
                  0.6,
                ), // Unselected text color
          ),
        ],
      ),
    );
  }

  Widget _buildPillStyle(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      height: widget.height,
      padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: TabBar(
        controller: _controller,
        isScrollable: widget.isScrollable,
        tabAlignment: TabAlignment.start,
        onTap: widget.onTap,
        dividerColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        indicator: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding:
            widget.labelPadding ?? EdgeInsets.symmetric(horizontal: 6.w),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: List.generate(widget.tabs.length, (index) {
          final isSelected = index == curIndex;
          final tab = widget.tabs[index];

          return Tab(
            child: ShadowCard(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              borderRadius: 12.r,
              backgroundColor: isSelected
                  ? Colors.transparent
                  : Theme.of(context).cardColor,
              shadowColor: isSelected ? Colors.transparent : null,
              child: AppText.mediumBold(
                tab,
                color: isSelected
                    ? widget.labelColor ?? Colors.white
                    : widget.unselectedLabelColor ?? const Color(0xFF7D8595),
              ),
            ),
          );
        }),
        labelColor: widget.labelColor ?? Colors.white,
        unselectedLabelColor:
            widget.unselectedLabelColor ?? const Color(0xFF7D8595),
      ),
    );
  }
}
