import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Toạ độ x của dòng sông (sông Hồng / Bạch Đằng) tại độ cao [y].
///
/// Dùng chung giữa nền bản đồ ([AntiqueMapBackgroundPainter]) và đường cổ đạo
/// (`MapWindingPathPainter`) để cầu đá vòm luôn bắc đúng vị trí giao cắt.
double antiqueRiverX(double y, double width) {
  return width * 0.5 +
      width * 0.11 * math.sin(y / 300.0) +
      width * 0.045 * math.sin(y / 97.0 + 1.3);
}

/// Bề rộng (px) của dòng sông.
const double kAntiqueRiverWidth = 30.0;

/// Nền địa đồ cổ phong / sơn thủy thuỷ mặc cho bản đồ sự kiện.
///
/// Vẽ (từ dưới lên): giấy da dê + hạt giấy → trống đồng Đông Sơn chìm →
/// núi thuỷ mặc hai bên → sông lam ngọc → cụm tùng bách → mây tường vân →
/// vignette ố góc. Mọi ngẫu nhiên dùng seed cố định nên hình luôn ổn định.
/// Toàn bộ là một [CustomPainter] tĩnh (`shouldRepaint` = false) — nên bọc
/// trong `RepaintBoundary` để cuộn mượt.
class AntiqueMapBackgroundPainter extends CustomPainter {
  const AntiqueMapBackgroundPainter();

  static const Color _ink = Color(0xFF2B2119);
  static const Color _paperLight = Color(0xFFE2D4AC);
  static const Color _paperMid = Color(0xFFD7C79E);
  static const Color _paperDark = Color(0xFFC8B688);
  static const Color _riverBlue = Color(0xFF5C9EAD);
  static const Color _moss = Color(0xFF4A6B48);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;
    final rnd = math.Random(20260920);

