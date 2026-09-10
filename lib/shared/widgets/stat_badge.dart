import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum StatType { xp, coin, streak, time, reward, ongoing }

class StatBadge extends StatelessWidget {
  final StatType type;
  final String label;
  final VoidCallback? onTap;

  const StatBadge({
    super.key,
    required this.type,
    required this.label,
    this.onTap,
  });

  factory StatBadge.xp(dynamic value, {VoidCallback? onTap}) {
    return StatBadge(
      type: StatType.xp,
      label: value.toString().startsWith('+') ? '$value XP' : '+$value XP',
      onTap: onTap,
    );
  }

  factory StatBadge.coin(dynamic value, {VoidCallback? onTap}) {
    return StatBadge(
      type: StatType.coin,
      label: '$value xu',
      onTap: onTap,
    );
  }

  factory StatBadge.streak(dynamic value, {VoidCallback? onTap}) {
    return StatBadge(
      type: StatType.streak,
      label: '$value ngày',
      onTap: onTap,
    );
  }

  factory StatBadge.time(String text, {VoidCallback? onTap}) {
    return StatBadge(
      type: StatType.time,
      label: '≈ $text',
      onTap: onTap,
    );
  }

  factory StatBadge.reward(String text, {VoidCallback? onTap}) {
    return StatBadge(
      type: StatType.reward,
      label: text,
      onTap: onTap,
    );
  }

  factory StatBadge.ongoing(String text, {VoidCallback? onTap}) {
    return StatBadge(
      type: StatType.ongoing,
      label: text,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData? icon;

    switch (type) {
      case StatType.xp:
        iconColor = AppColors.xpColor;
        bgColor = const Color(0xFFF5F0E5);
        borderColor = AppColors.cardBorder;
        textColor = const Color(0xFF4A443D);
        icon = Icons.bolt_rounded;
        break;
      case StatType.coin:
        iconColor = AppColors.gold;
        bgColor = AppColors.goldLight;
        borderColor = AppColors.gold;
        textColor = AppColors.goldDark;
        icon = Icons.monetization_on_rounded;
        break;
      case StatType.streak:
        iconColor = AppColors.streakColor;
        bgColor = AppColors.streakBg;
        borderColor = AppColors.primary;
        textColor = AppColors.primaryDark;
        icon = Icons.local_fire_department_rounded;
        break;
      case StatType.time:
        iconColor = AppColors.textSecondary;
        bgColor = const Color(0xFFF5F0E5);
        borderColor = AppColors.cardBorder;
        textColor = const Color(0xFF4A443D);
        icon = Icons.access_time_rounded;
        break;
      case StatType.reward:
        iconColor = AppColors.goldDark;
        bgColor = AppColors.goldLight;
        borderColor = AppColors.gold;
        textColor = AppColors.goldDark;
        icon = Icons.card_membership_rounded;
        break;
      case StatType.ongoing:
        iconColor = AppColors.primary;
        bgColor = AppColors.primaryLight;
        borderColor = Colors.transparent;
        textColor = AppColors.primaryDark;
        icon = Icons.play_arrow_rounded;
        break;
    }

    Widget badgeContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: badgeContent,
      );
    }

    return badgeContent;
  }
}

/// Hàng hiển thị 3 chỉ số chính của người chơi
class UserStatsRow extends StatelessWidget {
  final int xp;
  final int coins;
  final int streakDays;
  final VoidCallback? onXpTap;
  final VoidCallback? onCoinsTap;
  final VoidCallback? onStreakTap;

  const UserStatsRow({
    super.key,
    required this.xp,
    required this.coins,
    required this.streakDays,
    this.onXpTap,
    this.onCoinsTap,
    this.onStreakTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatBadge.streak(streakDays, onTap: onStreakTap),
        const SizedBox(width: 6),
        StatBadge.coin(coins, onTap: onCoinsTap),
        const SizedBox(width: 6),
        StatBadge.xp(xp, onTap: onXpTap),
      ],
    );
  }
}
