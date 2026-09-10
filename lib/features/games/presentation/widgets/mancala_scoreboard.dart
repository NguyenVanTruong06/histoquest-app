import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/mancala_engine.dart';

/// Bảng điểm & chỉ báo lượt chơi đối kháng giữa Bạn và Máy (Trạng Tí)
class MancalaScoreboard extends StatelessWidget {
  final int playerScore;
  final int aiScore;
  final GameTurn currentTurn;
  final String statusMessage;

  const MancalaScoreboard({
    super.key,
    required this.playerScore,
    required this.aiScore,
    required this.currentTurn,
    required this.statusMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hàng thông tin Đối thủ (Máy / Trạng Tí)
        _buildPlayerCard(
          name: 'Trạng Tí (Đối thủ AI)',
          title: 'Kỳ thủ Dân gian',
          score: aiScore,
          isTurn: currentTurn == GameTurn.ai,
          avatarIcon: Icons.psychology_rounded,
          avatarBgColor: const Color(0xFF5D4037),
        ),

        const SizedBox(height: 10),

        // Thanh trạng thái lượt đi trung tâm
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: currentTurn == GameTurn.player
                ? AppColors.primary.withValues(alpha: 0.12)
                : const Color(0xFFF0EBE1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: currentTurn == GameTurn.player
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : const Color(0xFFD4CABB),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                currentTurn == GameTurn.player
                    ? Icons.touch_app_rounded
                    : Icons.hourglass_top_rounded,
                size: 16,
                color: currentTurn == GameTurn.player
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  statusMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: currentTurn == GameTurn.player
                        ? AppColors.primaryDark
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Hàng thông tin Người chơi (Bạn / An)
        _buildPlayerCard(
          name: 'Bạn (An)',
          title: 'Cấp 7 · Nhà thám hiểm',
          score: playerScore,
          isTurn: currentTurn == GameTurn.player,
          avatarIcon: Icons.person_rounded,
          avatarBgColor: AppColors.primary,
        ),
      ],
    );
  }

  /// Dựng thẻ người chơi đối kháng
  Widget _buildPlayerCard({
    required String name,
    required String title,
    required int score,
    required bool isTurn,
    required IconData avatarIcon,
    required Color avatarBgColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isTurn ? AppColors.primary : const Color(0xFFE5DFC9),
          width: isTurn ? 2.0 : 1.2,
        ),
        boxShadow: [
          if (isTurn)
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              offset: const Offset(0, 4),
              blurRadius: 10,
            )
          else
            const BoxShadow(
              color: Color(0x0C000000),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
        ],
      ),
      child: Row(
        children: [
          // Avatar tròn
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: avatarBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(avatarIcon, color: Colors.white, size: 22),
          ),

          const SizedBox(width: 10),

          // Tên & Danh hiệu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (isTurn) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'ĐANG ĐI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Điểm số đã ăn
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isTurn
                    ? [const Color(0xFFFFD54F), AppColors.gold]
                    : [const Color(0xFFF2ECE1), const Color(0xFFE5DDD0)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: isTurn
                  ? [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.circle,
                  color: Color(0xFF5D4037),
                  size: 10,
                ),
                const SizedBox(width: 6),
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: isTurn ? AppColors.darkBackground : const Color(0xFF5D4037),
                  ),
                ),
                const SizedBox(width: 3),
                const Text(
                  'hạt',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A6B5C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
