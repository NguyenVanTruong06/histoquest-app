import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/user_model.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/stat_badge.dart';

/// Dịch vụ kinh tế & trao thưởng thống nhất cho toàn bộ hệ thống Mini-games HistoQuest
class GameEconomyService {
  GameEconomyService._();

  /// Trao thưởng khi hoàn thành hoặc chiến thắng mini-game
  static UserModel awardGameRewards({
    required int coins,
    required int xp,
    String? gameTitle,
  }) {
    HapticFeedback.mediumImpact();

    final current = MockData.currentUser;
    final updated = current.copyWith(
      coins: current.coins + coins,
      xp: current.xp + xp,
      totalQuestsCompleted: current.totalQuestsCompleted + 1,
    );

    MockData.currentUser = updated;
    return updated;
  }

  /// Hiển thị Dialog chúc mừng chiến thắng chuẩn gamification cổ phong
  static Future<void> showVictoryDialog({
    required BuildContext context,
    required String gameTitle,
    required int coins,
    required int xp,
    String message = 'Xuất sắc vượt qua thử thách lịch sử!',
    VoidCallback? onPlayAgain,
    VoidCallback? onExit,
  }) {
    awardGameRewards(coins: coins, xp: xp, gameTitle: gameTitle);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFAF7F2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            const Icon(Icons.emoji_events_rounded, color: AppColors.gold, size: 56),
            const SizedBox(height: 8),
            Text(
              'CHIẾN THẮNG!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, height: 1.4),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                StatBadge(type: StatType.coin, label: '+$coins xu'),
                StatBadge(type: StatType.xp, label: '+$xp XP'),
              ],
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              if (onPlayAgain != null)
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      onPlayAgain();
                    },
                    child: const Text('Chơi Lại', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              if (onPlayAgain != null) const SizedBox(width: 10),
              Expanded(
                child: PrimaryButton(
                  label: 'Rời Khỏi',
                  height: 46,
                  fontSize: 14,
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (onExit != null) {
                      onExit();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
