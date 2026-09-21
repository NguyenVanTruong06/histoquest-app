import 'package:flutter/material.dart';
import '../hidden_relic_game_screen.dart';

class HiddenRelicPainting extends StatelessWidget {
  final RelicLevel currentLevel;
  final bool showHint;
  final VoidCallback onFound;
  final VoidCallback onWrongTap;

  const HiddenRelicPainting({
    super.key,
    required this.currentLevel,
    required this.showHint,
    required this.onFound,
    required this.onWrongTap,
  });

  void _handleTap(TapUpDetails details, Size size) {
    final double px = details.localPosition.dx / size.width;
    final double py = details.localPosition.dy / size.height;

    final double x = currentLevel.x;
    final double y = currentLevel.y;
    final double w = currentLevel.w;
    final double h = currentLevel.h;

    if (px >= x && px <= x + w && py >= y && py <= y + h) {
      onFound();
    } else {
      onWrongTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: InteractiveViewer(
        minScale: 1.0,
        maxScale: 3.0,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTapUp: (details) {
                // Lấy kích thước thực tế của vùng hiển thị ảnh
                final renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  _handleTap(details, renderBox.size);
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Ảnh nền
                  Image.asset(
                    'assets/images/games/hidden_relic_bg.jpg',
                    fit: BoxFit.cover,
                  ),
                  
                  // Vùng gợi ý (sáng lên khi dùng quyền trợ giúp)
                  if (showHint)
                    Positioned(
                      left: constraints.maxWidth * currentLevel.x,
                      top: constraints.maxHeight * currentLevel.y,
                      width: constraints.maxWidth * currentLevel.w,
                      height: constraints.maxHeight * currentLevel.h,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow.withValues(alpha: 0.3),
                          border: Border.all(color: Colors.yellowAccent, width: 3),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