    _paintPaper(canvas, size, rnd);
    _paintDrumWatermark(canvas, size);
    _paintMountains(canvas, size, rnd);
    _paintRiver(canvas, size);
    _paintTrees(canvas, size, rnd);
    _paintClouds(canvas, size, rnd);
    _paintVignette(canvas, size);
  }

  // ───────────────────────────── Giấy da dê ─────────────────────────────
  void _paintPaper(Canvas canvas, Size size, math.Random rnd) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, size.height),
          const [_paperLight, _paperMid, _paperDark, _paperMid],
          const [0.0, 0.35, 0.75, 1.0],
        ),
    );

    // Vệt ố loang lổ
    for (int i = 0; i < math.max(6, (size.height / 320).round()); i++) {
      final c = Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      final r = 70 + rnd.nextDouble() * 120;
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = ui.Gradient.radial(
            c,
            r,
            [const Color(0xFF8A6A34).withValues(alpha: 0.10), const Color(0x00000000)],
          ),
      );
    }

    // Hạt giấy sần (vẽ gộp bằng drawPoints cho nhẹ)
    final count = (size.width * size.height / 260).round().clamp(600, 9000);
    final dark = <Offset>[];
    final light = <Offset>[];
    for (int i = 0; i < count; i++) {
      final p = Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      (i.isEven ? dark : light).add(p);
    }
    canvas.drawPoints(
      ui.PointMode.points,
      dark,
      Paint()
        ..color = const Color(0xFF6B5326).withValues(alpha: 0.16)
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPoints(
      ui.PointMode.points,
      light,
      Paint()
        ..color = const Color(0xFFFFF6DC).withValues(alpha: 0.22)
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );

    // Vài vết xước / nếp giấy
    final crease = Paint()
      ..color = const Color(0xFF6B5326).withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (int i = 0; i < math.max(5, (size.height / 400).round()); i++) {
      final y = rnd.nextDouble() * size.height;
      final path = Path()..moveTo(0, y);
      path.quadraticBezierTo(
        size.width * 0.5,
        y + (rnd.nextDouble() - 0.5) * 30,
        size.width,
        y + (rnd.nextDouble() - 0.5) * 20,
      );
      canvas.drawPath(path, crease);
    }
  }

  // ───────────────────── Trống đồng Đông Sơn (watermark) ─────────────────────
  void _paintDrumWatermark(Canvas canvas, Size size) {
    final radius = math.min(size.width * 0.42, 170.0);
    final spacing = 1500.0;
    for (double y = 520; y < size.height; y += spacing) {
      _drawBronzeDrum(canvas, Offset(size.width * 0.5, y), radius);
    }
  }

  void _drawBronzeDrum(Canvas canvas, Offset c, double r) {
    final line = Paint()
      ..color = const Color(0xFF6B4A1C).withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final fill = Paint()
      ..color = const Color(0xFF6B4A1C).withValues(alpha: 0.07)
      ..style = PaintingStyle.fill;

    // Các vành đồng tâm
    for (final f in const [1.0, 0.86, 0.66, 0.5, 0.3]) {
      canvas.drawCircle(c, r * f, line);
    }
    // Ngôi sao 14 cánh ở tâm
    final star = Path();
    const points = 14;
    for (int i = 0; i < points * 2; i++) {
      final rr = (i.isEven ? 0.30 : 0.15) * r;
      final a = -math.pi / 2 + i * math.pi / points;
      final p = Offset(c.dx + rr * math.cos(a), c.dy + rr * math.sin(a));
      if (i == 0) {
        star.moveTo(p.dx, p.dy);
      } else {
        star.lineTo(p.dx, p.dy);
      }
    }
    star.close();
    canvas.drawPath(star, fill);
    canvas.drawPath(star, line);

    // Vành răng cưa + chim Lạc cách điệu
    for (int i = 0; i < 48; i++) {
      final a = i * 2 * math.pi / 48;
      final p1 = Offset(c.dx + r * 0.86 * math.cos(a), c.dy + r * 0.86 * math.sin(a));
      final p2 = Offset(c.dx + r * 0.94 * math.cos(a), c.dy + r * 0.94 * math.sin(a));
      canvas.drawLine(p1, p2, line);
    }
    for (int i = 0; i < 10; i++) {
      final a = i * 2 * math.pi / 10;
      final bc = Offset(c.dx + r * 0.58 * math.cos(a), c.dy + r * 0.58 * math.sin(a));
      final bird = Path()
        ..moveTo(bc.dx - 9, bc.dy)
        ..quadraticBezierTo(bc.dx - 2, bc.dy - 9, bc.dx + 9, bc.dy - 2)
        ..quadraticBezierTo(bc.dx + 2, bc.dy + 1, bc.dx - 9, bc.dy);
      canvas.drawPath(bird, fill);
      canvas.drawPath(bird, line);
    }
  }

  // ───────────────────────────── Núi thuỷ mặc ─────────────────────────────
  void _paintMountains(Canvas canvas, Size size, math.Random rnd) {
    final w = size.width;
    // Hai dải núi dọc theo hai rìa, xen kẽ độ cao
    for (final side in [-1, 1]) {
      double y = 40 + (side == 1 ? 120 : 0);
      while (y < size.height) {
        final mw = 70 + rnd.nextDouble() * 60;
        final mh = 110 + rnd.nextDouble() * 90;
        final cx = side == -1
            ? -8 + rnd.nextDouble() * w * 0.06
            : w + 8 - rnd.nextDouble() * w * 0.06;
        _drawMountain(canvas, Offset(cx, y + mh), mw, mh, rnd);
        y += 190 + rnd.nextDouble() * 110;
      }
    }
  }

  /// Vẽ một ngọn núi: đáy tại [base], rộng [mw], cao [mh].
  void _drawMountain(Canvas canvas, Offset base, double mw, double mh, math.Random rnd) {
    final peakX = base.dx + (rnd.nextDouble() - 0.5) * mw * 0.25;
    final peak = Offset(peakX, base.dy - mh);
    final left = Offset(base.dx - mw, base.dy);
    final right = Offset(base.dx + mw, base.dy);

    // Đường sống núi gồ ghề
    Offset jag(Offset a, Offset b, double t, double amp) {
      final p = Offset.lerp(a, b, t)!;
      return p + Offset((rnd.nextDouble() - 0.5) * amp, (rnd.nextDouble() - 0.5) * amp);
    }

    final path = Path()..moveTo(left.dx, left.dy);
    for (int i = 1; i <= 4; i++) {
      final p = jag(left, peak, i / 5, mw * 0.16);
      path.lineTo(p.dx, p.dy);
    }
    path.lineTo(peak.dx, peak.dy);
    for (int i = 1; i <= 4; i++) {
      final p = jag(peak, right, i / 5, mw * 0.16);
      path.lineTo(p.dx, p.dy);
    }
    path.lineTo(right.dx, right.dy);
    path.close();

    // Mảng mực loãng
    canvas.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(
          peak,
          base,
          [
            _ink.withValues(alpha: 0.34),
            const Color(0xFF6E6555).withValues(alpha: 0.16),
            _paperMid.withValues(alpha: 0.0),
          ],
          const [0.0, 0.55, 1.0],
        ),
    );

    // Nét bút lông viền đỉnh
    canvas.drawPath(
      path,
      Paint()
        ..color = _ink.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.7
        ..strokeJoin = StrokeJoin.round,
    );

    // Nếp rạn đá (cun pháp) từ đỉnh xuống sườn
    final cun = Paint()
      ..color = _ink.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 9; i++) {
      final t = 0.15 + rnd.nextDouble() * 0.75;
      final sideLeft = rnd.nextBool();
      final start = Offset.lerp(peak, sideLeft ? left : right, t * 0.6)!;
      final len = mh * (0.18 + rnd.nextDouble() * 0.3);
      final sx = sideLeft ? -1.0 : 1.0;
      final p = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(
          start.dx + sx * len * 0.15,
          start.dy + len * 0.5,
          start.dx + sx * len * 0.35,
          start.dy + len,
        );
      canvas.drawPath(p, cun);
    }

    // Tuyết mờ / sương ở chân núi để tan vào giấy
    canvas.drawRect(
      Rect.fromLTRB(left.dx, base.dy - mh * 0.16, right.dx, base.dy + 6),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, base.dy - mh * 0.16),
          Offset(0, base.dy + 6),
          [_paperMid.withValues(alpha: 0.0), _paperMid.withValues(alpha: 0.85)],
        ),
    );
  }

  // ───────────────────────────── Dòng sông ─────────────────────────────
  void _paintRiver(Canvas canvas, Size size) {
    final path = Path();
    const step = 14.0;
    path.moveTo(antiqueRiverX(-step, size.width), -step);
    for (double y = 0; y <= size.height + step; y += step) {
      path.lineTo(antiqueRiverX(y, size.width), y);
    }

    // Bờ sông (viền mực)
    canvas.drawPath(
      path,
      Paint()
        ..color = _ink.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = kAntiqueRiverWidth + 5
        ..strokeJoin = StrokeJoin.round,
    );
    // Lòng sông lam ngọc
    canvas.drawPath(
      path,
      Paint()
        ..color = _riverBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = kAntiqueRiverWidth
        ..strokeJoin = StrokeJoin.round,
    );
    // Lớp sáng giữa dòng
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFA8D5DC).withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = kAntiqueRiverWidth * 0.4
        ..strokeJoin = StrokeJoin.round,
    );

    // Gợn sóng
    final ripple = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (double y = 30; y < size.height; y += 58) {
      final x = antiqueRiverX(y, size.width) + math.sin(y * 1.7) * 6;
      final p = Path()
        ..moveTo(x - 6, y)
        ..quadraticBezierTo(x - 3, y - 3, x, y)
        ..quadraticBezierTo(x + 3, y + 3, x + 6, y);
      canvas.drawPath(p, ripple);
    }
  }

  // ───────────────────────────── Tùng bách ─────────────────────────────
  void _paintTrees(Canvas canvas, Size size, math.Random rnd) {
    final w = size.width;
    for (double y = 60; y < size.height; y += 84) {
      final r = rnd.nextDouble();
      double x;
      if (r < 0.4) {
        x = w * (0.04 + rnd.nextDouble() * 0.10);
      } else if (r < 0.8) {
        x = w * (0.86 + rnd.nextDouble() * 0.10);
      } else {
        // ven bờ sông
        final side = rnd.nextBool() ? 1 : -1;
        x = antiqueRiverX(y, w) + side * (kAntiqueRiverWidth * 0.5 + 12 + rnd.nextDouble() * 10);
      }
      final s = 0.8 + rnd.nextDouble() * 0.5;
      _drawPine(canvas, Offset(x, y + rnd.nextDouble() * 30), s);
      if (rnd.nextDouble() < 0.5) {
        _drawPine(canvas, Offset(x + 14 * s, y + 10 + rnd.nextDouble() * 20), s * 0.75);
      }
    }
  }

  void _drawPine(Canvas canvas, Offset base, double s) {
    final trunk = Paint()
      ..color = const Color(0xFF4B3421)
      ..strokeWidth = 2.2 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(base, base + Offset(0, -10 * s), trunk);

    final fill = Paint()..color = _moss.withValues(alpha: 0.92);
    final edge = Paint()
      ..color = _ink.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    // 3 tầng tán lá
    for (int i = 0; i < 3; i++) {
      final top = base.dy - (10 + i * 9 + 14) * s;
      final bottom = base.dy - (10 + i * 9 - 2) * s;
      final half = (13 - i * 2.6) * s;
      final tri = Path()
        ..moveTo(base.dx, top)
        ..lineTo(base.dx + half, bottom)
        ..quadraticBezierTo(base.dx, bottom - 3 * s, base.dx - half, bottom)
        ..close();
      canvas.drawPath(tri, fill);
      canvas.drawPath(tri, edge);
    }
  }

  // ───────────────────────────── Mây tường vân ─────────────────────────────
  void _paintClouds(Canvas canvas, Size size, math.Random rnd) {
    final w = size.width;
    int i = 0;
    for (double y = 130; y < size.height; y += 330) {
      final left = i.isEven;
      final cx = left ? w * (0.10 + rnd.nextDouble() * 0.1) : w * (0.82 + rnd.nextDouble() * 0.1);
      _drawAuspiciousCloud(canvas, Offset(cx, y + rnd.nextDouble() * 60), 0.9 + rnd.nextDouble() * 0.5, !left);
      i++;
    }
  }

  /// Mây tường vân: khối mây tròn xoắn ốc, viền mực, ruột trắng ngà.
  void _drawAuspiciousCloud(Canvas canvas, Offset c, double s, bool flip) {
    final dir = flip ? -1.0 : 1.0;
    Path blob(Offset o, double r) => Path()..addOval(Rect.fromCircle(center: o, radius: r));

    var cloud = blob(c, 16 * s);
    cloud = Path.combine(PathOperation.union, cloud, blob(c + Offset(19 * s * dir, 4 * s), 12 * s));
    cloud = Path.combine(PathOperation.union, cloud, blob(c + Offset(-17 * s * dir, 6 * s), 11 * s));
    cloud = Path.combine(PathOperation.union, cloud, blob(c + Offset(33 * s * dir, 9 * s), 8 * s));
    cloud = Path.combine(
      PathOperation.union,
      cloud,
      Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: c + Offset(6 * s * dir, 14 * s), width: 74 * s, height: 14 * s),
        Radius.circular(7 * s),
      )),
    );

    canvas.drawPath(
      cloud.shift(Offset(0, 2 * s)),
      Paint()..color = _ink.withValues(alpha: 0.10),
    );
    canvas.drawPath(cloud, Paint()..color = const Color(0xFFF6EFDD).withValues(alpha: 0.86));
    canvas.drawPath(
      cloud,
      Paint()
        ..color = _ink.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );

    // Xoắn ốc tường vân
    final curl = Paint()
      ..color = _ink.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    final sp = Path();
    final o = c + Offset(-2 * s * dir, -1 * s);
    for (double t = 0; t <= 3.6 * math.pi; t += 0.3) {
      final r = 1.2 * s + t * 1.55 * s;
      final p = Offset(o.dx + dir * r * math.cos(t), o.dy + r * math.sin(t) * 0.7);
      if (t == 0) {
        sp.moveTo(p.dx, p.dy);
      } else {
        sp.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(sp, curl);
  }

  // ───────────────────────────── Vignette ố góc ─────────────────────────────
  void _paintVignette(Canvas canvas, Size size) {
    final edge = const Color(0xFF6B4A1C).withValues(alpha: 0.30);
    const clear = Color(0x00000000);
    final side = math.min(size.width * 0.14, 60.0);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, side, size.height),
      Paint()..shader = ui.Gradient.linear(Offset.zero, Offset(side, 0), [edge, clear]),
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width - side, 0, side, size.height),
      Paint()..shader = ui.Gradient.linear(Offset(size.width, 0), Offset(size.width - side, 0), [edge, clear]),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, 70),
      Paint()..shader = ui.Gradient.linear(Offset.zero, const Offset(0, 70), [edge, clear]),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - 90, size.width, 90),
      Paint()..shader = ui.Gradient.linear(Offset(0, size.height), Offset(0, size.height - 90), [edge, clear]),
    );
  }

  @override
  bool shouldRepaint(covariant AntiqueMapBackgroundPainter oldDelegate) => false;
}
