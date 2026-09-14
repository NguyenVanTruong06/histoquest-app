import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/news_article_model.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/stat_badge.dart';

/// Banner sự kiện tuần nổi bật theo phong cách Board Game / Gamification
class WeeklyEventBanner extends StatelessWidget {
  final WeeklyEventModel event;
  final VoidCallback onAction;

  const WeeklyEventBanner({
    super.key,
    required this.event,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBackground.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Hoa văn nền mờ cổ điển
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.shield_outlined,
              size: 160,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hàng nhãn: Sự kiện tuần & Thời gian hết hạn
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.stars_rounded,
                            size: 14,
                            color: AppColors.goldLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.badgeText,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: AppColors.gold,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.expiresText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Tiêu đề sự kiện
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),

                // Mô tả sự kiện
                Text(
                  event.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),

                // Tiến trình hoàn thành sự kiện
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mục tiêu tuần: 2/3 ải hoàn thành',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          '${(event.progressPercent * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: event.progressPercent,
                        minHeight: 8,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Hàng phần thưởng
                Row(
                  children: [
                    Text(
                      'Thưởng:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatBadge(
                      type: StatType.xp,
                      label: '+${event.rewardXp} XP',
                    ),
                    const SizedBox(width: 8),
                    StatBadge(
                      type: StatType.coin,
                      label: '+${event.rewardCoins} xu',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Nút hành động 3D
                PrimaryButton(
                  label: event.actionText,
                  icon: const Icon(Icons.flag_rounded, color: Colors.white, size: 20),
                  onPressed: onAction,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
