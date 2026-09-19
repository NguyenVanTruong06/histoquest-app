import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Painter vẽ Trục Dây Leo Thần Thoại (Beanstalk) di chuyển đồng bộ 100% theo mục cuộn lướt (Scroll Sync).
///
/// Lấy cảm hứng trực tiếp từ Cây Đậu Thần (Jack and the Beanstalk):
/// - Khi [isUnderneath] == true: Vẽ trục thân dây xoắn kép bện chặt, hạt đậu thần (magic beans),
///   lá lớn và đốm sao lấp lánh (sparkles) nằm phía sau các thẻ.
/// - Khi [isUnderneath] == false: Vẽ cành dây leo vươn ra uốn lượn ôm trọn góc đáy-trái và
///   các cành lá leo trùm lên mặt trước của thẻ, tạo hiệu ứng thị giác 3D quấn quanh thẻ thực thụ.
class BeanstalkContinuousScrollPainter extends CustomPainter {
  final double page;
  final int itemCount;
  final double pageHeight;
  final bool isUnderneath;

  BeanstalkContinuousScrollPainter({
    required this.page,
    required this.itemCount,
    required this.pageHeight,
    this.isUnderneath = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    const Color vineDark = Color(0xFF2E531C);
    const Color vineMid = Color(0xFF4C7B2F);
    const Color vineLight = Color(0xFF7CB24E);
    const Color leafHighlight = Color(0xFFA6E374);
    const Color beanColor = Color(0xFFF3EED9);
    const Color beanBorder = Color(0xFF98875A);

    final centerY = h / 2;
    final scrollOffset = page * pageHeight;

    if (isUnderneath) {
      // =====================================================================
      // LỚP 1: TRỤC THÂN CHÍNH DÂY LEO VÀ CÁC CHI TIẾT PHÍA SAU
      // =====================================================================

      // 1a. Trục dây xoắn đôi (Intertwined Braided Trunk)
      final path1 = Path();
      final path2 = Path();

      const double stepY = 14.0;
      final double startY = -120.0;
      final double endY = h + 120.0;
      final int numSteps = ((endY - startY) / stepY).ceil();

      for (int i = 0; i <= numSteps; i++) {
        final y = startY + i * stepY;
        final relativeY = y - centerY + scrollOffset;

        final wave1 = math.sin(relativeY * 2 * math.pi / pageHeight) * 26.0;
        final x1 = cx + wave1;

        final wave2 = -math.sin(relativeY * 2 * math.pi / pageHeight) * 20.0;
        final x2 = cx + wave2;

        if (i == 0) {
          path1.moveTo(x1, y);
          path2.moveTo(x2, y);
        } else {
          path1.lineTo(x1, y);
          path2.lineTo(x2, y);
        }
      }

      // Nét vẽ thân dây leo chính
      final vinePaint1Outer = Paint()
        ..color = vineDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final vinePaint1Inner = Paint()
        ..color = vineMid
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final vinePaint1Highlight = Paint()
        ..color = vineLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path1, vinePaint1Outer);
      canvas.drawPath(path1, vinePaint1Inner);
      canvas.drawPath(path1, vinePaint1Highlight);

      // Nét vẽ thân dây xoắn kép thứ 2 (bện chéo)
      final vinePaint2Outer = Paint()
        ..color = vineDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.5
        ..strokeCap = StrokeCap.round;

      final vinePaint2Inner = Paint()
        ..color = vineMid
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path2, vinePaint2Outer);
      canvas.drawPath(path2, vinePaint2Inner);

      // 1b. Vẽ hạt đậu thần, lá thân cây, tua cuốn và ngôi sao lấp lánh dọc trục
      for (int index = 0; index < itemCount; index++) {
        final cardCenterY = centerY + (index - page) * pageHeight;
        if (cardCenterY < -260 || cardCenterY > h + 260) continue;

        // Cuống gắn hạt đậu thần vào thân
        final beanStem1 = Path()
          ..moveTo(cx, cardCenterY - pageHeight * 0.38)
          ..quadraticBezierTo(
            cx - 10,
            cardCenterY - pageHeight * 0.38 - 8,
            cx - 20,
            cardCenterY - pageHeight * 0.38,
          );
        canvas.drawPath(
          beanStem1,
          Paint()
            ..color = vineDark
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0,
        );

        final beanStem2 = Path()
          ..moveTo(cx, cardCenterY + pageHeight * 0.38)
          ..quadraticBezierTo(
            cx + 10,
            cardCenterY + pageHeight * 0.38 - 8,
            cx + 20,
            cardCenterY + pageHeight * 0.38,
          );
        canvas.drawPath(
          beanStem2,
          Paint()
            ..color = vineDark
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0,
        );

        // Hạt đậu thần mọc dọc thân dây (ở khoảng giữa các thẻ)
        _drawMagicBean(
          canvas,
          Offset(cx - 22, cardCenterY - pageHeight * 0.38),
          beanColor,
          beanBorder,
          -0.35,
        );
        _drawMagicBean(
          canvas,
          Offset(cx + 22, cardCenterY + pageHeight * 0.38),
          beanColor,
          beanBorder,
          0.35,
        );

        // Các lá lớn tỏa ra hai bên trục dây leo
        _drawLeaf(
          canvas: canvas,
          origin: Offset(cx + 26, cardCenterY - pageHeight * 0.42),
          angle: 0.42,
          length: 42,
          color: vineMid,
          highlightColor: leafHighlight,
        );
        _drawLeaf(
          canvas: canvas,
          origin: Offset(cx - 28, cardCenterY - pageHeight * 0.32),
          angle: -0.48,
          length: 38,
          color: vineLight,
          highlightColor: leafHighlight,
        );
        _drawLeaf(
          canvas: canvas,
          origin: Offset(cx + 25, cardCenterY + pageHeight * 0.32),
          angle: 0.46,
          length: 40,
          color: vineMid,
          highlightColor: leafHighlight,
        );
        _drawLeaf(
          canvas: canvas,
          origin: Offset(cx - 26, cardCenterY + pageHeight * 0.42),
          angle: -0.42,
          length: 42,
          color: vineLight,
          highlightColor: leafHighlight,
        );

        // Tua cuốn (tendril) xoắn ốc
        _drawTendril(
          canvas,
          Offset(cx + 20, cardCenterY + pageHeight * 0.34),
          true,
          vineDark,
        );
        _drawTendril(
          canvas,
          Offset(cx - 20, cardCenterY - pageHeight * 0.34),
          false,
          vineDark,
        );

        // Đốm sao thần tiên (sparkles)
        _drawSparkle(canvas, Offset(cx - 55, cardCenterY - 60), 4.5, const Color(0xFFFDE68A));
        _drawSparkle(canvas, Offset(cx + 52, cardCenterY - 40), 5.0, const Color(0xFFA7F3D0));
        _drawSparkle(canvas, Offset(cx - 48, cardCenterY + 45), 4.0, const Color(0xFFBAE6FD));
        _drawSparkle(canvas, Offset(cx + 56, cardCenterY + 65), 4.5, const Color(0xFFFDE68A));
      }
    } else {
      // =====================================================================
      // LỚP 2: CÀNH LÁ DÂY LEO VƯƠN RA QUẤN QUANH THẺ (3D FOREGROUND WRAP)
      // =====================================================================
      for (int index = 0; index < itemCount; index++) {
        final cardCenterY = centerY + (index - page) * pageHeight;
        if (cardCenterY < -240 || cardCenterY > h + 240) continue;

        final delta = (page - index).abs().clamp(0.0, 1.0);
        final scale = (1.0 - delta * 0.24).clamp(0.72, 1.0);
        final isCenter = delta < 0.45;

        // Kích thước trực quan của thẻ trên màn hình
        final cardW = 295.0 * scale;
        final cardH = 215.0 * scale;
        final cardLeft = cx - cardW / 2;
        final cardBottom = cardCenterY + cardH / 2;

        // Cành chính xuất phát từ phía sau, uốn vòng ôm trọn góc bo đáy-trái và chạy dọc mép đáy thẻ
        final wrapPath = Path()
          ..moveTo(cx, cardCenterY - 15 * scale)
          ..cubicTo(
            cardLeft - 22 * scale,
            cardBottom - 45 * scale,
            cardLeft - 18 * scale,
            cardBottom - 6 * scale,
            cardLeft + 18 * scale,
            cardBottom + 5 * scale,
          )
          ..quadraticBezierTo(
            cardLeft + 50 * scale,
            cardBottom + 8 * scale,
            cardLeft + 85 * scale,
            cardBottom + 2 * scale,
          );

        final wrapPaintOuter = Paint()
          ..color = vineDark
          ..style = PaintingStyle.stroke
          ..strokeWidth = isCenter ? 6.2 : 4.2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        final wrapPaintInner = Paint()
          ..color = vineLight
          ..style = PaintingStyle.stroke
          ..strokeWidth = isCenter ? 3.5 : 2.4
          ..strokeCap = StrokeCap.round;

        canvas.drawPath(wrapPath, wrapPaintOuter);
        canvas.drawPath(wrapPath, wrapPaintInner);

        // Nhánh con bò leo dọc theo sườn trái của thẻ
        final sideBranchPath = Path()
          ..moveTo(cardLeft - 4 * scale, cardBottom - 20 * scale)
          ..cubicTo(
            cardLeft - 18 * scale,
            cardBottom - 50 * scale,
            cardLeft - 12 * scale,
            cardCenterY - 15 * scale,
            cardLeft - 2 * scale,
            cardCenterY - 45 * scale,
          );

        final sideBranchPaint = Paint()
          ..color = vineMid
          ..style = PaintingStyle.stroke
          ..strokeWidth = isCenter ? 4.0 : 2.8
          ..strokeCap = StrokeCap.round;

        canvas.drawPath(sideBranchPath, sideBranchPaint);

        // CÁC LÁ XANH LEO BÁM MẶT TRƯỚC VÀ VIỀN THẺ (Theo đúng ảnh mẫu)
        final leafScale = (isCenter ? 1.0 : 0.74) * scale;

        // 1. Lá leo góc trên mép trái
        _drawLeaf(
          canvas: canvas,
          origin: Offset(cardLeft - 6 * scale, cardCenterY - 40 * scale),
          angle: -0.78,
          length: 36 * leafScale,
          color: vineLight,
          highlightColor: leafHighlight,
        );

        // 2. Lá leo ngang sườn trái
        _drawLeaf(
          canvas: canvas,
          origin: Offset(cardLeft - 8 * scale, cardCenterY),
          angle: -0.28,
          length: 40 * leafScale,
          color: vineMid,
          highlightColor: leafHighlight,
        );

        // 3. Lá leo góc dưới sườn trái
        _drawLeaf(
          canvas: canvas,
          origin: Offset(cardLeft - 2 * scale, cardCenterY + 38 * scale),
          angle: 0.32,
          length: 34 * leafScale,
          color: vineLight,
          highlightColor: leafHighlight,
        );

        // 4. Lá nằm ở khúc cua góc bo đáy-trái
        _drawLeaf(
          canvas: canvas,
          origin: Offset(cardLeft + 14 * scale, cardBottom + 6 * scale),
          angle: 0.72,
          length: 34 * leafScale,
          color: vineMid,
          highlightColor: leafHighlight,
        );

        // 5. Lá vươn theo mép đáy sang bên phải
        _drawLeaf(
          canvas: canvas,
          origin: Offset(cardLeft + 42 * scale, cardBottom + 5 * scale),
          angle: 0.45,
          length: 30 * leafScale,
          color: vineLight,
          highlightColor: leafHighlight,
        );

        // 6. Lá ngọn mép đáy
        _drawLeaf(
          canvas: canvas,
          origin: Offset(cardLeft + 72 * scale, cardBottom + 2 * scale),
          angle: 0.18,
          length: 26 * leafScale,
          color: vineMid,
          highlightColor: leafHighlight,
        );

        // Tua cuốn tiền cảnh trườn nhẹ lên mặt thẻ
        _drawTendril(
          canvas,
          Offset(cardLeft + 6 * scale, cardCenterY - 15 * scale),
          false,
          vineDark,
        );
      }
    }
  }

  void _drawMagicBean(Canvas canvas, Offset p, Color color, Color border, double rotation) {
    final beanPaint = Paint()..color = color;
    final borderPaint = Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    canvas.save();
    canvas.translate(p.dx, p.dy);
    canvas.rotate(rotation);

    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-12, -7.5, 24, 15),
      const Radius.circular(7.5),
    );
    canvas.drawRRect(rrect, beanPaint);
    canvas.drawRRect(rrect, borderPaint);
    canvas.drawCircle(const Offset(-1.5, 0), 2.0, Paint()..color = border.withValues(alpha: 0.6));

    canvas.restore();
  }

  void _drawLeaf({
    required Canvas canvas,
    required Offset origin,
    required double angle,
    required double length,
    required Color color,
    required Color highlightColor,
  }) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.rotate(angle);

    final leafPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(length * 0.4, -length * 0.36, length, 0)
      ..quadraticBezierTo(length * 0.4, length * 0.36, 0, 0)
      ..close();

    canvas.drawPath(leafPath, Paint()..color = color);

    final veinPaint = Paint()
      ..color = highlightColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(length * 0.82, 0), veinPaint);

    canvas.restore();
  }

  void _drawTendril(Canvas canvas, Offset start, bool isLeft, Color color) {
    final tendrilPath = Path()..moveTo(start.dx, start.dy);
    final dir = isLeft ? -1.0 : 1.0;

    tendrilPath.cubicTo(
      start.dx + dir * 16,
      start.dy - 8,
      start.dx + dir * 26,
      start.dy + 8,
      start.dx + dir * 20,
      start.dy + 20,
    );

    final paint = Paint()
      ..color = color.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(tendrilPath, paint);
  }

  void _drawSparkle(Canvas canvas, Offset p, double radius, Color color) {
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawCircle(p, radius * 1.5, glowPaint);

    final sparklePaint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(p.dx - radius, p.dy), Offset(p.dx + radius, p.dy), sparklePaint);
    canvas.drawLine(Offset(p.dx, p.dy - radius), Offset(p.dx, p.dy + radius), sparklePaint);
    canvas.drawCircle(p, radius * 0.35, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant BeanstalkContinuousScrollPainter oldDelegate) =>
      oldDelegate.page != page ||
      oldDelegate.itemCount != itemCount ||
      oldDelegate.pageHeight != pageHeight ||
      oldDelegate.isUnderneath != isUnderneath;
}
