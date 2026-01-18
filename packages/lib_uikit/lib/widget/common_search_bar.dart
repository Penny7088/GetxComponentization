import 'package:flutter/material.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonSearchBar extends StatefulWidget {
  final bool enabled;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const CommonSearchBar({
    super.key,
    this.enabled = true,
    this.hintText = 'Cryptocoin search',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.controller,
    this.padding,
    this.backgroundColor,
  });

  @override
  State<CommonSearchBar> createState() => _CommonSearchBarState();
}

class _CommonSearchBarState extends State<CommonSearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleFocusChange() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  void _onClear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    // Grey color for icon and text when inactive
    final inactiveColor = theme.disabledColor;

    // Icon color: Blue when focused or has text (active), otherwise Grey
    final iconColor = (_isFocused || _hasText)
        ? const Color(0xFF2F66F6)
        : const Color(0xFF7D8595);

    Widget content = Container(
      height: 56.h,
      padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(28.r), // Capsule shape
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search Icon
          Icon(Icons.search_rounded, color: iconColor, size: 24.sp),
          SizedBox(width: 12.w),

          // Input Area
          Expanded(
            child: widget.enabled
                ? TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: theme.textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFFC3C7D0), // Lighter grey for hint
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : AppText.medium(
                    widget.hintText,
                    color: const Color(0xFFC3C7D0),
                  ),
          ),

          // Clear Button (Only show when enabled and has text)
          if (widget.enabled && _hasText) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: _onClear,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF7D8595),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 14.sp,
                  color: const Color(0xFF7D8595),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (!widget.enabled) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
