import 'package:flutter/material.dart';
import '../../core/config/feature_flags.dart';
import '../../features/chatbot/presentation/mascot_chatbot_sheet.dart';

/// Item dữ liệu cho từng tab trên Floating Pill Dock
class FloatingNavItem {
  final String label;
  final IconData icon;
  final String? badge;
  final Color? activeColor;
  final Color? activeBgColor;

  const FloatingNavItem({
    required this.label,
    required this.icon,
    this.badge,
    this.activeColor,
    this.activeBgColor,
  });
}

/// Custom Floating Bottom Navigation Bar dạng nổi (Floating Dual-Dock)
/// Phong cách iOS / Clean UI & Dynamic Theme theo từng trang:
/// - Tab 0 (Bản đồ): Lam ngọc lịch sử (Sky Cyan #0284C7 / #E0F2FE)
/// - Tab 1 (Bảng vàng): Vàng kim hoàng gia (Royal Amber #D97706 / #FEF3C7)
/// - Tab 2 (Trò chơi): Tím năng lượng Kỳ Đài (Arcade Purple #7C3AED / #EDE9FE)
/// - Tab 3 (Bản tin): Xanh trúc tri thức (Bamboo Green #16A34A / #DCFCE7)
/// - Nút Cài đặt (Slate Trầm) & Chatbot linh vật đồng bộ hài hòa.
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
        activeColor: Color(0xFF0284C7),
        activeBgColor: Color(0xFFE0F2FE),
      ),
      FloatingNavItem(
        label: 'Bảng vàng',
        icon: Icons.emoji_events_rounded,
        activeColor: Color(0xFFD97706),
        activeBgColor: Color(0xFFFEF3C7),
      ),
      FloatingNavItem(
        label: 'Trò chơi',
        icon: Icons.sports_esports_rounded,
        activeColor: Color(0xFF7C3AED),
        activeBgColor: Color(0xFFEDE9FE),
      ),
      FloatingNavItem(
        label: 'Bản tin',
        icon: Icons.newspaper_rounded,
        activeColor: Color(0xFF16A34A),
        activeBgColor: Color(0xFFDCFCE7),
        badge: '3',
      ),
    ],
  });

  /// Màu active chủ đạo hiện tại của trang
  Color _getCurrentActiveColor() {
    if (isSettingsSelected) {
      return const Color(0xFF475569);
    }
    if (currentIndex >= 0 && currentIndex < items.length) {
      return items[currentIndex].activeColor ?? const Color(0xFF0284C7);
    }
    return const Color(0xFF0284C7);
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;
    final activeThemeColor = _getCurrentActiveColor();

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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: isSettingsSelected
                      ? const Color(0xFFE2E8F0)
                      : activeThemeColor.withValues(alpha: 0.22),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: activeThemeColor.withValues(alpha: 0.12),
                    blurRadius: 18,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
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
                color: const Color(0xFFE4A93A), // Viền vàng hoàng gia
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE4A93A).withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
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
    final activeBgColor = isSettingsSelected ? const Color(0xFFF1F5F9) : Colors.white;
    final iconColor = isSettingsSelected
        ? const Color(0xFF334155)
        : const Color(0xFF64748B);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: activeBgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSettingsSelected
              ? const Color(0xFF94A3B8)
              : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSettingsSelected
                ? const Color(0xFF475569).withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSettingsTap,
          customBorder: const CircleBorder(),
          splashColor: const Color(0xFFE2E8F0),
          highlightColor: const Color(0xFFF8FAFC),
          child: Center(
            child: Icon(
              Icons.settings_rounded,
              size: 25,
              color: iconColor,
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
    final activeColor = item.activeColor ?? const Color(0xFF0284C7);
    final activeBgColor = item.activeBgColor ?? const Color(0xFFE0F2FE);
    const inactiveIconColor = Color(0xFF64748B);
    const inactiveTextColor = Color(0xFF64748B);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(24),
        splashColor: activeBgColor,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 10 : 4,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: isSelected ? activeBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: isSelected
                ? Border.all(
                    color: activeColor.withValues(alpha: 0.18),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon kèm Badge thông báo nếu có
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      item.icon,
                      size: 22,
                      color: isSelected ? activeColor : inactiveIconColor,
                    ),
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
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
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
