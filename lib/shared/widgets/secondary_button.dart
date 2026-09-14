import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? borderColor;
  final Color? textColor;
  final double height;
  final double fontSize;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.borderColor,
    this.textColor,
    this.height = 56,
    this.fontSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppColors.primaryDark;
    final effectiveTextColor = textColor ?? AppColors.primaryDark;
    final isDisabled = onPressed == null || isLoading;

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: isDisabled
                ? effectiveTextColor.withValues(alpha: 0.5)
                : effectiveTextColor,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );

    return SizedBox(
      height: height,
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDisabled
                ? effectiveBorderColor.withValues(alpha: 0.3)
                : effectiveBorderColor,
            width: 1.5,
          ),
          foregroundColor: effectiveTextColor,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: content,
      ),
    );
  }
}
