import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

/// Khung điều hướng chính của app.
/// Navigation được cất vào một bottom sheet, mở/đóng bằng
/// nút tròn có icon hamburger (≡) ở góc dưới phải màn hình.
class ScaffoldWithNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar>
    with SingleTickerProviderStateMixin {
  static const _items = [
    (label: 'Bản đồ', icon: Icons.map_rounded),
    (label: 'Bảng vàng', icon: Icons.emoji_events_rounded),
    (label: 'Trò chơi', icon: Icons.games_rounded),
    (label: 'Tin tức', icon: Icons.forum_rounded),
    (label: 'Của tôi', icon: Icons.person_rounded),
  ];

  bool _isOpen = false;

  late final AnimationController _iconAnim;
  late final Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _iconAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _rotateAnim = Tween<double>(begin: 0, end: 0.375).animate(
      CurvedAnimation(parent: _iconAnim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _iconAnim.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    setState(() => _isOpen = true);
    _iconAnim.forward();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isDismissible: true,
      enableDrag: true,
      useRootNavigator: true,
      builder: (_) => _NavBottomSheet(
        currentIndex: widget.navigationShell.currentIndex,
        items: _items,
        onTap: (index) {
          _closeMenu();
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
      ),
    ).whenComplete(() {
      if (mounted) {
        setState(() => _isOpen = false);
        _iconAnim.reverse();
      }
    });
  }

  void _closeMenu() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: widget.navigationShell,
      floatingActionButton: _HamburgerFab(
        rotateAnim: _rotateAnim,
        onPressed: _toggleMenu,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// ---------------------------------------------------------------------------
// Nút tròn hamburger
// ---------------------------------------------------------------------------

class _HamburgerFab extends StatelessWidget {
  final Animation<double> rotateAnim;
  final VoidCallback onPressed;

  const _HamburgerFab({
    required this.rotateAnim,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: rotateAnim,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: const CircleBorder(),
        tooltip: 'Điều hướng',
        child: const _HamburgerIcon(),
      ),
    );
  }
}

/// Icon 3 sọc ngang tự vẽ bằng CustomPainter.
class _HamburgerIcon extends StatelessWidget {
  const _HamburgerIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(22, 16),
      painter: _HamburgerPainter(color: Colors.white),
    );
  }
}

class _HamburgerPainter extends CustomPainter {
  final Color color;
  const _HamburgerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    canvas.drawLine(Offset(0, 0), Offset(w, 0), paint);
    canvas.drawLine(Offset(0, h / 2), Offset(w, h / 2), paint);
    canvas.drawLine(Offset(0, h), Offset(w, h), paint);
  }

  @override
  bool shouldRepaint(_HamburgerPainter old) => old.color != color;
}

// ---------------------------------------------------------------------------
// Bottom sheet chứa các mục navigation
// ---------------------------------------------------------------------------

class _NavBottomSheet extends StatelessWidget {
  final int currentIndex;
  final List<({String label, IconData icon})> items;
  final ValueChanged<int> onTap;

  const _NavBottomSheet({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < items.length; i++)
                  _SheetItem(
                    label: items[i].label,
                    icon: items[i].icon,
                    isSelected: currentIndex == i,
                    onTap: () => onTap(i),
                  ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SheetItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected
                  ? AppColors.primaryDark
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
                height: 1.2,
                color: isSelected
                    ? AppColors.primaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
