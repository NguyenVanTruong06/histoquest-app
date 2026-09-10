import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border(
            top: BorderSide(color: Color(0xFFDED4C4), width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, 'Bản đồ', Icons.map),
                _buildNavItem(1, 'Bảng vàng', Icons.emoji_events),
                _buildNavItem(2, 'Trò chơi', Icons.games),
                _buildNavItem(3, 'Tin tức', Icons.forum),
                _buildNavItem(4, 'Của tôi', Icons.person),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData iconData) {
    final isSelected = navigationShell.currentIndex == index;
    return GestureDetector(
      onTap: () {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 76, minWidth: 64),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF7E7E0) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: isSelected ? const Color(0xFFA53B20) : const Color(0xFF6E675D),
              size: 26,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFA53B20) : const Color(0xFF6E675D),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.308,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
