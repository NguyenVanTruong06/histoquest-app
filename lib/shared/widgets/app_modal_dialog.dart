import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'primary_button.dart';
import 'secondary_button.dart';

enum DialogType { info, success, warning, danger }

class AppModalDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final IconData? icon;
  final DialogType type;
  final String confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppModalDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.icon,
    this.type = DialogType.info,
    this.confirmText = 'Xác nhận',
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? message,
    Widget? content,
    IconData? icon,
    DialogType type = DialogType.info,
    String confirmText = 'Xác nhận',
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: cancelText != null,
      barrierColor: const Color(0xFF25221F).withValues(alpha: 0.45),
      builder: (context) => AppModalDialog(
        title: title,
        message: message,
        content: content,
        icon: icon,
        type: type,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color typeColor;
    Color typeBgColor;
    IconData defaultIcon;

    switch (type) {
      case DialogType.info:
        typeColor = AppColors.primary;
        typeBgColor = AppColors.primaryLight;
        defaultIcon = Icons.info_outline_rounded;
        break;
      case DialogType.success:
        typeColor = AppColors.goldDark;
        typeBgColor = AppColors.goldLight;
        defaultIcon = Icons.emoji_events_rounded;
        break;
      case DialogType.warning:
        typeColor = AppColors.goldDark;
        typeBgColor = AppColors.goldLight;
        defaultIcon = Icons.warning_amber_rounded;
        break;
      case DialogType.danger:
        typeColor = AppColors.danger;
        typeBgColor = const Color(0xFFFDEDE7);
        defaultIcon = Icons.error_outline_rounded;
        break;
    }

    final effectiveIcon = icon ?? defaultIcon;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.cardBorder, width: 1.2),
      ),
      elevation: 10,
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top circular icon badge
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: typeBgColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: typeColor.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: Icon(
                effectiveIcon,
                color: typeColor,
                size: 34,
              ),
            ),
            const SizedBox(height: 18),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),

            // Optional Message
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],

            // Optional Custom Content Widget
            if (content != null) ...[
              const SizedBox(height: 16),
              content!,
            ],

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                if (cancelText != null) ...[
                  Expanded(
                    child: SecondaryButton(
                      label: cancelText!,
                      height: 52,
                      fontSize: 15,
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        onCancel?.call();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: PrimaryButton(
                    label: confirmText,
                    height: 52,
                    fontSize: 15,
                    backgroundColor: type == DialogType.danger ? AppColors.danger : null,
                    shadowColor: type == DialogType.danger ? const Color(0xFF991B1B) : null,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm?.call();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
