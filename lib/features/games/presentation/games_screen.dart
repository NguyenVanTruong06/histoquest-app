import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/stat_badge.dart';
import 'mancala_game_screen.dart';

/// Màn hình Sảnh Trò Chơi Dân Gian Lịch Sử (Tab 3: Trò chơi)
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            // Card Minigame Chính: Cờ Ô Ăn Quan (Mancala Việt Nam)
            AppCard(
              isActive: true,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'HOT · MINIGAME DAY 4',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Row(
                        children: [
                          Icon(Icons.star_rounded, color: AppColors.gold, size: 16),
                          SizedBox(width: 3),
                          Text(
                            'Truyền thống',
                            style: TextStyle(
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

                  const Text(
                    'Cờ Ô Ăn Quan (Mancala)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Trò chơi tính toán rải sỏi ăn quan kinh điển của người Việt. Thi thố tính toán từng bước đi cùng Trạng Tí để giành lấy ngọc quý!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5A5248),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatBadge(type: StatType.xp, label: '+150 XP'),
                      StatBadge(type: StatType.coin, label: '+50 xu'),
                      StatBadge(type: StatType.reward, label: 'Bàn cờ 12 Ô'),
                    ],
                  ),

                  const SizedBox(height: 18),

                  PrimaryButton(
                    label: 'Chơi Ngay',
                    isFullWidth: true,
                    height: 54,
                    icon: const Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 22),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MancalaGameScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
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

            // Card phụ 1: Cờ Gánh
            _buildUpcomingCard(
              title: 'Cờ Gánh Dân Gian',
              subtitle: 'Nghệ thuật vây bắt và chém quân truyền thống xứ Quảng.',
              badge: 'Chiến thuật',
            ),

            const SizedBox(height: 10),

            // Card phụ 2: Đố chữ Nôm
            _buildUpcomingCard(
              title: 'Thử Tài Đố Chữ Nôm',
              subtitle: 'Khám phá văn tự cổ và câu đối đối đáp thâm thúy của cha ông.',
              badge: 'Học thuật',
            ),

            const SizedBox(height: 20),
          ],
        ),
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
            child: const Icon(Icons.lock_clock_rounded, color: Color(0xFF8C7F70), size: 24),
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
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
