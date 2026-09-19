import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/profile_decorations.dart';
import '../../../shared/widgets/histoquest_top_header.dart';
import 'widgets/player_profile_showcase_sheet.dart';

class RanksScreen extends StatefulWidget {
  const RanksScreen({super.key});

  @override
  State<RanksScreen> createState() => _RanksScreenState();
}

class _RanksScreenState extends State<RanksScreen> {
  int _selectedTab = 0;

  List<Map<String, dynamic>> get _leaderboard {
    final list = List<Map<String, dynamic>>.from(MockData.leaderboard);

    // Sync "An (Bạn)" with the latest equipped frame & stats from currentUser
    for (int i = 0; i < list.length; i++) {
      if ((list[i]['name'] as String).contains('(Bạn)')) {
        list[i] = {
          ...list[i],
          'frameId': MockData.currentUser.currentFrameId,
          'bannerId': MockData.currentUser.currentBannerId,
          'level': MockData.currentUser.level,
          'xp': MockData.currentUser.xp,
          'streak': MockData.currentUser.streakDays,
        };
      }
    }

    if (_selectedTab == 0) {
      list.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));
    } else if (_selectedTab == 1) {
      list.sort((a, b) => (b['level'] as int).compareTo(a['level'] as int));
    } else if (_selectedTab == 2) {
      list.sort((a, b) => (b['streak'] as int).compareTo(a['streak'] as int));
    }

    for (int i = 0; i < list.length; i++) {
      list[i] = {...list[i], 'rank': i + 1};
    }
    return list;
  }

  void _openPlayerShowcase(Map<String, dynamic> player) {
    PlayerProfileShowcaseSheet.show(
      context,
      player: player,
      onUpdateUser: (updated) {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          HistoquestTopHeader(
            title: 'Bảng Vàng',
            coins: user.coins,
            streakDays: user.streakDays,
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildToggle(),
                    const SizedBox(height: 4),
                    _buildHintBanner(),
                    _buildPodium(),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _leaderboard.length > 3
                            ? _leaderboard.length - 3
                            : 0,
                        itemBuilder: (context, index) {
                          final rankUser = _leaderboard[index + 3];
                          return _buildRankItem(rankUser);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app_rounded,
            size: 14,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'Chạm vào người chơi để xem Khung, Danh hiệu & Thách đấu',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEBE5D9),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            _buildTabButton(0, 'Điểm'),
            _buildTabButton(1, 'Danh hiệu'),
            _buildTabButton(2, 'Chuỗi ngày'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String text) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPodium() {
    if (_leaderboard.length < 3) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Rank 2 (Silver)
          Expanded(
            child: _buildPodiumItem(_leaderboard[1], 2, Colors.grey.shade500),
          ),
          const SizedBox(width: 10),
          // Rank 1 (Gold, slightly taller)
          Expanded(
            child: _buildPodiumItem(_leaderboard[0], 1, AppColors.gold, isWinner: true),
          ),
          const SizedBox(width: 10),
          // Rank 3 (Bronze)
          Expanded(
            child: _buildPodiumItem(_leaderboard[2], 3, Colors.brown.shade300),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(
    Map<String, dynamic> user,
    int rank,
    Color rankColor, {
    bool isWinner = false,
  }) {
    String statText = '${user['xp']} XP';
    if (_selectedTab == 1) statText = 'Cấp ${user['level']}';
    if (_selectedTab == 2) statText = '${user['streak']} ngày';

    final isCurrentUser = (user['name'] as String).contains('(Bạn)');
    String name = user['name'] as String;
    String initials = name
        .replaceAll('(Bạn)', '')
        .trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join('')
        .toUpperCase();
    if (initials.isEmpty) initials = 'HG';

    // Retrieve custom frame decoration
    final frameId = isCurrentUser
        ? MockData.currentUser.currentFrameId
        : (user['frameId'] as String? ?? 'frame_default');
    final frame = MockProfileDecorations.getFrame(frameId);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => _openPlayerShowcase(user),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isWinner ? 18 : 14,
            horizontal: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isWinner
                  ? AppColors.gold.withValues(alpha: 0.5)
                  : Colors.grey.shade200,
              width: isWinner ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isWinner
                    ? AppColors.gold.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Rank Crown or Pill Badge
              if (isWinner)
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text('👑', style: TextStyle(fontSize: 18)),
                ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(shape: BoxShape.circle, color: rankColor),
                child: Center(
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Custom Frame Decorated Avatar
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Glow effect if frame has glow
                  if (frame.hasGlow)
                    Container(
                      width: isWinner ? 62 : 52,
                      height: isWinner ? 62 : 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: frame.gradientColors.first.withValues(alpha: 0.35),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),

                  // Gradient Border Frame
                  Container(
                    width: isWinner ? 58 : 48,
                    height: isWinner ? 58 : 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: frame.gradientColors.length > 1
                            ? [...frame.gradientColors, frame.gradientColors.first]
                            : [frame.gradientColors.first, frame.gradientColors.first],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isWinner ? 3.0 : 2.5),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEBE5D9),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontSize: isWinner ? 16 : 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Corner frame icon
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: frame.gradientColors.first,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Icon(frame.icon, size: 8, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Player Name
              Text(
                name.replaceAll(' (Bạn)', ''),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Title chip (short)
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  user['title'] as String? ?? 'Sử gia',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB8860B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 4),
              Text(
                statText,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankItem(Map<String, dynamic> user) {
    bool isCurrentUser = (user['name'] as String).contains('(Bạn)');
    String name = user['name'] as String;
    String initials = name
        .replaceAll('(Bạn)', '')
        .trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join('')
        .toUpperCase();
    if (initials.isEmpty) initials = 'HG';

    if (isCurrentUser) {
      name = 'An';
    }

    String statText = '${user['xp']}';
    if (_selectedTab == 1) statText = 'Cấp ${user['level']}';
    if (_selectedTab == 2) statText = '${user['streak']} ngày';

    // Retrieve custom frame decoration
    final frameId = isCurrentUser
        ? MockData.currentUser.currentFrameId
        : (user['frameId'] as String? ?? 'frame_default');
    final frame = MockProfileDecorations.getFrame(frameId);

    Color bgColor = isCurrentUser ? const Color(0xFFFFF4EE) : Colors.white;
    Color borderColor = isCurrentUser
        ? const Color(0xFFD95D39)
        : Colors.grey.shade200;
    Color rankColor = isCurrentUser
        ? const Color(0xFFD95D39)
        : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _openPlayerShowcase(user),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Rank number
                SizedBox(
                  width: 26,
                  child: Text(
                    '${user['rank']}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: rankColor,
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Decorated Avatar with Frame
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    if (frame.hasGlow)
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: frame.gradientColors.first.withValues(alpha: 0.35),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: frame.gradientColors.length > 1
                              ? [...frame.gradientColors, frame.gradientColors.first]
                              : [frame.gradientColors.first, frame.gradientColors.first],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEBE5D9),
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Frame mini icon badge
                    Positioned(
                      right: -1,
                      top: -1,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: frame.gradientColors.first,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Icon(frame.icon, size: 7, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Player Name & Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrentUser) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Bạn',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user['title'] as String? ?? 'Sử gia',
                        style: TextStyle(
                          fontSize: 11,
                          color: isCurrentUser
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Stat & Action Chevron
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      statText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Xem hồ sơ',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary.withValues(alpha: 0.8),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
