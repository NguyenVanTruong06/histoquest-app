import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'primary_button.dart';

/// Widget hiển thị trạng thái danh sách rỗng (Empty State) theo phong cách HistoQuest
class AppEmptyView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const AppEmptyView({
    super.key,
    this.title = 'Chưa có bản ghi nào',
    this.message = 'Chưa có sự kiện hoặc bài viết nào trong mục này.',
    this.icon = Icons.auto_stories_outlined,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
                border: Border.all(
                  color: AppColors.cardBorder,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 46,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            if (actionText != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                label: actionText!,
                onPressed: onActionPressed!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
