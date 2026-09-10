import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../../shared/widgets/stat_badge.dart';
import '../../data/mancala_engine.dart';

/// Màn hình / Hộp thoại Kết quả Minigame Ô Ăn Quan
class MancalaResultDialog extends StatelessWidget {
  final int playerScore;
  final int aiScore;
  final GameResultState resultState;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  const MancalaResultDialog({
    super.key,
    required this.playerScore,
    required this.aiScore,
    required this.resultState,
    required this.onPlayAgain,
    required this.onExit,
  });

  static Future<void> show(
    BuildContext context, {
    required int playerScore,
    required int aiScore,
    required GameResultState resultState,
    required VoidCallback onPlayAgain,
    required VoidCallback onExit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MancalaResultDialog(
        playerScore: playerScore,
        aiScore: aiScore,
        resultState: resultState,
        onPlayAgain: onPlayAgain,
        onExit: onExit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWon = resultState == GameResultState.playerWon;
    final bool isDraw = resultState == GameResultState.draw;

    final String title = isWon
        ? 'ĐẠI THẮNG QUAN LỚN! 🏆'
        : (isDraw ? 'HÒA CỜ THƯƠNG THẢO! 🤝' : 'CỐ GẮNG LẦN SAU! 💪');

    final String subtitle = isWon
        ? 'Bạn đã khéo léo tính toán và thu phục toàn bộ sỏi ngọc!'
        : (isDraw
            ? 'Ván cờ kỳ phùng địch thủ, cả hai đều có chiến lược tuyệt vời.'
            : 'Trạng Tí đã có những nước đi bất ngờ, hãy phục thù ở ván sau!');

    final int xpReward = isWon ? 150 : (isDraw ? 80 : 30);
    final int coinReward = isWon ? 50 : (isDraw ? 25 : 10);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFE5DFC9), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x303A2A1A),
              offset: Offset(0, 10),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Biểu tượng Vinh danh cúp vàng / huy chương 3D
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isWon
                      ? [const Color(0xFFFFD54F), AppColors.gold]
                      : (isDraw
                          ? [const Color(0xFFB0BEC5), const Color(0xFF78909C)]
                          : [const Color(0xFFD95D39), const Color(0xFFA53B20)]),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isWon ? AppColors.gold : AppColors.primary).withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                isWon
                    ? Icons.emoji_events_rounded
                    : (isDraw ? Icons.handshake_rounded : Icons.replay_circle_filled_rounded),
                color: Colors.white,
                size: 42,
              ),
            ),

            const SizedBox(height: 16),

            // 2. Tiêu đề kết quả
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 6),

            // Lời chúc / đánh giá
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 18),

            // 3. Bảng tổng kết đối chiếu điểm số
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2DDD2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Cột Bạn
                  Column(
                    children: [
                      const Text(
                        'BẠN (AN)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$playerScore',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.darkBackground,
                        ),
                      ),
                      const Text(
                        'hạt sỏi',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  // Thanh phân cách VS
                  Container(
                    height: 40,
                    width: 1.5,
                    color: const Color(0xFFD4CABB),
                  ),

                  // Cột Đối thủ
                  Column(
                    children: [
                      const Text(
                        'TRẠNG TÍ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7A6B5C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$aiScore',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF7A6B5C),
                        ),
                      ),
                      const Text(
                        'hạt sỏi',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Phần thưởng nhận được
            const Text(
              'Phần thưởng đạt được:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatBadge(type: StatType.xp, label: '+$xpReward XP'),
                const SizedBox(width: 8),
                StatBadge(type: StatType.coin, label: '+$coinReward xu'),
                if (isWon) ...[
                  const SizedBox(width: 8),
                  const StatBadge(type: StatType.reward, label: 'Huy hiệu Trạng Cờ 🎖️'),
                ],
              ],
            ),

            const SizedBox(height: 22),

            // 5. Nút Nhận thưởng & Chơi lại
            PrimaryButton(
              label: 'Nhận Thưởng & Chơi Lại',
              isFullWidth: true,
              height: 52,
              icon: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 20),
              onPressed: () {
                Navigator.pop(context);
                onPlayAgain();
              },
            ),

            const SizedBox(height: 10),

            // Nút Trở về Sảnh Trò Chơi
            SecondaryButton(
              label: 'Trở về Sảnh Trò Chơi',
              isFullWidth: true,
              height: 48,
              fontSize: 14,
              icon: const Icon(Icons.home_rounded, color: AppColors.primaryDark, size: 18),
              onPressed: () {
                Navigator.pop(context);
                onExit();
              },
            ),
          ],
        ),
      ),
    );
  }
}
