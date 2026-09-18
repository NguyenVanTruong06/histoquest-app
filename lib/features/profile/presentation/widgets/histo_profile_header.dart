import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/profile_decorations.dart';
import '../../../../data/models/user_model.dart';
import '../../../../shared/widgets/stat_badge.dart';

class HistoProfileHeader extends StatelessWidget {
  final UserModel user;
  final VoidCallback onOpenShop;
  final VoidCallback onCustomize;

  const HistoProfileHeader({
    super.key,
    required this.user,
    required this.onOpenShop,
    required this.onCustomize,
  });

  @override
  Widget build(BuildContext context) {
    final banner = MockProfileDecorations.getBanner(user.currentBannerId);
    final frame = MockProfileDecorations.getFrame(user.currentFrameId);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // -------------------------------------------------------------
          // 1. HISTOQUEST PROFILE BANNER
          // -------------------------------------------------------------
          SizedBox(
            height: 125,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Nền Gradient của banner
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: banner.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Icon trang trí chìm ở góc banner
                Positioned(
                  right: -10,
                  bottom: -15,
                  child: Icon(
                    banner.icon,
                    size: 110,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                // Tên ảnh bìa góc trên phải
                Positioned(
                  top: 12,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(banner.icon, color: Colors.white70, size: 13),
                        const SizedBox(width: 5),
                        Text(
                          banner.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // -------------------------------------------------------------
          // 2. AVATAR + KHUNG ĐẠI DIỆN HISTOQUEST + NÚT HÀNH ĐỘNG
          // -------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hàng chứa Avatar đè lên banner và 2 nút hành động
                Transform.translate(
                  offset: const Offset(0, -36),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar với Khung trang trí HistoQuest
                      _buildDecoratedAvatar(frame),

                      // Hai nút: Cửa hàng & Đổi trang phục
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            // Nút mở Cửa hàng mua khung/ảnh bìa
                            ElevatedButton.icon(
                              onPressed: onOpenShop,
                              icon: const Icon(Icons.storefront_rounded, size: 16),
                              label: const Text('Cửa Hàng'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Nút tùy biến nhanh
                            OutlinedButton(
                              onPressed: onCustomize,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textPrimary,
                                side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Icon(Icons.palette_outlined, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // -------------------------------------------------------------
                // 3. THÔNG TIN NGƯỜI CHƠI (Tên, Danh hiệu, Handle, Chỉ số)
                // -------------------------------------------------------------
                Transform.translate(
                  offset: const Offset(0, -22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Danh hiệu dạng thẻ vinh danh
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE4A93A), Color(0xFFC58E2A)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.military_tech_rounded, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              user.title,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Tên người dùng & Tên khung đang đeo
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.4,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Badge tên khung
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: frame.gradientColors.first.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: frame.gradientColors.first.withValues(alpha: 0.4),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(frame.icon, size: 11, color: frame.gradientColors.first),
                                const SizedBox(width: 4),
                                Text(
                                  frame.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: frame.gradientColors.first,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // Username handle nhà thám hiểm HistoQuest
                      Text(
                        '@${user.name.toLowerCase().replaceAll(' ', '_')}_histoquest',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 3 Chỉ số nổi bật (Level, Streak, Coins)
                      Row(
                        children: [
                          StatBadge(
                            type: StatType.xp,
                            label: 'Cấp ${user.level}',
                          ),
                          const SizedBox(width: 8),
                          StatBadge(
                            type: StatType.streak,
                            label: '${user.streakDays} ngày',
                          ),
                          const SizedBox(width: 8),
                          StatBadge(
                            type: StatType.coin,
                            label: '${user.coins} xu',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Khung đại diện Avatar HistoQuest Decoration
  Widget _buildDecoratedAvatar(ProfileDecorationItem frame) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Viền gradient theo khung trang phục
        gradient: SweepGradient(colors: frame.gradientColors),
        boxShadow: [
          if (frame.hasGlow)
            BoxShadow(
              color: frame.gradientColors.first.withValues(alpha: 0.45),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(frame.borderWidth),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2A241F),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(3),
        child: ClipOval(
          child: Container(
            color: const Color(0xFF1E6353), // Nền xanh ngọc cổ điển
            child: Center(
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'H',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
