import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/quiz_models.dart';

class TrueFalseWidget extends StatelessWidget {
  final QuizItem item;
  final bool? selectedValue;
  final AnswerStatus status;
  final ValueChanged<bool> onSelectValue;

  const TrueFalseWidget({
    super.key,
    required this.item,
    required this.selectedValue,
    required this.status,
    required this.onSelectValue,
  });

  @override
  Widget build(BuildContext context) {
    final isAnswered = status != AnswerStatus.unanswered;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge loại câu hỏi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE4A93A).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              'ĐÚNG HAY SAI?',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8A5D12),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Thẻ nhận định lịch sử phong cách cổ sử
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.cardBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.format_quote_rounded, color: AppColors.primary, size: 28),
                    SizedBox(width: 6),
                    Text(
                      'Nhận định:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.question,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.45,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // 2 Thẻ chọn: ĐÚNG hoặc SAI
          Row(
            children: [
              // Thẻ ĐÚNG
              Expanded(
                child: _buildChoiceCard(
                  label: 'ĐÚNG',
                  value: true,
                  icon: Icons.check_circle_outline_rounded,
                  activeColor: const Color(0xFF2E7D32),
                  activeBgColor: const Color(0xFFE8F5E9),
                  isAnswered: isAnswered,
                ),
              ),
              const SizedBox(width: 14),
              // Thẻ SAI
              Expanded(
                child: _buildChoiceCard(
                  label: 'SAI',
                  value: false,
                  icon: Icons.highlight_off_rounded,
                  activeColor: const Color(0xFFD32F2F),
                  activeBgColor: const Color(0xFFFFEBEE),
                  isAnswered: isAnswered,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceCard({
    required String label,
    required bool value,
    required IconData icon,
    required Color activeColor,
    required Color activeBgColor,
    required bool isAnswered,
  }) {
    final isSelected = selectedValue == value;
    final isTargetCorrect = item.correctBool == value;

    Color borderColor = AppColors.cardBorder;
    Color bgColor = Colors.white;
    Color textColor = AppColors.textPrimary;
    Color iconColor = AppColors.textSecondary;

    if (isAnswered) {
      if (isTargetCorrect) {
        // Đáp án đúng luôn tô XANH
        borderColor = const Color(0xFF2E7D32);
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF1B5E20);
        iconColor = const Color(0xFF2E7D32);
      } else if (isSelected) {
        // Đáp án người dùng chọn nhưng sai -> tô ĐỎ
        borderColor = const Color(0xFFD32F2F);
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFB71C1C);
        iconColor = const Color(0xFFD32F2F);
      } else {
        textColor = AppColors.textSecondary.withValues(alpha: 0.4);
        iconColor = AppColors.textSecondary.withValues(alpha: 0.4);
      }
    } else if (isSelected) {
      borderColor = AppColors.primary;
      bgColor = AppColors.primaryLight;
      textColor = AppColors.primaryDark;
      iconColor = AppColors.primaryDark;
    }

    return InkWell(
      onTap: isAnswered ? null : () => onSelectValue(value),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: isSelected || (isAnswered && isTargetCorrect) ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: iconColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
