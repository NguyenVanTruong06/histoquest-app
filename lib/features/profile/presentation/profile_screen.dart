import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/hero_card_model.dart';
import '../../../shared/widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = MockData.currentUser;
    final List<HeroCardModel> cards = MockData.heroCards;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Của tôi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  // Settings dummy
                },
              ),
            ),
          ),
        ],
      ),
      // Portrait: một cột dọc duy nhất, cuộn được toàn bộ — thông tin cá
      // nhân, chuỗi ngày, thành tựu, rồi tới bảo tàng thẻ bài. (Có một bản
      // landscape cũ tách thành 2 cột cuộn độc lập cạnh nhau để tận dụng
      // chiều rộng màn hình ngang — đã bỏ vì app hiện khóa portrait.)
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: 16),
            _buildStreakSection(user),
            const SizedBox(height: 16),
            _buildAchievementsSection(),
            const SizedBox(height: 20),
            _buildCardMuseumHeader(),
            _buildCardMuseumGrid(cards),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return AppCard(
      isActive: false,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 3),
                    color: const Color(0xFF1E6353), // Dark green
                  ),
                  child: Center(
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.title} ${user.name}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.gold),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.gold,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Cấp ${user.level}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.gold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Chế độ khách',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Còn 760 XP nữa là lên cấp 8 ',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${user.xp} / 2000',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E6353),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: user.xp / 2000,
                    backgroundColor: const Color(0xFFEBE5D9),
                    color: const Color(0xFF1E6353),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFEBE5D9)),
          Row(
            children: [
              _buildStatItem('17', 'sao'),
              Container(width: 1, height: 50, color: const Color(0xFFEBE5D9)),
              _buildStatItem(
                '6',
                'thẻ bài',
                valueColor: const Color(0xFF1E6353),
              ),
              Container(width: 1, height: 50, color: const Color(0xFFEBE5D9)),
              _buildStatItem(
                '${user.streakDays}',
                'ngày liền',
                valueColor: Colors.deepOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, {Color? valueColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: valueColor ?? const Color(0xFFB97F29),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakSection(UserModel user) {
    return AppCard(
      isActive: false,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chuỗi ngày học',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Giữ chuỗi nhé!',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayNode('T2', true, false),
              _buildDayNode('T3', true, false),
              _buildDayNode('T4', true, false),
              _buildDayNode('T5', true, false),
              _buildDayNode('Hôm\nnay', false, true),
              _buildDayNode('CN', false, false, isEmpty: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayNode(
    String day,
    bool isCompleted,
    bool isToday, {
    bool isEmpty = false,
  }) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(14),
            color: isToday
                ? Colors.deepOrange
                : (isCompleted ? const Color(0xFFF2F8F7) : Colors.transparent),
            border: isCompleted
                ? Border.all(
                    color: const Color(0xFF1E6353).withValues(alpha: 0.3),
                  )
                : (isEmpty
                      ? Border.all(color: Colors.grey.shade300, width: 1.5)
                      : null),
          ),
          child: Center(
            child: isToday
                ? const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 24,
                  )
                : (isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          color: Color(0xFF1E6353),
                          size: 24,
                        )
                      : null),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isToday ? Colors.deepOrange : AppColors.textSecondary,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return AppCard(
      isActive: false,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F3E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: Color(0xFFB97F29),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thành tựu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '9 / 24 đã mở · gần nhất:\n"Đọc 5 ngày liền"',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildCardMuseumHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bảo tàng thẻ bài',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '6 / 18',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: const LinearProgressIndicator(
            value: 6 / 18,
            backgroundColor: Color(0xFFEBE5D9),
            color: AppColors.gold,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Đạt 3 sao ở một sự kiện để nhận thẻ của mốc đó.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCardMuseumGrid(List<HeroCardModel> cards) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 9, // showing some empty cards for demo
      // Landscape: dùng lưới co giãn theo chiều rộng thay vì cố định 3 cột,
      // để tận dụng không gian ngang thay vì luôn chỉ có 3 cột hẹp.
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 130,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        if (index < cards.length) {
          return _buildHeroCard(cards[index]);
        }
        return _buildEmptyCard(index);
      },
    );
  }

  Widget _buildHeroCard(HeroCardModel card) {
    Color rarityColor = const Color(0xFF1E6353); // teal/green
    String rarityText = 'Rare';
    if (card.stars == 5) {
      rarityColor = const Color(0xFFB97F29); // gold
      rarityText = 'Legendary';
    } else if (card.stars == 4) {
      rarityColor = const Color(0xFF6B429A); // purple
      rarityText = 'Epic';
    }

    Color bgColor = rarityColor.withValues(alpha: 0.08);

    IconData cardIcon = Icons.auto_awesome_mosaic_outlined;
    if (card.heroName.contains("Ngô Quyền")) cardIcon = Icons.close;
    if (card.heroName.contains("Bạch Đằng")) cardIcon = Icons.waves_rounded;
    if (card.heroName.contains("Lý")) cardIcon = Icons.nightlight_round;
    if (card.heroName.contains("Mai")) cardIcon = Icons.edit_rounded;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(cardIcon, color: rarityColor, size: 28),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              card.heroName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: rarityColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              rarityText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: rarityColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(int index) {
    Color rarityColor = index % 2 == 0
        ? const Color(0xFF6B429A)
        : const Color(0xFFB97F29);
    String rarityText = index % 2 == 0 ? 'Epic' : 'Legendary';
    if (index % 3 == 0) {
      rarityColor = const Color(0xFF1E6353);
      rarityText = 'Rare';
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        color: const Color(0xFFFAF8F5),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEBE5D9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  '?',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '???',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              rarityText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
