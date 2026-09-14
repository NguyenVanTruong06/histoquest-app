import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/stat_badge.dart';
import 'mancala_game_screen.dart';
import 'timeline_rush_screen.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Trò Chơi Dân Gian',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                StatBadge(type: StatType.coin, label: '1250 xu'),
                SizedBox(width: 8),
                StatBadge(type: StatType.xp, label: '+350 XP'),
              ],
            ),
          ),
        ],
      ),
      // Sử dụng CustomScrollView kết hợp SliverToBoxAdapter để cuộn mượt mà,
      // co giãn tự động theo không gian thực tế và tránh hoàn toàn lỗi bottom overflow.
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 12.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Banner chào mừng sảnh trò chơi
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.darkBackground,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x25000000),
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ĐẤU TRÍ DÂN GIAN & LỊCH SỬ',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Kỳ Đài Trạng Nguyên',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rèn luyện mưu lược, thử tài đấu trí với các danh nhân lịch sử để nhận xu và thăng cấp thám hiểm.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Trò Chơi Nổi Bật',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                // 2 thẻ trò chơi nổi bật đặt cạnh nhau
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildGameCard(
                        context,
                        title: 'Timeline Rush',
                        subtitle: 'Sắp xếp các sự kiện lịch sử theo đúng dòng thời gian để nhận phần thưởng lớn.',
                        badge: 'HOT · MINIGAME DAY 4',
                        category: 'Trí tuệ',
                        xpReward: '+200 XP',
                        coinReward: '+80 xu',
                        itemReward: 'Mảnh bản đồ',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TimelineRushScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildGameCard(
                        context,
                        title: 'Cờ Ô Ăn Quan (Mancala)',
                        subtitle: 'Trò chơi tính toán rải sỏi ăn quan kinh điển của người Việt. Thi thố tính toán từng bước đi!',
                        badge: 'TRUYỀN THỐNG',
                        category: 'Chiến thuật',
                        xpReward: '+150 XP',
                        coinReward: '+50 xu',
                        itemReward: 'Bàn cờ 12 Ô',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MancalaGameScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  'Sắp Ra Mắt',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 10),

                // 2 thẻ "sắp ra mắt" đặt cạnh nhau
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildUpcomingCard(
                        title: 'Ghép Thẻ Tướng',
                        subtitle: 'Tìm các cặp thẻ danh tướng giống nhau để nhận mảnh ghép hiếm.',
                        badge: 'Trí nhớ',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildUpcomingCard(
                        title: 'Truy Tìm Cổ Vật',
                        subtitle: 'Sử dụng manh mối để tìm kiếm cổ vật bị thất lạc trong cung đình.',
                        badge: 'Khám phá',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badge,
    required String category,
    required String xpReward,
    required String coinReward,
    required String itemReward,
    required VoidCallback onTap,
  }) {
    return AppCard(
      isActive: true,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.gold,
                    size: 16,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5A5248),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatBadge(type: StatType.xp, label: xpReward),
              StatBadge(type: StatType.coin, label: coinReward),
              StatBadge(type: StatType.reward, label: itemReward),
            ],
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Chơi Ngay',
            isFullWidth: true,
            height: 54,
            icon: const Icon(
              Icons.play_circle_filled_rounded,
              color: Colors.white,
              size: 22,
            ),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard({
    required String title,
    required String subtitle,
    required String badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5DFC9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2ECE1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.lock_clock_rounded,
              color: Color(0xFF8C7F70),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECE6D8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A6B5C),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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
