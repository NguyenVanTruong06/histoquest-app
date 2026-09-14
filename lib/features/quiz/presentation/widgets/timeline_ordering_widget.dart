import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/quiz_models.dart';

class TimelineOrderingWidget extends StatelessWidget {
  final QuizItem item;
  final List<TimelineItem> currentItems;
  final AnswerStatus status;
  final void Function(int oldIndex, int newIndex) onReorder;

  const TimelineOrderingWidget({
    super.key,
    required this.item,
    required this.currentItems,
    required this.status,
    required this.onReorder,
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
              color: const Color(0xFF5C6BC0).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              'SẮP XẾP THỨ TỰ THỜI GIAN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF283593),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tiêu đề câu hỏi
          Text(
            item.question,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.35,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.touch_app_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isAnswered
                      ? 'Kết quả đối chiếu theo thứ tự lịch sử:'
                      : 'Nhấn giữ biểu tượng ☰ và kéo thả từ sớm nhất đến muộn nhất:',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Danh sách kéo thả ReorderableListView
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentItems.length,
              onReorderItem: isAnswered ? (_, _) {} : onReorder,
              buildDefaultDragHandles: false,
              itemBuilder: (context, index) {
                final timelineItem = currentItems[index];
                final isCorrectPosition = index < item.correctOrderIds.length &&
                    item.correctOrderIds[index] == timelineItem.id;

                Color borderColor = AppColors.cardBorder;
                Color bgColor = Colors.white;
                Color badgeBgColor = const Color(0xFFF7F2E8);
                Color badgeTextColor = AppColors.textPrimary;

                if (isAnswered) {
                  if (isCorrectPosition) {
                    borderColor = const Color(0xFF2E7D32);
                    bgColor = const Color(0xFFE8F5E9);
                    badgeBgColor = const Color(0xFF2E7D32);
                    badgeTextColor = Colors.white;
                  } else {
                    borderColor = const Color(0xFFD32F2F);
                    bgColor = const Color(0xFFFFEBEE);
                    badgeBgColor = const Color(0xFFD32F2F);
                    badgeTextColor = Colors.white;
                  }
                }

                return Padding(
                  key: ValueKey(timelineItem.id),
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: isAnswered ? 2.0 : 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Thứ tự số 1, 2, 3, 4
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: badgeTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Nội dung sự kiện
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                timelineItem.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  height: 1.3,
                                ),
                              ),
                              if (isAnswered) ...[
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isCorrectPosition
                                        ? const Color(0xFF2E7D32).withValues(alpha: 0.15)
                                        : const Color(0xFFD32F2F).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Năm ${timelineItem.year}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isCorrectPosition
                                          ? const Color(0xFF1B5E20)
                                          : const Color(0xFFB71C1C),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Drag handle kéo thả
                        if (!isAnswered)
                          ReorderableDragStartListener(
                            index: index,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F2E8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.drag_handle_rounded,
                                color: AppColors.textSecondary,
                                size: 22,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
