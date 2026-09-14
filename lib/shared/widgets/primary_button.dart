import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? textColor;
  final double height;
  final double fontSize;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.shadowColor,
    this.textColor,
    this.height = 56,
    this.fontSize = 17,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = widget.backgroundColor ?? AppColors.primary;
    final effectiveShadowColor = widget.shadowColor ?? AppColors.primaryDark;
    final effectiveTextColor = widget.textColor ?? Colors.white;
    final isDisabled = widget.onPressed == null || widget.isLoading;

    final double bottomOffset = _isPressed || isDisabled ? 0 : 5;
    final double topMargin = _isPressed ? 5 : 0;

    Widget content = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (widget.icon != null) ...[
          widget.icon!,
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w600,
              color: effectiveTextColor,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );

    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      height: widget.height + 5,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        margin: EdgeInsets.only(top: topMargin, bottom: 5 - bottomOffset),
        height: widget.height,
        decoration: BoxDecoration(
          color: isDisabled ? effectiveBgColor.withValues(alpha: 0.5) : effectiveBgColor,
          borderRadius: BorderRadius.circular(99),
          boxShadow: bottomOffset > 0
              ? [
                  BoxShadow(
                    color: effectiveShadowColor,
                    offset: Offset(0, bottomOffset),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(99),
          child: InkWell(
            onTap: isDisabled ? null : widget.onPressed,
            onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
            onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
            onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
            borderRadius: BorderRadius.circular(99),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
