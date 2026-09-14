import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';

class RanksScreen extends StatefulWidget {
  const RanksScreen({super.key});

  @override
  State<RanksScreen> createState() => _RanksScreenState();
}

class _RanksScreenState extends State<RanksScreen> {
  int _selectedTab = 0;

  List<Map<String, dynamic>> get _leaderboard {
    final list = List<Map<String, dynamic>>.from(MockData.leaderboard);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Landscape: giới hạn chiều rộng và căn giữa toàn bộ nội dung để danh
      // sách xếp hạng không bị kéo dãn quá rộng trên màn hình ngang.
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    'Bảng vàng',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _buildToggle(),
                _buildPodium(),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _leaderboard.length > 3
                        ? _leaderboard.length - 3
                        : 0,
                    itemBuilder: (context, index) {
                      final user = _leaderboard[index + 3];
                      return _buildRankItem(user);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildPodiumItem(_leaderboard[1], 2, Colors.grey.shade500),
          ),
          const SizedBox(width: 12),
          Expanded(child: _buildPodiumItem(_leaderboard[0], 1, AppColors.gold)),
          const SizedBox(width: 12),
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
    Color rankColor,
  ) {
    String statText = '${user['xp']} XP';
    if (_selectedTab == 1) statText = 'Cấp ${user['level']}';
    if (_selectedTab == 2) statText = '${user['streak']} ngày';

    String name = user['name'] as String;
    String initials = name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join('')
        .toUpperCase();
    if (name.contains('(Bạn)')) initials = 'An';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(shape: BoxShape.circle, color: rankColor),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEBE5D9),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name.replaceAll(' (Bạn)', ''),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            statText,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankItem(Map<String, dynamic> user) {
    bool isCurrentUser = (user['name'] as String).contains('(Bạn)');
    String name = user['name'] as String;
    String initials = name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join('')
        .toUpperCase();

    if (isCurrentUser) {
      initials = 'An';
      name = 'Bạn';
    }

    String statText = '${user['xp']}';
    if (_selectedTab == 1) statText = 'Cấp ${user['level']}';
    if (_selectedTab == 2) statText = '${user['streak']} ngày';

    Color bgColor = isCurrentUser ? const Color(0xFFFFF4EE) : Colors.white;
    Color borderColor = isCurrentUser
        ? const Color(0xFFD95D39)
        : Colors.grey.shade200;
    Color rankColor = isCurrentUser
        ? const Color(0xFFD95D39)
        : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${user['rank']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: rankColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
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
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            statText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
