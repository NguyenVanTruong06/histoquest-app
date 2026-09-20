import 'package:flutter/material.dart';
import '../../core/config/feature_flags.dart';
import '../../features/chatbot/presentation/mascot_chatbot_sheet.dart';

/// Item dữ liệu cho từng tab trên Floating Pill Dock
class FloatingNavItem {
  final String label;
  final IconData icon;
  final String? badge;

  const FloatingNavItem({
    required this.label,
    required this.icon,
    this.badge,
  });
}

/// Custom Floating Bottom Navigation Bar dạng nổi (Floating Dual-Dock)
/// Chuẩn phong cách iOS / Clean UI:
/// - Phần 1: Dock chức năng chính (Bên trái, dạng viên thuốc bo tròn lớn `BorderRadius.circular(35)`),
///   chứa 4 tab điều hướng với hiệu ứng pill xanh active `Color(0xFFE8F1FD)` và icon/text `Color(0xFF1976D2)`.
/// - Phần 2: Cột bên phải chứa Nút Cài đặt độc lập (56x56) và Nút Chatbot Linh Vật (52x52)
///   nằm ngay phía trên nút Cài đặt (quản lý qua `FeatureFlags.enableAiChatbot`).
class CustomFloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onSettingsTap;
  final VoidCallback? onChatbotTap;
  final bool isSettingsSelected;
  final List<FloatingNavItem> items;

  const CustomFloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onSettingsTap,
    this.onChatbotTap,
    this.isSettingsSelected = false,
    this.items = const [
      FloatingNavItem(
        label: 'Bản đồ',
        icon: Icons.map_rounded,
      ),
      FloatingNavItem(
        label: 'Bảng vàng',
        icon: Icons.emoji_events_rounded,
      ),
      FloatingNavItem(
        label: 'Trò chơi',
        icon: Icons.sports_esports_rounded,
      ),
      FloatingNavItem(
        label: 'Bản tin',
        icon: Icons.newspaper_rounded,
        badge: '3',
      ),
    ],
  });

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        bottom: bottomSafeArea > 0 ? bottomSafeArea + 6 : 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ===================================================================
          // PHẦN 1: DOCK CHỨC NĂNG CHÍNH (Viên thuốc lớn bên trái)
          // ===================================================================
          Expanded(
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final isSelected = !isSettingsSelected && currentIndex == index;
                    return Expanded(
                      child: Center(
                        child: _buildDockTab(item: item, isSelected: isSelected, index: index),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ===================================================================
          // PHẦN 2: CỘT NÚT CÀI ĐẶT & CHATBOT LINH VẬT
          // ===================================================================
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nút Chatbot Linh Vật Văn Miếu Thư Sinh Ngưu (Nằm ngay trên icon Cài đặt)
              // Tự động ẩn hoàn toàn khi FeatureFlags.enableAiChatbot == false
              if (FeatureFlags.enableAiChatbot) ...[
                _buildChatbotButton(context),
                const SizedBox(height: 8),
              ],

              // Nút Cài đặt độc lập (Hình tròn 56x56)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: _buildSettingsButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Nút Chatbot Trợ lý Sử Ký AI (Văn Miếu Thư Sinh Ngưu)
  Widget _buildChatbotButton(BuildContext context) {
    return Tooltip(
      message: 'Trợ lý Sử Ký Bé Sửu (Đang phát triển)',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (onChatbotTap != null) {
              onChatbotTap!();
            } else {
              MascotChatbotSheet.show(context);
            }
          },
          customBorder: const CircleBorder(),
          splashColor: const Color(0xFFFFF8E1),
          highlightColor: const Color(0xFFFFFDE7),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFC89B3C), // Viền vàng đồng hoàng gia
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC89B3C).withValues(alpha: 0.35),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/mascot/thu_sinh_nguu_avatar.jpg',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.smart_toy_rounded,
                        color: Color(0xFF2E7D32),
                        size: 24,
                      ),
                    ),
                  ),
                ),
                // Huy hiệu "AI" nhỏ ở góc trên bên phải
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE65100), Color(0xFFFF8F00)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Text(
                      'AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Nút Cài đặt độc lập
  Widget _buildSettingsButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSettingsTap,
          customBorder: const CircleBorder(),
          splashColor: const Color(0xFFE8F1FD),
          highlightColor: const Color(0xFFF5F7FB),
          child: Center(
            child: Icon(
              Icons.settings_rounded,
              size: 26,
              color: isSettingsSelected
                  ? const Color(0xFF1976D2)
                  : const Color(0xFF262626),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDockTab({
    required FloatingNavItem item,
    required bool isSelected,
    required int index,
  }) {
    const activeBgColor = Color(0xFFE8F1FD);
    const activeColor = Color(0xFF1976D2);
    const inactiveColor = Color(0xFF2E2E2E);
    const inactiveTextColor = Color(0xFF383838);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(24),
        splashColor: activeBgColor,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 10 : 4,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: isSelected ? activeBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon kèm Badge thông báo nếu có
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    item.icon,
                    size: 22,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                  if (item.badge != null)
                    Positioned(
                      top: -6,
                      right: -14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.5,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF03D3D),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        constraints: const BoxConstraints(minWidth: 16),
                        child: Text(
                          item.badge!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              // Nhãn tên tab
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveTextColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
