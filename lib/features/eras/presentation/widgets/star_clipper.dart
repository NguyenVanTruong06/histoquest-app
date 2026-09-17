import 'dart:math';
import 'package:flutter/material.dart';

/// Clipper cắt hình ngôi sao N cánh cân đối phong cách Gamification.
///
/// [points] mặc định 5 (mốc lớn cũ). Mốc lớn (major milestone) trong bản đồ
/// Kingdom Rush dùng ngôi sao 6 cánh ([points] = 6) để phân biệt trực quan
/// với mốc Boss (khiên) và mốc phụ (vòng tròn).
class StarClipper extends CustomClipper<Path> {
  final double innerRadiusRatio;
  final int points;

  const StarClipper({this.innerRadiusRatio = 0.48, this.points = 5});

  @override
  Path getClip(Size size) {
    return createStarPath(size, innerRadiusRatio: innerRadiusRatio, points: points);
  }

  @override
  bool shouldReclip(covariant StarClipper oldClipper) =>
      oldClipper.innerRadiusRatio != innerRadiusRatio || oldClipper.points != points;

  /// Hàm tiện ích tạo Path ngôi sao N cánh từ Size
  static Path createStarPath(Size size, {double innerRadiusRatio = 0.48, int points = 5}) {
    final path = Path();
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double outerRadius = min(cx, cy);
    final double innerRadius = outerRadius * innerRadiusRatio;

    final double step = pi / points;
    double currentAngle = -pi / 2; // Điểm đỉnh hướng thẳng lên trên

    for (int i = 0; i < points * 2; i++) {
      final double r = (i % 2 == 0) ? outerRadius : innerRadius;
      final double x = cx + r * cos(currentAngle);
      final double y = cy + r * sin(currentAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      currentAngle += step;
    }

    path.close();
    return path;
  }
}

/// Clipper cắt hình khiên (shield) dùng cho Node Boss ở cuối mỗi thời đại.
class ShieldClipper extends CustomClipper<Path> {
  const ShieldClipper();

  @override
  Path getClip(Size size) {
    return createShieldPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;

  static Path createShieldPath(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(0, h * 0.20);
    path.quadraticBezierTo(0, 0, w * 0.20, 0);
    path.lineTo(w * 0.80, 0);
    path.quadraticBezierTo(w, 0, w, h * 0.20);
    path.lineTo(w, h * 0.52);
    path.quadraticBezierTo(w, h * 0.80, w * 0.5, h);
    path.quadraticBezierTo(0, h * 0.80, 0, h * 0.52);
    path.close();
    return path;
  }
}
