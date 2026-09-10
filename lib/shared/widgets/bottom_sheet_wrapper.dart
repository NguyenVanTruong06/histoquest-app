import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BottomSheetWrapper extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showCloseButton;
  final Widget? bottomAction;
  final EdgeInsetsGeometry contentPadding;

  const BottomSheetWrapper({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.showCloseButton = true,
    this.bottomAction,
    this.contentPadding = const EdgeInsets.fromLTRB(22, 10, 22, 28),
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    String? subtitle,
    bool showCloseButton = true,
    Widget? bottomAction,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      barrierColor: const Color(0xFF25221F).withValues(alpha: 0.42),
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetWrapper(
        title: title,
        subtitle: subtitle,
        showCloseButton: showCloseButton,
        bottomAction: bottomAction,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1.2)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(45, 43, 43, 0.22),
            blurRadius: 40,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle chuẩn HistoQuest (52x5, #DED4C4, margin 12 top 16 bottom)
              Center(
                child: Container(
                  width: 52,
                  height: 5,
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),

              // Header (Title & Close Button)
              if (title != null || showCloseButton) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null)
                              Text(
                                title!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 3),
                              Text(
                                subtitle!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (showCloseButton)
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded, size: 22),
                          color: AppColors.textSecondary,
                          splashRadius: 20,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.cardBorder),
              ],

              // Main Body Content
              Padding(
                padding: contentPadding,
                child: child,
              ),

              // Optional Bottom Action
              if (bottomAction != null) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
                  child: bottomAction!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
