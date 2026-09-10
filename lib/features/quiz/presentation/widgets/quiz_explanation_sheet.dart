import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/quiz_models.dart';
import '../../../../shared/widgets/primary_button.dart';

class QuizExplanationSheet extends StatelessWidget {
  final AnswerStatus status;
  final bool isButtonEnabled;
  final bool isLastQuestion;
  final QuizItem currentItem;
  final VoidCallback onCheckAnswer;
  final VoidCallback onContinue;

  const QuizExplanationSheet({
    super.key,
    required this.status,
    required this.isButtonEnabled,
    required this.isLastQuestion,
    required this.currentItem,
    required this.onCheckAnswer,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isAnswered = status != AnswerStatus.unanswered;
    final isCorrect = status == AnswerStatus.correct;

    Color containerBg = Colors.white;
    if (isAnswered) {
      containerBg = isCorrect ? const Color(0xFFEDF7ED) : const Color(0xFFFDF2F2);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Khu vực Giải thích (Explanation) sau khi đã bấm Kiểm tra
              if (isAnswered) ...[
                Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isCorrect ? 'Chính xác! 🎉' : 'Chưa đúng rồi! 💡',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Nội dung giải thích lịch sử
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCorrect
                          ? const Color(0xFF2E7D32).withValues(alpha: 0.25)
                          : const Color(0xFFD32F2F).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentItem.explanation,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          height: 1.45,
                        ),
                      ),
                      if (currentItem.funFact != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          currentItem.funFact!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isCorrect ? const Color(0xFF1B5E20) : const Color(0xFF8A5D12),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Nút hành động: "KIỂM TRA" hoặc "TIẾP TỤC"
              PrimaryButton(
                label: isAnswered
                    ? (isLastQuestion ? 'Hoàn thành bài học' : 'Tiếp tục')
                    : 'Kiểm tra',
                isFullWidth: true,
                height: 56,
                icon: Icon(
                  isAnswered ? Icons.arrow_forward_rounded : Icons.verified_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: isAnswered
                    ? onContinue
                    : (isButtonEnabled ? onCheckAnswer : null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
