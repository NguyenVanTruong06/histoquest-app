import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'antique_map_background_painter.dart';

/// Painter vẽ lộ trình "cổ đạo" uốn lượn nối các mốc sự kiện trên địa đồ cổ phong.
///
/// - Đường mòn hoàng thổ viền mực; đoạn đã đi qua được dát vàng (gilded trail).
/// - Phiến đá lát rải dọc đường.
/// - Cầu đá vòm bắc qua sông tại mọi điểm đường cắt dòng sông của nền bản đồ
///   (xem [antiqueRiverX]).
class MapWindingPathPainter extends CustomPainter {
  final List<Offset> nodePositions;
  final int completedIndex; // Vị trí sự kiện đã hoàn thành cuối cùng (-1 nếu chưa có)
  final int activeIndex; // Vị trí sự kiện đang kích hoạt học tập

  const MapWindingPathPainter({
    required this.nodePositions,
    required this.completedIndex,
    required this.activeIndex,
  });

  static const Color _ink = Color(0xFF2B2119);
  static const Color _ochre = Color(0xFFE0C98B);
  static const Color _ochreEdge = Color(0xFF8B6B34);

  Path _buildPath(int lastIndex) {
    final path = Path()..moveTo(nodePositions.first.dx, nodePositions.first.dy);
    for (int i = 0; i < lastIndex; i++) {
      final p1 = nodePositions[i];
      final p2 = nodePositions[i + 1];
      final midY = (p1.dy + p2.dy) / 2;
      path.cubicTo(p1.dx, midY, p2.dx, midY, p2.dx, p2.dy);
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (nodePositions.length < 2) return;

    final last = nodePositions.length - 1;
    final fullPath = _buildPath(last);
    final progressLimit = activeIndex >= 0 ? activeIndex.clamp(0, last) : 0;
    final progressPath = progressLimit > 0 ? _buildPath(progressLimit) : null;

    // 1. Bóng đổ nhẹ dưới đường mòn
    canvas.drawPath(
      fullPath.shift(const Offset(0, 2)),
      Paint()
        ..color = const Color(0x303A2A1A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 17
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5),
    );

    // 2. Đường mòn hoàng thổ: viền mực nâu + lòng đất vàng
    canvas.drawPath(
      fullPath,
      Paint()
        ..color = _ochreEdge.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      fullPath,
      Paint()
        ..color = _ochre
        ..style = PaintingStyle.stroke
        ..strokeWidth = 11
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    // Nét mực mảnh giữa đường (nét cọ)
    canvas.drawPath(
      fullPath,
      Paint()
        ..color = _ink.withValues(alpha: 0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );

    // 3. Đoạn đã đi qua: dát vàng hoàng kim
    if (progressPath != null) {
      canvas.drawPath(
        progressPath,
        Paint()
          ..color = AppColors.gold.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 22
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawPath(
        progressPath,
        Paint()
          ..color = const Color(0xFF9A6A12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 15
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        progressPath,
        Paint()
          ..color = AppColors.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 11
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        progressPath,
        Paint()
          ..color = const Color(0xFFFFF0B8).withValues(alpha: 0.75)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // 4. Phiến đá lát dọc đường (đoạn đã đi: ngọc sáng; đoạn chưa: đá trầm)
    _paintStepStones(canvas, fullPath, progressPath);

    // 5. Cầu đá vòm tại các chỗ đường cắt sông
    _paintBridges(canvas, size, last);
  }

  void _paintStepStones(Canvas canvas, Path fullPath, Path? progressPath) {
    final progressLen = progressPath == null
        ? 0.0
        : progressPath.computeMetrics().fold<double>(0, (a, m) => a + m.length);

    final walked = Paint()..color = const Color(0xFFFFF3C4);
    final walkedEdge = Paint()
      ..color = const Color(0xFF9A6A12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final idle = Paint()..color = const Color(0xFFB79F63).withValues(alpha: 0.75);

    double travelled = 0;
    for (final metric in fullPath.computeMetrics()) {
      for (double d = 16; d < metric.length; d += 26) {
        final tan = metric.getTangentForOffset(d);
        if (tan == null) continue;
        final isWalked = travelled + d <= progressLen;
        final rect = Rect.fromCenter(center: Offset.zero, width: 6.5, height: 3.6);
        canvas.save();
        canvas.translate(tan.position.dx, tan.position.dy);
        canvas.rotate(-tan.angle);
        final rr = RRect.fromRectAndRadius(rect, const Radius.circular(1.8));
        canvas.drawRRect(rr, isWalked ? walked : idle);
        if (isWalked) canvas.drawRRect(rr, walkedEdge);
        canvas.restore();
      }
      travelled += metric.length;
    }
  }

  /// Tìm các điểm đường mòn giao với dòng sông và dựng cầu đá vòm.
  void _paintBridges(Canvas canvas, Size size, int last) {
    final w = size.width;
    double? prevF;
    Offset? prev;

    for (int i = 0; i < last; i++) {
      final p1 = nodePositions[i];
      final p2 = nodePositions[i + 1];
      final midY = (p1.dy + p2.dy) / 2;
      prevF = null;
      prev = null;
      const n = 48;
      for (int s = 0; s <= n; s++) {
        final t = s / n;
        final x = _bez(p1.dx, p1.dx, p2.dx, p2.dx, t);
        final y = _bez(p1.dy, midY, midY, p2.dy, t);
        final f = x - antiqueRiverX(y, w);
        final cur = Offset(x, y);
        if (prevF != null && prev != null && (prevF < 0) != (f < 0)) {
          final k = prevF.abs() / (prevF.abs() + f.abs());
          final center = Offset.lerp(prev, cur, k)!;
          final d = cur - prev;
          _drawArchBridge(canvas, center, math.atan2(d.dy, d.dx), i < activeIndex);
        }
        prevF = f;
        prev = cur;
      }
    }
  }

  /// Cầu vòm đá, trục dọc theo hướng đường ([angle]).
  void _drawArchBridge(Canvas canvas, Offset c, double angle, bool walked) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle);

    const len = kAntiqueRiverWidth + 26.0; // dài theo hướng đi
    const wid = 22.0; // rộng ngang đường

    // Bóng cầu xuống mặt nước
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(0, 3), width: len, height: wid),
        const Radius.circular(8),
      ),
      Paint()..color = _ink.withValues(alpha: 0.22),
    );

    // Thân cầu: đá xám ấm, lưng cầu cong (arch)
    final deck = Path()
      ..moveTo(-len / 2, wid / 2)
      ..lineTo(-len / 2, -wid / 2)
      ..quadraticBezierTo(0, -wid / 2 - 5, len / 2, -wid / 2)
      ..lineTo(len / 2, wid / 2)
      ..quadraticBezierTo(0, wid / 2 + 5, -len / 2, wid / 2)
      ..close();

    canvas.drawPath(
      deck,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, -wid / 2),
          Offset(0, wid / 2),
          walked
              ? const [Color(0xFFF1D68A), Color(0xFFC79A2E)]
              : const [Color(0xFFCFC2A2), Color(0xFF9F9376)],
        ),
    );
    canvas.drawPath(
      deck,
      Paint()
        ..color = _ink.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeJoin = StrokeJoin.round,
    );

    // Lan can hai bên (dọc theo chiều dài cầu)
    final rail = Paint()
      ..color = _ink.withValues(alpha: 0.7)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-len / 2 + 3, -wid / 2 + 2.5), Offset(len / 2 - 3, -wid / 2 + 2.5), rail);
    canvas.drawLine(Offset(-len / 2 + 3, wid / 2 - 2.5), Offset(len / 2 - 3, wid / 2 - 2.5), rail);
    // Trụ lan can
    for (final dx in [-len / 2 + 4, 0.0, len / 2 - 4]) {
      canvas.drawCircle(Offset(dx, -wid / 2 + 2.5), 1.6, Paint()..color = _ink.withValues(alpha: 0.8));
      canvas.drawCircle(Offset(dx, wid / 2 - 2.5), 1.6, Paint()..color = _ink.withValues(alpha: 0.8));
    }

    // Vòm dưới cầu
    canvas.drawArc(
      Rect.fromCenter(center: Offset(0, 0), width: len * 0.55, height: wid * 0.85),
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = _ink.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    canvas.restore();
  }

  double _bez(double p0, double p1, double p2, double p3, double t) {
    final u = 1 - t;
    return u * u * u * p0 + 3 * u * u * t * p1 + 3 * u * t * t * p2 + t * t * t * p3;
  }

  @override
  bool shouldRepaint(covariant MapWindingPathPainter oldDelegate) {
    return oldDelegate.nodePositions != nodePositions ||
        oldDelegate.completedIndex != completedIndex ||
        oldDelegate.activeIndex != activeIndex;
  }
}
