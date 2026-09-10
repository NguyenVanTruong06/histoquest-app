import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/quiz_models.dart';

class SingleChoiceWidget extends StatelessWidget {
  final QuizItem item;
  final int? selectedIndex;
  final AnswerStatus status;
  final ValueChanged<int> onSelectOption;

  const SingleChoiceWidget({
    super.key,
    required this.item,
    required this.selectedIndex,
    required this.status,
    required this.onSelectOption,
  });

  @override
  Widget build(BuildContext context) {
    final letters = ['A', 'B', 'C', 'D'];
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
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              'CHỌN 1 TRONG 4',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Nội dung câu hỏi
          Text(
            item.question,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.35,
              letterSpacing: -0.3,
            ),
          ),
          if (item.subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              item.subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],

          const SizedBox(height: 24),

          // 4 Đáp án
          ...List.generate(item.options.length, (index) {
            final optionText = item.options[index];
            final letter = letters[index % letters.length];
            final isSelected = selectedIndex == index;
            final isCorrectAnswer = item.correctIndex == index;

            Color borderColor = AppColors.cardBorder;
            Color bgColor = Colors.white;
            Color textColor = AppColors.textPrimary;
            Color badgeBgColor = const Color(0xFFF7F2E8);
            Color badgeTextColor = AppColors.textPrimary;
            Widget? trailingIcon;

            if (isAnswered) {
              if (isCorrectAnswer) {
                // Đáp án đúng luôn tô màu XANH
                borderColor = const Color(0xFF2E7D32);
                bgColor = const Color(0xFFE8F5E9);
                textColor = const Color(0xFF1B5E20);
                badgeBgColor = const Color(0xFF2E7D32);
                badgeTextColor = Colors.white;
                trailingIcon = const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 22);
              } else if (isSelected) {
                // Đáp án người dùng chọn nhưng SAI -> tô màu ĐỎ
                borderColor = const Color(0xFFD32F2F);
                bgColor = const Color(0xFFFFEBEE);
                textColor = const Color(0xFFB71C1C);
                badgeBgColor = const Color(0xFFD32F2F);
                badgeTextColor = Colors.white;
                trailingIcon = const Icon(Icons.cancel_rounded, color: Color(0xFFD32F2F), size: 22);
              } else {
                // Các đáp án còn lại làm mờ
                textColor = AppColors.textSecondary.withValues(alpha: 0.5);
                badgeTextColor = AppColors.textSecondary.withValues(alpha: 0.5);
              }
            } else if (isSelected) {
              // Đang chọn trước khi bấm Kiểm tra -> Viền Đất Nung HistoQuest
              borderColor = AppColors.primary;
              bgColor = AppColors.primaryLight;
              textColor = AppColors.primaryDark;
              badgeBgColor = AppColors.primary;
              badgeTextColor = Colors.white;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: isAnswered ? null : () => onSelectOption(index),
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: borderColor,
                      width: isSelected || (isAnswered && isCorrectAnswer) ? 2.0 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Ký hiệu chữ cái A, B, C, D
                      Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: badgeTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Nội dung câu trả lời
                      Expanded(
                        child: Text(
                          optionText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: textColor,
                            height: 1.35,
                          ),
                        ),
                      ),

                      if (trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        trailingIcon,
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
