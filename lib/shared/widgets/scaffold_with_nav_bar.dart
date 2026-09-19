import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import 'custom_floating_bottom_nav.dart';

/// Khung điều hướng chính của app HistoQuest dạng Floating Dual-Dock chuẩn iOS / Clean UI:
/// - Dock chính (trái): 4 danh mục chính của HistoQuest [Bản đồ, Bảng vàng, Trò chơi, Bản tin (kèm badge)]
/// - Dock phụ (phải): Nút tròn Cài đặt độc lập (width: 56, height: 56, BoxShape.circle)
/// - Tự động thu gọn (collapse / slide down) khi người dùng cuộn xuống để tối đa diện tích xem nội dung,
///   và mở lại mượt mà khi cuộn lên hoặc chuyển tab.
class ScaffoldWithNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  bool _isBarVisible = true;

  @override
  void didUpdateWidget(covariant ScaffoldWithNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Khi đổi tab, tự động hiện lại thanh điều hướng
    if (oldWidget.navigationShell.currentIndex != widget.navigationShell.currentIndex) {
      _isBarVisible = true;
    }
  }

  /// Ánh xạ branch index của router (0..4) sang tab index của dock chính (0..3):
  /// - Branch 0: /eras    -> Tab 0: Bản đồ
  /// - Branch 1: /ranks   -> Tab 1: Bảng vàng
  /// - Branch 2: /games   -> Tab 2: Trò chơi
  /// - Branch 3: /social  -> Tab 3: Bản tin
  /// - Branch 4: /profile -> Nút Cài đặt độc lập bên phải (-1)
  int _tabIndexForBranch(int branchIndex) {
    if (branchIndex >= 0 && branchIndex < 4) {
      return branchIndex;
    }
    return -1; // Cài đặt (nút độc lập)
  }

  /// Ánh xạ tab index của dock chính (0..3) sang branch index của router:
  int _branchForTabIndex(int tabIndex) {
    return tabIndex;
  }

  @override
  Widget build(BuildContext context) {
    final currentBranch = widget.navigationShell.currentIndex;
    final currentTabIndex = _tabIndexForBranch(currentBranch);
    final isSettingsActive = currentBranch == 4;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          // Chỉ phản hồi theo chiều cuộn dọc
          if (notification.metrics.axis == Axis.vertical) {
            if (notification.direction == ScrollDirection.reverse) {
              // Cuộn xuống -> thu gọn / ẩn thanh nav bar
              if (_isBarVisible) {
                setState(() => _isBarVisible = false);
              }
            } else if (notification.direction == ScrollDirection.forward) {
              // Cuộn lên -> bung mở / hiện lại thanh nav bar
              if (!_isBarVisible) {
                setState(() => _isBarVisible = true);
              }
            }
          }
          return false;
        },
        child: Stack(
          children: [
            // 1. Màn hình nhánh hiện tại (cuộn xuyên suốt xuống dưới dock)
            widget.navigationShell,

            // 2. Thanh điều hướng nổi (Custom Floating Dual-Dock)
            // Hiệu ứng thu gọn mượt mà AnimatedSlide + AnimatedOpacity
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSlide(
                offset: _isBarVisible ? Offset.zero : const Offset(0, 1.4),
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                child: AnimatedOpacity(
                  opacity: _isBarVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: IgnorePointer(
                    ignoring: !_isBarVisible,
                    child: CustomFloatingBottomNav(
                      currentIndex: currentTabIndex,
                      isSettingsSelected: isSettingsActive,
                      onTap: (tabIndex) {
                        setState(() => _isBarVisible = true);
                        final targetBranch = _branchForTabIndex(tabIndex);
                        widget.navigationShell.goBranch(
                          targetBranch,
                          initialLocation: targetBranch == currentBranch,
                        );
                      },
                      onSettingsTap: () {
                        setState(() => _isBarVisible = true);
                        // Chuyển sang màn hình Cài đặt (Branch 4)
                        widget.navigationShell.goBranch(
                          4,
                          initialLocation: currentBranch == 4,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
