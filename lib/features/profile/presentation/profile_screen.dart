import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/hero_card_model.dart';
import '../../../shared/widgets/app_card.dart';
import 'widgets/histo_profile_header.dart';
import 'widgets/profile_customization_shop_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = MockData.currentUser;
  }

  void _updateUser(UserModel updatedUser) {
    setState(() {
      _user = updatedUser;
      MockData.currentUser = updatedUser;
    });
  }

  void _openShop() {
    ProfileCustomizationShopSheet.show(
      context,
      user: _user,
      onUpdateUser: _updateUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<HeroCardModel> cards = MockData.heroCards;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Hồ Sơ Sử Quán',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HistoProfileHeader(
              user: _user,
              onOpenShop: _openShop,
              onCustomize: _openShop,
            ),
            const SizedBox(height: 16),
            _buildXpProgressBar(_user),
            const SizedBox(height: 16),
            _buildStreakSection(_user),
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

  Widget _buildXpProgressBar(UserModel user) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tiến độ danh vọng tiếp theo',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${user.xp} / 2000 XP',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E6353),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (user.xp / 2000).clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFEBE5D9),
              color: const Color(0xFF1E6353),
              minHeight: 10,
            ),
          ),
        ],
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
    String rarityText = index % 2 == 0 ? 'Epic' : 'Legendary';
    if (index % 3 == 0) {
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
