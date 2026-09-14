import 'dart:math';
import 'package:flutter/material.dart';

/// Clipper cắt hình Ngôi sao 5 cánh cân đối phong cách Gamification
class StarClipper extends CustomClipper<Path> {
  final double innerRadiusRatio;

  const StarClipper({this.innerRadiusRatio = 0.48});

  @override
  Path getClip(Size size) {
    return createStarPath(size, innerRadiusRatio: innerRadiusRatio);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;

  /// Hàm tiện ích tạo Path ngôi sao 5 cánh từ Size
  static Path createStarPath(Size size, {double innerRadiusRatio = 0.48}) {
    final path = Path();
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double outerRadius = min(cx, cy);
    final double innerRadius = outerRadius * innerRadiusRatio;

    const int points = 5;
    const double step = pi / points;
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
