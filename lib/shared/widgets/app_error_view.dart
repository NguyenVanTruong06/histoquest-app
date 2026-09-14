import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'primary_button.dart';

/// Widget hiển thị trạng thái lỗi tải dữ liệu (Error State) theo phong cách HistoQuest
class AppErrorView extends StatelessWidget {
  final String title;
  final String errorMessage;
  final String retryText;
  final VoidCallback onRetry;

  const AppErrorView({
    super.key,
    this.title = 'Không thể tải dữ liệu',
    this.errorMessage = 'Đã có lỗi xảy ra trong quá trình kết nối. Vui lòng kiểm tra lại đường truyền và thử lại.',
    this.retryText = 'Thử lại ngay',
    required this.onRetry,
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
                color: AppColors.danger.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.danger.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.danger.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 46,
                  color: AppColors.danger,
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
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: retryText,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
