import 'package:flutter/material.dart';

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
/// - Phần 2: Nút Cài đặt độc lập (Bên phải, hình tròn hoàn hảo 56x56), tách riêng biệt,
///   khi được chọn đổi icon sang màu xanh.
class CustomFloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onSettingsTap;
  final bool isSettingsSelected;
  final List<FloatingNavItem> items;

  const CustomFloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onSettingsTap,
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
          // PHẦN 2: NÚT CÀI ĐẶT ĐỘC LẬP (Hình tròn hoàn hảo bên phải)
          // ===================================================================
          Container(
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
          ),
        ],
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
