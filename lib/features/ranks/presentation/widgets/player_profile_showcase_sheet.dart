import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/mock_data.dart';
import '../../../../data/models/profile_decorations.dart';
import '../../../../data/models/user_model.dart';
import '../../../profile/presentation/widgets/profile_customization_shop_sheet.dart';

class PlayerProfileShowcaseSheet extends StatefulWidget {
  final Map<String, dynamic> player;
  final ValueChanged<UserModel>? onUpdateUser;

  const PlayerProfileShowcaseSheet({
    super.key,
    required this.player,
    this.onUpdateUser,
  });

  static Future<void> show(
    BuildContext context, {
    required Map<String, dynamic> player,
    ValueChanged<UserModel>? onUpdateUser,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PlayerProfileShowcaseSheet(
        player: player,
        onUpdateUser: onUpdateUser,
      ),
    );
  }

  @override
  State<PlayerProfileShowcaseSheet> createState() =>
      _PlayerProfileShowcaseSheetState();
}

class _PlayerProfileShowcaseSheetState extends State<PlayerProfileShowcaseSheet> {
  late int _likes;
  bool _hasLiked = false;

  @override
  void initState() {
    super.initState();
    _likes = (widget.player['likes'] as int?) ?? 42;
  }

  void _handleLike() {
    if (_hasLiked) return;
    setState(() {
      _likes++;
      _hasLiked = true;
    });
    final name = widget.player['name'] as String? ?? 'người chơi';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.favorite_rounded, color: Colors.pinkAccent),
            const SizedBox(width: 8),
            Text('Đã gửi tặng 1 tim chúc mừng đến $name!'),
          ],
        ),
        backgroundColor: const Color(0xFF2C2523),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleDuel() {
    final name = widget.player['name'] as String? ?? 'người chơi';
    showDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.sports_kabaddi_rounded, color: AppColors.primary, size: 28),
            SizedBox(width: 10),
            Text('Thách Đấu Sử Ký', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Gửi thư thách đấu giải đố lịch sử 1v1 đến $name? '
          'Chiến thắng sẽ nhận thêm +50 XP và 25 Xu!',
          style: const TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Để sau', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('⚔️ Lời thách đấu đã được gửi đến $name thành công!'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Gửi Thách Đấu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final isCurrentUser = (player['name'] as String? ?? '').contains('(Bạn)');

    // Dynamically retrieve frame & banner (if current user, sync with MockData.currentUser)
    final frameId = isCurrentUser
        ? MockData.currentUser.currentFrameId
        : (player['frameId'] as String? ?? 'frame_default');
    final bannerId = isCurrentUser
        ? MockData.currentUser.currentBannerId
        : (player['bannerId'] as String? ?? 'banner_default');

    final frame = MockProfileDecorations.getFrame(frameId);
    final banner = MockProfileDecorations.getBanner(bannerId);

    final name = isCurrentUser ? 'Bạn (An)' : (player['name'] as String? ?? 'Sử gia');
    final title = player['title'] as String? ?? 'Nhà thám hiểm';
    final rank = player['rank'] ?? 1;
    final level = isCurrentUser ? MockData.currentUser.level : (player['level'] ?? 1);
    final xp = isCurrentUser ? MockData.currentUser.xp : (player['xp'] ?? 0);
    final streak = isCurrentUser ? MockData.currentUser.streakDays : (player['streak'] ?? 0);
    final bio = player['bio'] as String? ?? 'Hành trình lịch sử ngàn năm văn hiến 📜';
    final favoriteHero = player['favoriteHero'] as String? ?? 'Trần Quốc Tuấn';
    final badges = (player['badges'] as List<dynamic>?)?.cast<String>() ??
        ['Tân Thủ Xuất Sắc', 'Cờ Lau Tập Trận'];

    String initials = name
        .replaceAll('(Bạn)', '')
        .trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join('')
        .toUpperCase();
    if (initials.isEmpty) initials = 'HG';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Banner with equipped banner background
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                      gradient: LinearGradient(
                        colors: banner.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative banner icon pattern
                        Positioned(
                          right: -15,
                          bottom: -15,
                          child: Icon(
                            banner.icon,
                            size: 110,
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        // Banner Name Badge
                        Positioned(
                          left: 16,
                          top: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(banner.icon, color: Colors.white, size: 14),
                                const SizedBox(width: 5),
                                Text(
                                  banner.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Close button
                        Positioned(
                          right: 12,
                          top: 12,
                          child: IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Avatar with Equipped Frame
                  Positioned(
                    bottom: -46,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow behind frame if item has glow
                        if (frame.hasGlow)
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: frame.gradientColors.first.withValues(alpha: 0.5),
                                  blurRadius: 18,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                          ),

                        // Frame gradient border
                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: frame.gradientColors.length > 1
                                  ? [
                                      ...frame.gradientColors,
                                      frame.gradientColors.first,
                                    ]
                                  : [
                                      frame.gradientColors.first,
                                      frame.gradientColors.first,
                                    ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(frame.borderWidth),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFEBE5D9),
                              ),
                              child: Center(
                                child: Text(
                                  initials,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Corner ornament icon from the frame
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            padding: const EdgeInsets.all(3.5),
                            decoration: BoxDecoration(
                              color: frame.gradientColors.first,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(frame.icon, color: Colors.white, size: 12),
                          ),
                        ),

                        // Rank indicator badge at bottom
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getRankBadgeColor(rank),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (rank == 1)
                                  const Text('🥇 ', style: TextStyle(fontSize: 10))
                                else if (rank == 2)
                                  const Text('🥈 ', style: TextStyle(fontSize: 10))
                                else if (rank == 3)
                                  const Text('🥉 ', style: TextStyle(fontSize: 10)),
                                Text(
                                  'Top $rank',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 54),

              // Player Name & Equipped Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (isCurrentUser) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Hồ sơ của bạn',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Equipped Title Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFDBA74)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.workspace_premium_rounded, size: 14, color: Color(0xFFEA580C)),
                          const SizedBox(width: 4),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFC2410C),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Player Bio
                    Text(
                      '"$bio"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Stats Row (3 Cards)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatBox(
                        icon: Icons.bolt_rounded,
                        iconColor: Colors.amber.shade700,
                        value: '$xp',
                        label: 'Điểm XP',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatBox(
                        icon: Icons.local_fire_department_rounded,
                        iconColor: const Color(0xFFD95D39),
                        value: '$streak',
                        label: 'Chuỗi ngày',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatBox(
                        icon: Icons.shield_rounded,
                        iconColor: AppColors.primary,
                        value: 'Cấp $level',
                        label: 'Đẳng cấp',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Favorite Hero Card Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6F0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.1),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: const Icon(Icons.style_rounded, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tướng Đồng Hành Yêu Thích',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              favoriteHero,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (i) => const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Badges Showcase
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.military_tech_rounded, color: AppColors.primary, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Huy Hiệu Vinh Dự',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: badges.map((b) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2D9C8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
                              const SizedBox(width: 5),
                              Text(
                                b,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: isCurrentUser
                    ? SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          icon: const Icon(Icons.palette_rounded, color: Colors.white),
                          label: const Text(
                            'Tùy Chỉnh Khung & Ảnh Bìa (Cửa Hàng)',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ProfileCustomizationShopSheet.show(
                              context,
                              user: MockData.currentUser,
                              onUpdateUser: (updated) {
                                MockData.currentUser = updated;
                                widget.onUpdateUser?.call(updated);
                              },
                            );
                          },
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: _hasLiked ? Colors.pinkAccent : Colors.grey.shade300,
                                  ),
                                  backgroundColor: _hasLiked
                                      ? Colors.pink.shade50
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: Icon(
                                  _hasLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: _hasLiked ? Colors.pinkAccent : AppColors.textSecondary,
                                ),
                                label: Text(
                                  '$_likes Tim',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _hasLiked ? Colors.pinkAccent : AppColors.textPrimary,
                                  ),
                                ),
                                onPressed: _handleLike,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 2,
                                ),
                                icon: const Icon(Icons.sports_kabaddi_rounded, color: Colors.white),
                                label: const Text(
                                  'Thách Đấu 1v1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: _handleDuel,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankBadgeColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFD4AF37); // Gold
      case 2:
        return const Color(0xFF9E9E9E); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.primary;
    }
  }
}
