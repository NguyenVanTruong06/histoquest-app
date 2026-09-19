import 'package:flutter/material.dart';

/// Widget vẽ banner phong cảnh đồi cỏ xanh ngát và mây trời bồng bềnh
/// theo đúng phong cách minh họa trong mockup thiết kế.
class LandscapeBannerWidget extends StatelessWidget {
  final Widget? badge;
  final bool showFlagBadge;
  final String? flagEmoji;

  const LandscapeBannerWidget({
    super.key,
    this.badge,
    this.showFlagBadge = true,
    this.flagEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _LandscapeBannerPainter(),
          ),
          if (showFlagBadge)
            Positioned(
              top: 12,
              right: 14,
              child: badge ?? _buildRoundVietnamFlag(),
            ),
        ],
      ),
    );
  }

  Widget _buildRoundVietnamFlag() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFDA251D),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.star_rounded,
          color: Color(0xFFFFEB3B),
          size: 20,
        ),
      ),
    );
  }
}

class _LandscapeBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Nền trời xanh trong trẻo (Sky gradient)
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE0F4FF), Color(0xFFBDE9FE)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), skyPaint);

    // 2. Các cụm mây trắng bồng bềnh
    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..style = PaintingStyle.fill;

    _drawCloud(canvas, cloudPaint, Offset(w * 0.18, h * 0.28), 24);
    _drawCloud(canvas, cloudPaint, Offset(w * 0.58, h * 0.25), 32);
    _drawCloud(canvas, cloudPaint, Offset(w * 0.90, h * 0.38), 20);

    // 3. Đồi cỏ xanh phía xa (Background hills)
    final backHillPaint = Paint()
      ..color = const Color(0xFFA6CC4F)
      ..style = PaintingStyle.fill;

    final backHillPath = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.22, h * 0.55, w * 0.45, h * 0.68)
      ..quadraticBezierTo(w * 0.70, h * 0.78, w, h * 0.65)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backHillPath, backHillPaint);

    // 4. Đồi cỏ xanh phía gần (Foreground hills - xanh tươi hơn)
    final foreHillPaint = Paint()
      ..color = const Color(0xFF86AC24)
      ..style = PaintingStyle.fill;

    final foreHillPath = Path()
      ..moveTo(0, h * 0.64)
      ..quadraticBezierTo(w * 0.12, h * 0.60, w * 0.28, h * 0.72)
      ..quadraticBezierTo(w * 0.62, h * 0.86, w * 0.82, h * 0.70)
      ..quadraticBezierTo(w * 0.94, h * 0.62, w, h * 0.68)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(foreHillPath, foreHillPaint);

    // Chi tiết bóng cỏ ở chân đồi
    final hillShadowPaint = Paint()
      ..color = const Color(0xFF6E9117)
      ..style = PaintingStyle.fill;

    final shadowPath = Path()
      ..moveTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.25, h * 0.75, w * 0.50, h * 0.88)
      ..quadraticBezierTo(w * 0.78, h * 0.82, w, h * 0.84)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(shadowPath, hillShadowPaint);
  }

  void _drawCloud(Canvas canvas, Paint paint, Offset center, double baseRadius) {
    // Vẽ cụm mây gồm 3 hình tròn chồng nhau tạo dáng mây hoạt hình
    canvas.drawCircle(center, baseRadius, paint);
    canvas.drawCircle(Offset(center.dx - baseRadius * 0.65, center.dy + baseRadius * 0.15), baseRadius * 0.68, paint);
    canvas.drawCircle(Offset(center.dx + baseRadius * 0.70, center.dy + baseRadius * 0.18), baseRadius * 0.72, paint);
    // Làm phẳng đáy mây nhẹ
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + baseRadius * 0.35),
          width: baseRadius * 2.5,
          height: baseRadius * 0.75,
        ),
        Radius.circular(baseRadius * 0.35),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
