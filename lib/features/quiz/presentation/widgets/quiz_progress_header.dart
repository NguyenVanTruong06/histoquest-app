import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';

class QuizProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onExit;

  const QuizProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onExit,
  });

  void _confirmExit(BuildContext context) {
    AppModalDialog.show(
      context,
      title: 'Dừng bài học?',
      message: 'Tiến trình bài học này sẽ không được lưu nếu bạn thoát ra bây giờ.',
      type: DialogType.warning,
      icon: Icons.priority_high_rounded,
      confirmText: 'Rời đi',
      cancelText: 'Học tiếp',
      onConfirm: onExit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = totalSteps == 0 ? 0.0 : (currentStep / totalSteps).clamp(0.0, 1.0);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: [
            // Nút đóng
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 26, color: AppColors.textPrimary),
              onPressed: () => _confirmExit(context),
              tooltip: 'Thoát bài học',
            ),
            const SizedBox(width: 8),

            // Thanh tiến trình kiểu viên thuốc (Capsule Progress Bar)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: SizedBox(
                  height: 12,
                  child: Stack(
                    children: [
                      // Nền thanh bar
                      Container(color: const Color(0xFFE8E0D2)),
                      // Đoạn tiến độ có hoạt ảnh mượt
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE4A93A), Color(0xFFD95D39)],
                            ),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Huy hiệu câu hỏi hiện tại
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: AppColors.primaryDark, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    '$currentStep/$totalSteps',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
