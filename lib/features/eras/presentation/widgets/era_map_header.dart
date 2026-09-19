import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/era_model.dart';

/// Header đỉnh cho Màn hình Bản đồ Sự kiện (EraEventsMapScreen).
///
/// Thiết kế đồng bộ hoàn toàn với tông màu chủ đạo HistoQuest (AppColors.primary):
/// - Header phẳng mép đáy (borderRadius: BorderRadius.zero).
/// - Hàng 1: Nút Back tròn trắng mờ + Tên thời kỳ + Bộ đôi pill trắng Xu & Streak.
/// - Hàng 2: Thế kỷ lịch sử + Thanh tiến trình mốc sự kiện vàng kim.
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
    final topPadding = MediaQuery.paddingOf(context).top;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 6,
        left: 14,
        right: 14,
        bottom: 10,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.zero,
        boxShadow: [
          BoxShadow(
            color: Color(0x28000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hàng 1: Nút back + Tên thời kỳ + Pill Xu / Streak
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nút quay lại tròn trắng mờ
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Tên thời kỳ
              Expanded(
                child: Text(
                  era.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Pill xu vàng
              _buildPill(
                icon: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3B438),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.monetization_on_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
                label: '${userCoins.toString().padLeft(3, '0')} xu',
              ),

              const SizedBox(width: 6),

              // Pill chuỗi ngày (ngọn lửa)
              _buildPill(
                icon: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFFF5A1F),
                  size: 16,
                ),
                label: '$streakDays ngày',
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Hàng 2: Tiêu đề thế kỷ + Chỉ số tiến độ
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                era.centuryTitle.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.85),
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              Text(
                '$completedCount/$totalCount mốc',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(width: 8),
              // Mini progress bar
              Container(
                width: 75,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD54F),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill({required Widget icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C2F28),
            ),
          ),
        ],
      ),
    );
  }
}
