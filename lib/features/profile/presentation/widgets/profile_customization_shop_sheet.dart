import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/profile_decorations.dart';
import '../../../../data/models/user_model.dart';
import '../../../../shared/widgets/stat_badge.dart';

class ProfileCustomizationShopSheet extends StatefulWidget {
  final UserModel user;
  final ValueChanged<UserModel> onUpdateUser;

  const ProfileCustomizationShopSheet({
    super.key,
    required this.user,
    required this.onUpdateUser,
  });

  static Future<void> show(
    BuildContext context, {
    required UserModel user,
    required ValueChanged<UserModel> onUpdateUser,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileCustomizationShopSheet(
        user: user,
        onUpdateUser: onUpdateUser,
      ),
    );
  }

  @override
  State<ProfileCustomizationShopSheet> createState() =>
      _ProfileCustomizationShopSheetState();
}

class _ProfileCustomizationShopSheetState
    extends State<ProfileCustomizationShopSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _buyItem(ProfileDecorationItem item) {
    if (_user.coins < item.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bạn còn thiếu ${item.price - _user.coins} xu để mua vật phẩm này!'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final newUnlocked = List<String>.from(_user.unlockedDecorationIds)..add(item.id);
    final updated = _user.copyWith(
      coins: _user.coins - item.price,
      unlockedDecorationIds: newUnlocked,
      currentFrameId: item.type == DecorationType.frame ? item.id : _user.currentFrameId,
      currentBannerId: item.type == DecorationType.banner ? item.id : _user.currentBannerId,
    );

    setState(() {
      _user = updated;
    });
    widget.onUpdateUser(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Mua thành công và đã trang bị "${item.name}"!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _equipItem(ProfileDecorationItem item) {
    final updated = _user.copyWith(
      currentFrameId: item.type == DecorationType.frame ? item.id : _user.currentFrameId,
      currentBannerId: item.type == DecorationType.banner ? item.id : _user.currentBannerId,
    );

    setState(() {
      _user = updated;
    });
    widget.onUpdateUser(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✨ Đã trang bị "${item.name}"!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final frames = MockProfileDecorations.items
        .where((i) => i.type == DecorationType.frame)
        .toList();
    final banners = MockProfileDecorations.items
        .where((i) => i.type == DecorationType.banner)
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          // Header cửa hàng + Số dư ví Coin
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cửa Hàng Sử Quán',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tùy biến diện mạo nhà thám hiểm HistoQuest',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                StatBadge(
                  type: StatType.coin,
                  label: '${_user.coins} xu',
                ),
              ],
            ),
          ),

          // TabBar: Khung đại diện vs Ảnh bìa
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: 'Khung Avatar (Frames)'),
                Tab(text: 'Ảnh Bìa (Banners)'),
              ],
            ),
          ),

          // Danh sách vật phẩm theo Tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFramesGrid(frames),
                _buildBannersList(banners),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 1: DANH SÁCH KHUNG ĐẠI DIỆN
  // -------------------------------------------------------------
  Widget _buildFramesGrid(List<ProfileDecorationItem> frames) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.76,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: frames.length,
      itemBuilder: (context, index) {
        final item = frames[index];
        final isEquipped = _user.currentFrameId == item.id;
        final isUnlocked = _user.unlockedDecorationIds.contains(item.id);
        final canAfford = _user.coins >= item.price;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isEquipped ? AppColors.gold : AppColors.cardBorder,
              width: isEquipped ? 2 : 1,
            ),
            boxShadow: [
              if (isEquipped)
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Preview avatar với khung này
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(colors: item.gradientColors),
                ),
                padding: EdgeInsets.all(item.borderWidth * 0.8),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF2A241F),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: Container(
                      color: const Color(0xFF1E6353),
                      child: Center(
                        child: Text(
                          _user.name.isNotEmpty ? _user.name[0].toUpperCase() : 'H',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Tên khung
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Mô tả ngắn
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Nút Mua hoặc Trang bị
              _buildActionButton(
                item: item,
                isEquipped: isEquipped,
                isUnlocked: isUnlocked,
                canAfford: canAfford,
              ),
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------
  // TAB 2: DANH SÁCH ẢNH BÌA
  // -------------------------------------------------------------
  Widget _buildBannersList(List<ProfileDecorationItem> banners) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: banners.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = banners[index];
        final isEquipped = _user.currentBannerId == item.id;
        final isUnlocked = _user.unlockedDecorationIds.contains(item.id);
        final canAfford = _user.coins >= item.price;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isEquipped ? AppColors.gold : AppColors.cardBorder,
              width: isEquipped ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner preview 16:9 nhỏ
              Container(
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: item.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 12,
                      bottom: -10,
                      child: Icon(
                        item.icon,
                        size: 70,
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 130,
                      child: _buildActionButton(
                        item: item,
                        isEquipped: isEquipped,
                        isUnlocked: isUnlocked,
                        canAfford: canAfford,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required ProfileDecorationItem item,
    required bool isEquipped,
    required bool isUnlocked,
    required bool canAfford,
  }) {
    if (isEquipped) {
      return Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_rounded, size: 14, color: AppColors.textSecondary),
            SizedBox(width: 4),
            Text(
              'Đang Dùng',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (isUnlocked) {
      return SizedBox(
        height: 34,
        child: OutlinedButton(
          onPressed: () => _equipItem(item),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            padding: EdgeInsets.zero,
          ),
          child: const Text('Trang Bị', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
    }

    // Chưa mở khóa -> Nút Mua
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: canAfford ? () => _buyItem(item) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.monetization_on_rounded, size: 13, color: AppColors.gold),
            const SizedBox(width: 4),
            Text(
              canAfford ? '${item.price} xu' : 'Thiếu ${item.price - _user.coins}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
