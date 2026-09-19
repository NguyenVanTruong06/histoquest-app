import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Painter vẽ Trục Dây Leo Cây Đậu Thần (Magic Beanstalk Pathway) nghệ thuật đỉnh cao.
///
/// Phong cách minh họa Game / Truyện cổ tích thần thoại (Illustrated Fantasy Beanstalk):
/// - Thân cây bện xoắn kép 3D với đổ bóng ambient occlusion, dải màu botanical đa lớp và highlight ánh mặt trời.
/// - Lá cây nghệ thuật hai nửa sáng-tối (two-tone shaded botanical leaves) kèm cuống lá uốn lượn và gân lá phát sáng.
/// - Quả / Hạt đậu thần phát sáng hào quang ma thuật (glowing magic beans with golden aura).
/// - Tua cuốn xoắn ốc (logarithmic spiral tendrils) vươn lượn tự nhiên trong không gian.
/// - Bụi phấn tiên và đốm sao lấp lánh (fairy dust & sparkle stars) bay lơ lửng quanh thân cây.
class BeanstalkPathwayPainter extends CustomPainter {
  final int itemCount;

  const BeanstalkPathwayPainter({
    this.itemCount = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // Bảng màu botanical thần thoại
    const Color trunkShadow = Color(0x22132A0B);
    const Color trunkDark = Color(0xFF1B3C0F);
    const Color trunkMid = Color(0xFF3B6F23);
    const Color trunkLight = Color(0xFF5E9E34);
    const Color trunkHighlight = Color(0xFF8FD553);
    const Color trunkGlint = Color(0xFFB6F27B);

    const Color leafDark = Color(0xFF265416);
    const Color leafMid = Color(0xFF457F26);
    const Color leafLight = Color(0xFF75BE3D);
    const Color leafHighlight = Color(0xFFA6E374);
    const Color leafVein = Color(0xFFB2F377);

    const Color beanGlow = Color(0x66FFE082);
    const Color beanBody = Color(0xFFFFF5D1);
    const Color beanShade = Color(0xFFE8D39E);
    const Color beanBorder = Color(0xFF917234);

    const double wavelength = 340.0;
    const double stepY = 12.0;
    final int numSteps = (h / stepY).ceil();

    // =========================================================================
    // 1. VẼ ĐỔ BÓNG TRỤC THÂN (Ambient Occlusion Shadow lên nền giấy ngà)
    // =========================================================================
    final shadowPath = Path();
    for (int i = 0; i <= numSteps; i++) {
      final y = i * stepY;
      final wave = math.sin(y * 2 * math.pi / wavelength) * 34.0;
      final x = cx + wave + 5.0; // Dạt nhẹ sang phải làm bóng nắng
      if (i == 0) {
        shadowPath.moveTo(x, y);
      } else {
        shadowPath.lineTo(x, y);
      }
    }
    final shadowPaint = Paint()
      ..color = trunkShadow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawPath(shadowPath, shadowPaint);

    // =========================================================================
    // 2. VẼ THÂN CÂY CHÍNH (Thân xoắn đại thụ uốn lượn mềm mại)
    // =========================================================================
    final trunkPath = Path();
    for (int i = 0; i <= numSteps; i++) {
      final y = i * stepY;
      final wave = math.sin(y * 2 * math.pi / wavelength) * 34.0;
      final x = cx + wave;
      if (i == 0) {
        trunkPath.moveTo(x, y);
      } else {
        trunkPath.lineTo(x, y);
      }
    }

    // Lớp 1: Lõi vỏ sẫm màu
    canvas.drawPath(
      trunkPath,
      Paint()
        ..color = trunkDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Lớp 2: Thịt thân xanh lục botanical
    canvas.drawPath(
      trunkPath,
      Paint()
        ..color = trunkMid
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Lớp 3: Dải sáng mặt thân
    canvas.drawPath(
      trunkPath,
      Paint()
        ..color = trunkHighlight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Lớp 4: Đường gân sợi nắng lấp lánh (Sunlit Rim Highlight)
    final highlightPath = Path();
    for (int i = 0; i <= numSteps; i++) {
      final y = i * stepY;
      final wave = math.sin(y * 2 * math.pi / wavelength) * 34.0;
      // Uốn lệch nhẹ theo hướng đón sáng
      final x = cx + wave - 3.5;
      if (i == 0) {
        highlightPath.moveTo(x, y);
      } else {
        highlightPath.lineTo(x, y);
      }
    }
    canvas.drawPath(
      highlightPath,
      Paint()
        ..color = trunkGlint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );

    // =========================================================================
    // 3. VẼ DÂY XOẮN PHỤ BỆN CHÉO 3D (Intertwined Helix Vine)
    // =========================================================================
    // Dây leo thứ 2 quấn xoắn quanh thân chính ngược pha tạo hiệu ứng bện thừng
    final helixPath = Path();
    for (int i = 0; i <= numSteps; i++) {
      final y = i * stepY;
      // Tần số xoắn nhanh gấp đôi thân chính
      final helixWave = math.cos(y * 4 * math.pi / wavelength) * 22.0;
      final mainWave = math.sin(y * 2 * math.pi / wavelength) * 34.0;
      final x = cx + mainWave + helixWave;
      if (i == 0) {
        helixPath.moveTo(x, y);
      } else {
        helixPath.lineTo(x, y);
      }
    }

    // Đổ bóng của dây phụ lên thân
    canvas.drawPath(
      helixPath,
      Paint()
        ..color = trunkDark.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9.0
        ..strokeCap = StrokeCap.round,
    );
    // Thân dây phụ
    canvas.drawPath(
      helixPath,
      Paint()
        ..color = trunkLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round,
    );
    // Viền sáng dây phụ
    canvas.drawPath(
      helixPath,
      Paint()
        ..color = trunkGlint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // =========================================================================
    // 4. VẼ CÁC CỤM CÀNH LÁ NGHỆ THUẬT, HẠT ĐẬU VÀ TUA CUỐN DỌC THEO DANH SÁCH
    // =========================================================================
    final double segmentHeight = h / (itemCount > 0 ? itemCount : 4);

    for (int i = 0; i < itemCount; i++) {
      final cy = segmentHeight * (i + 0.5);
      final trunkXAtCy = cx + math.sin(cy * 2 * math.pi / wavelength) * 34.0;

      // Hướng so le của các nhánh lớn: thẻ lẻ / chẵn
      final isEven = (i % 2 == 0);
      final branchDir = isEven ? -1.0 : 1.0;

      // 4a. CÀNH NHÁNH VƯƠN DÀI VỀ PHÍA THẺ THỜI KỲ (Cradling Branch)
      _drawArtisticBranch(
        canvas: canvas,
        start: Offset(trunkXAtCy, cy),
        end: Offset(trunkXAtCy + branchDir * 110.0, cy + 30.0),
        color: trunkMid,
        highlightColor: trunkGlint,
      );

      // 4b. CỤM LÁ NGHỆ THUẬT HAI MẶT (Two-toned Illustrated Leaves)
      // Lá lớn ở đầu cành vươn ra
      _drawArtisticLeaf(
        canvas: canvas,
        origin: Offset(trunkXAtCy + branchDir * 95.0, cy + 28.0),
        angle: isEven ? -0.45 : 0.45,
        length: 50.0,
        darkColor: leafDark,
        lightColor: leafLight,
        veinColor: leafVein,
      );

      // Lá nhỏ chồi non ở nách cành
      _drawArtisticLeaf(
        canvas: canvas,
        origin: Offset(trunkXAtCy + branchDir * 60.0, cy + 14.0),
        angle: isEven ? 0.35 : -0.35,
        length: 36.0,
        darkColor: leafMid,
        lightColor: leafHighlight,
        veinColor: leafVein,
      );

      // Lá đối xứng vươn sang sườn bên kia của thân cây
      _drawArtisticLeaf(
        canvas: canvas,
        origin: Offset(trunkXAtCy - branchDir * 28.0, cy - 45.0),
        angle: isEven ? 0.65 : -0.65,
        length: 46.0,
        darkColor: leafDark,
        lightColor: leafLight,
        veinColor: leafVein,
      );

      // Lá trên cao ở khoảng trống giữa các tầng
      _drawArtisticLeaf(
        canvas: canvas,
        origin: Offset(trunkXAtCy + branchDir * 24.0, cy - 85.0),
        angle: isEven ? -0.55 : 0.55,
        length: 44.0,
        darkColor: leafMid,
        lightColor: leafHighlight,
        veinColor: leafVein,
      );

      // 4c. HẠT ĐẬU THẦN PHÁT SÁNG HÀO QUANG (Glowing Magic Beans)
      // Treo ở khoảng giữa 2 thời kỳ
      final beanY = cy - segmentHeight * 0.42;
      final beanX = cx + math.sin(beanY * 2 * math.pi / wavelength) * 34.0 + (isEven ? 36.0 : -36.0);

      _drawGlowingMagicBean(
        canvas: canvas,
        anchor: Offset(
          cx + math.sin(beanY * 2 * math.pi / wavelength) * 34.0,
          beanY - 14.0,
        ),
        position: Offset(beanX, beanY),
        bodyColor: beanBody,
        shadeColor: beanShade,
        borderColor: beanBorder,
        glowColor: beanGlow,
        stemColor: trunkMid,
        rotation: isEven ? 0.45 : -0.45,
      );

      // 4d. TUA CUỐN XOẮN ỐC NGHỆ THUẬT (Graceful Spiral Tendrils)
      _drawCurlingTendril(
        canvas: canvas,
        start: Offset(trunkXAtCy + branchDir * 40.0, cy + 50.0),
        isLeft: !isEven,
        size: 32.0,
        color: trunkLight,
      );
      _drawCurlingTendril(
        canvas: canvas,
        start: Offset(trunkXAtCy - branchDir * 22.0, cy - 65.0),
        isLeft: isEven,
        size: 26.0,
        color: trunkMid,
      );

      // 4e. BỤI TIÊN VÀ ĐỐM SAO MA THUẬT (Fairy Spores & Sparkles)
      _drawFairyDust(canvas, Offset(trunkXAtCy - 55.0, cy - 35.0), 5.5, const Color(0xFFFDE68A));
      _drawFairyDust(canvas, Offset(trunkXAtCy + 60.0, cy - 15.0), 6.5, const Color(0xFFA7F3D0));
      _drawFairyDust(canvas, Offset(trunkXAtCy - 40.0, cy + 60.0), 4.5, const Color(0xFFBAE6FD));
      _drawFairyDust(canvas, Offset(trunkXAtCy + 50.0, cy + 75.0), 5.0, const Color(0xFFFDE68A));
    }
  }

  /// Vẽ cành nhánh uốn cong tự nhiên vươn từ thân chính
  void _drawArtisticBranch({
    required Canvas canvas,
    required Offset start,
    required Offset end,
    required Color color,
    required Color highlightColor,
  }) {
    final branchPath = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        start.dx + (end.dx - start.dx) * 0.4,
        start.dy - 12.0,
        start.dx + (end.dx - start.dx) * 0.7,
        end.dy + 8.0,
        end.dx,
        end.dy,
      );

    canvas.drawPath(
      branchPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawPath(
      branchPath,
      Paint()
        ..color = highlightColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Vẽ lá cây nghệ thuật hai nửa sáng-tối (Two-tone botanical leaf)
  void _drawArtisticLeaf({
    required Canvas canvas,
    required Offset origin,
    required double angle,
    required double length,
    required Color darkColor,
    required Color lightColor,
    required Color veinColor,
  }) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.rotate(angle);

    final w = length * 0.38;

    // Nửa lá bên trái (mảng tối có chiều sâu)
    final leftHalf = Path()
      ..moveTo(0, 0)
      ..cubicTo(length * 0.3, -w * 1.1, length * 0.75, -w * 0.85, length, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(leftHalf, Paint()..color = darkColor);

    // Nửa lá bên phải (mảng sáng đón nắng)
    final rightHalf = Path()
      ..moveTo(0, 0)
      ..cubicTo(length * 0.3, w * 1.1, length * 0.75, w * 0.85, length, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(rightHalf, Paint()..color = lightColor);

    // Sống lá chính (gân giữa sáng nổi bật)
    final mainVein = Paint()
      ..color = veinColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(length * 0.88, 0), mainVein);

    // Các gân phụ mảnh vươn sang hai bên
    final subVein = Paint()
      ..color = veinColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(length * 0.3, 0), Offset(length * 0.45, -w * 0.45), subVein);
    canvas.drawLine(Offset(length * 0.3, 0), Offset(length * 0.45, w * 0.45), subVein);
    canvas.drawLine(Offset(length * 0.55, 0), Offset(length * 0.7, -w * 0.35), subVein);
    canvas.drawLine(Offset(length * 0.55, 0), Offset(length * 0.7, w * 0.35), subVein);

    canvas.restore();
  }

  /// Vẽ hạt đậu thần phát sáng hào quang ma thuật (Glowing Magic Bean)
  void _drawGlowingMagicBean({
    required Canvas canvas,
    required Offset anchor,
    required Offset position,
    required Color bodyColor,
    required Color shadeColor,
    required Color borderColor,
    required Color glowColor,
    required Color stemColor,
    required double rotation,
  }) {
    // Cuống treo hạt đậu từ thân
    final stemPath = Path()
      ..moveTo(anchor.dx, anchor.dy)
      ..quadraticBezierTo(
        (anchor.dx + position.dx) / 2 + (rotation > 0 ? 10.0 : -10.0),
        anchor.dy + 8.0,
        position.dx,
        position.dy - 6.0,
      );

    canvas.drawPath(
      stemPath,
      Paint()
        ..color = stemColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    // Hào quang vàng ấm áp tỏa quanh hạt đậu
    final auraPaint = Paint()
      ..color = glowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);
    canvas.drawCircle(position, 18.0, auraPaint);

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotation);

    // Dáng hạt đậu quả thận (kidney shape)
    final beanPath = Path()
      ..moveTo(-14, 0)
      ..cubicTo(-14, -9, -3, -11, 4, -9)
      ..cubicTo(12, -7, 15, -2, 15, 3)
      ..cubicTo(15, 9, 7, 12, -1, 10)
      ..cubicTo(-7, 8, -8, 2, -14, 0)
      ..close();

    // Bóng khối đáy hạt
    canvas.drawPath(beanPath, Paint()..color = shadeColor);

    // Lưng trên sáng bóng của hạt đậu
    final highlightPath = Path()
      ..moveTo(-12, -2)
      ..cubicTo(-12, -7, -2, -9, 3, -7)
      ..cubicTo(10, -5, 12, -1, 12, 2)
      ..cubicTo(8, 0, 0, -2, -12, -2)
      ..close();
    canvas.drawPath(highlightPath, Paint()..color = bodyColor);

    // Viền sắc sảo của hạt
    canvas.drawPath(
      beanPath,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    // Đốm sáng phản quang (specular glint)
    canvas.drawCircle(const Offset(-4, -4), 1.8, Paint()..color = Colors.white);

    canvas.restore();
  }

  /// Vẽ tua cuốn xoắn ốc (Logarithmic Archimedean Spiral Tendril)
  void _drawCurlingTendril({
    required Canvas canvas,
    required Offset start,
    required bool isLeft,
    required double size,
    required Color color,
  }) {
    final dir = isLeft ? -1.0 : 1.0;
    final path = Path()..moveTo(start.dx, start.dy);

    // Uốn lượn 2 nhịp xoắn ốc
    path.cubicTo(
      start.dx + dir * size * 0.4,
      start.dy - size * 0.25,
      start.dx + dir * size * 0.8,
      start.dy - size * 0.1,
      start.dx + dir * size * 0.9,
      start.dy + size * 0.35,
    );
    path.cubicTo(
      start.dx + dir * size * 0.95,
      start.dy + size * 0.7,
      start.dx + dir * size * 0.6,
      start.dy + size * 0.85,
      start.dx + dir * size * 0.45,
      start.dy + size * 0.65,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Vẽ bụi phấn tiên và ngôi sao lấp lánh (Fairy Dust & Stars)
  void _drawFairyDust(Canvas canvas, Offset p, double radius, Color color) {
    // Vầng hào quang mờ
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);
    canvas.drawCircle(p, radius * 1.6, glowPaint);

    // Ngôi sao 4 cánh sắc nhọn (Diamond Fairy Star)
    final starPath = Path()
      ..moveTo(p.dx, p.dy - radius * 1.5)
      ..quadraticBezierTo(p.dx, p.dy, p.dx + radius * 1.5, p.dy)
      ..quadraticBezierTo(p.dx, p.dy, p.dx, p.dy + radius * 1.5)
      ..quadraticBezierTo(p.dx, p.dy, p.dx - radius * 1.5, p.dy)
      ..quadraticBezierTo(p.dx, p.dy, p.dx, p.dy - radius * 1.5)
      ..close();

    canvas.drawPath(starPath, Paint()..color = color);
    // Nhụy sáng trắng tinh khôi ở tâm
    canvas.drawCircle(p, radius * 0.35, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant BeanstalkPathwayPainter oldDelegate) =>
      oldDelegate.itemCount != itemCount;
}
