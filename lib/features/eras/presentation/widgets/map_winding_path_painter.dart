import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Painter vẽ đường uốn lượn hình chữ S dạng Board Game nối các mốc sự kiện
class MapWindingPathPainter extends CustomPainter {
  final List<Offset> nodePositions;
  final int completedIndex; // Vị trí sự kiện đã hoàn thành cuối cùng (-1 nếu chưa có)
  final int activeIndex;    // Vị trí sự kiện đang kích hoạt học tập

  const MapWindingPathPainter({
    required this.nodePositions,
    required this.completedIndex,
    required this.activeIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (nodePositions.length < 2) return;

    // 1. Vẽ bóng đổ nhẹ của toàn bộ đường mòn
    final shadowPaint = Paint()
      ..color = const Color(0x203A2A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    final fullPath = Path();
    fullPath.moveTo(nodePositions.first.dx, nodePositions.first.dy);
    for (int i = 0; i < nodePositions.length - 1; i++) {
      final p1 = nodePositions[i];
      final p2 = nodePositions[i + 1];
      final midY = (p1.dy + p2.dy) / 2;
      fullPath.cubicTo(p1.dx, midY, p2.dx, midY, p2.dx, p2.dy);
    }
    canvas.drawPath(fullPath, shadowPaint);

    // 2. Vẽ đường ray nền màu đá/giấy cổ (Đoạn chưa mở khóa / toàn bộ đường)
    final baseTrackPaint = Paint()
      ..color = const Color(0xFFE2DDD2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final baseBorderPaint = Paint()
      ..color = const Color(0xFFCCC5B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(fullPath, baseBorderPaint);
    canvas.drawPath(fullPath, baseTrackPaint);

    // 3. Vẽ đường tiến trình rực rỡ (Đoạn đã hoàn thành và đang học)
    if (activeIndex >= 0) {
      final progressLimit = activeIndex.clamp(0, nodePositions.length - 1);
      final progressPath = Path();
      progressPath.moveTo(nodePositions.first.dx, nodePositions.first.dy);

      for (int i = 0; i < progressLimit; i++) {
        final p1 = nodePositions[i];
        final p2 = nodePositions[i + 1];
        final midY = (p1.dy + p2.dy) / 2;
        progressPath.cubicTo(p1.dx, midY, p2.dx, midY, p2.dx, p2.dy);
      }

      final progressBorderPaint = Paint()
        ..color = const Color(0xFFC78B24) // Viền vàng đậm 3D
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final progressTrackPaint = Paint()
        ..color = AppColors.gold // Vàng hoàng kim #E4A93A
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(progressPath, progressBorderPaint);
      canvas.drawPath(progressPath, progressTrackPaint);
    }

    // 4. Vẽ các viên đá lát đường / chấm tròn board game dọc theo từng đoạn
    final stepPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < nodePositions.length - 1; i++) {
      final p1 = nodePositions[i];
      final p2 = nodePositions[i + 1];
      final isCompletedOrActive = i < activeIndex;

      stepPaint.color = isCompletedOrActive
          ? const Color(0xFFFFF6D6) // Màu chấm ngọc sáng trên đoạn đã đi qua
          : const Color(0xFFBFB7A8); // Màu đá trầm trên đoạn khóa

      // Tạo 3 bước chân trên mỗi đường cong nối 2 node
      const int steps = 4;
      for (int s = 1; s < steps; s++) {
        final t = s / steps;
        final midY = (p1.dy + p2.dy) / 2;
        // Tính tọa độ điểm trên đường cong cubic bezier
        final x = _cubicBezierValue(p1.dx, p1.dx, p2.dx, p2.dx, t);
        final y = _cubicBezierValue(p1.dy, midY, midY, p2.dy, t);

        canvas.drawCircle(Offset(x, y), 3.5, stepPaint);
      }
    }
  }

  /// Tính giá trị B(t) cho Cubic Bezier với 4 điểm điều khiển
  double _cubicBezierValue(double p0, double p1, double p2, double p3, double t) {
    final double u = 1 - t;
    final double tt = t * t;
    final double uu = u * u;
    final double uuu = uu * u;
    final double ttt = tt * t;

    return (uuu * p0) + (3 * uu * t * p1) + (3 * u * tt * p2) + (ttt * p3);
  }

  @override
  bool shouldRepaint(covariant MapWindingPathPainter oldDelegate) {
    return oldDelegate.nodePositions != nodePositions ||
        oldDelegate.completedIndex != completedIndex ||
        oldDelegate.activeIndex != activeIndex;
  }
}
