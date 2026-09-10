import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/era_model.dart';
import '../../../../shared/widgets/stat_badge.dart';

/// Header đỉnh cho Màn hình Bản đồ Sự kiện (Bước 2)
class EraMapHeader extends StatelessWidget {
  final EraModel era;
  final int completedCount;
  final int totalCount;
  final int userXp;
  final int userCoins;
  final int streakDays;
  final VoidCallback onBack;

  const EraMapHeader({
    super.key,
    required this.era,
    required this.completedCount,
    required this.totalCount,
    required this.userXp,
    required this.userCoins,
    required this.streakDays,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 14,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2DDD2),
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // Hàng 1: Nút back + Stats chỉ số người chơi
          Row(
            children: [
              // Nút quay lại bo góc 3D
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE0DCD3), width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x153A2A1A),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Hàng Stats Gamification: XP, Xu, Lửa Streak
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatBadge(type: StatType.xp, label: '$userXp'),
                  const SizedBox(width: 6),
                  StatBadge(type: StatType.coin, label: '$userCoins'),
                  const SizedBox(width: 6),
                  StatBadge(type: StatType.streak, label: '$streakDays'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Hàng 2: Tiêu đề thời kỳ & Thanh tiến trình hoàn thành
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      era.centuryTitle.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      era.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Chỉ số tiến độ & thanh mini
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$completedCount / $totalCount sự kiện',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 90,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5DFC9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF3BF4B), Color(0xFFE4A93A)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
