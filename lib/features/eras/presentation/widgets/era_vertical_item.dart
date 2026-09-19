import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/country_model.dart';
import '../../../../data/models/era_model.dart';
import '../../../../data/mock_data.dart';

/// Một item trong PageView dọc chọn thời kỳ (Bước 2 của tab Bản đồ).
///
/// Thiết kế "storybook": mỗi thời kỳ là một Era Card bo góc lớn, tỉ lệ 3:2,
/// nằm trên một trục dây leo (vine) pastel xoắn 3 sợi chạy xuyên suốt danh
/// sách. Thẻ đang chọn (isCenter) to hơn, có viền gradient phát sáng +
/// ngôi sao lấp lánh + ribbon "ĐANG CHỌN"; các thẻ khác nhỏ hơn, trầm màu
/// hơn để tạo chiều sâu. Thời kỳ chưa mở khóa luôn hiển thị mờ + khoá,
/// bất kể đang ở vị trí trung tâm hay không.
///
/// Hiệu ứng scale/opacity/blur theo khoảng cách tới trang trung tâm được
/// điều khiển từ bên ngoài (`ErasScreen`) thông qua `AnimatedBuilder` bọc
/// widget này — widget này chỉ chịu trách nhiệm cho 2 kích cỡ "center" và
/// "không center".
class EraVerticalItem extends StatelessWidget {
  final EraModel era;
  final bool isCenter;
  final VoidCallback onTap;
  final VoidCallback onLockedTap;

  const EraVerticalItem({
    super.key,
    required this.era,
    required this.isCenter,
    required this.onTap,
    required this.onLockedTap,
  });

  /// Màu chủ đạo của nền văn minh mà thời kỳ này thuộc về — dùng để tô
  /// điểm minh hoạ trên thẻ. Rơi về `AppColors.primary` nếu không tìm
  /// thấy (không nên xảy ra với dữ liệu hợp lệ).
  Color get _accent {
    for (final CountryModel c in MockData.countries) {
      if (c.id == era.countryId) return c.accentColor;
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final isUnlocked = era.isUnlocked;
    final active = isUnlocked && isCenter;

    final cardW = isCenter ? 232.0 : 180.0;
    final cardH = cardW * 2 / 3;

    return GestureDetector(
      onTap: isUnlocked ? onTap : onLockedTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 210,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Lớp thân bện chạy LIÊN TỤC phía sau thẻ.
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _VineConnectorPainter(active: isUnlocked),
                ),
              ),
            ),
            _buildCard(cardW, cardH, isUnlocked, active),
            // Lớp tua nổi ôm khung thẻ mà không đè lên chữ.
            if (active)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _VineFramePainter(
                      active: active,
                      cardWidth: cardW + 8,
                      cardHeight: cardH + 8,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(double w, double h, bool isUnlocked, bool active) {
    final radius = isCenter ? 26.0 : 20.0;
    final accent = _accent;

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: w,
        height: h,
        color: isUnlocked ? Colors.white : AppColors.lockedCardBg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: _buildIllustration(isUnlocked, accent),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isCenter ? 14 : 10,
                  vertical: isCenter ? 8 : 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      era.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.baloo2(
                        fontWeight: FontWeight.w700,
                        fontSize: isCenter ? 16 : 13,
                        color: isUnlocked ? AppColors.textPrimary : AppColors.lockedTitle,
                      ),
                    ),
                    SizedBox(height: isCenter ? 3 : 2),
                    Text(
                      era.timelineSpan,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isCenter ? 11.5 : 10,
                        fontWeight: FontWeight.w600,
                        color: isUnlocked ? AppColors.textSecondary : AppColors.lockedSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (!active) {
      // Thời kỳ thường / đang khoá: viền mảnh, không phát sáng.
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isUnlocked ? AppColors.cardBorder : AppColors.lockedCardBorder,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D2B2B).withValues(alpha: 0.08),
              offset: const Offset(0, 6),
              blurRadius: 14,
            ),
          ],
        ),
        child: card,
      );
    }

    // Thời kỳ đang chọn + đã mở khoá: viền gradient phát sáng + sao lấp lánh
    // + ribbon "ĐANG CHỌN".
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius + 4),
            gradient: LinearGradient(
              colors: AppColors.glowGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.28),
                offset: const Offset(0, 10),
                blurRadius: 22,
              ),
              const BoxShadow(
                color: Color(0x8CFFFFFF),
                spreadRadius: 4,
              ),
            ],
          ),
          child: card,
        ),
        Positioned(top: -10, left: -6, child: _sparkle(16, AppColors.sparkleGold)),
        Positioned(bottom: -8, right: 18, child: _sparkle(12, AppColors.sparkleBlue)),
        Positioned(top: 30, right: -10, child: _sparkle(10, AppColors.sparklePink)),
        Positioned(
          top: -12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(99),
              boxShadow: const [
                BoxShadow(color: Color(0x333A2A1A), offset: Offset(0, 3), blurRadius: 6),
              ],
            ),
            child: Text(
              '★ ĐANG CHỌN',
              style: GoogleFonts.baloo2(
                fontWeight: FontWeight.w700,
                fontSize: 10.5,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration(bool isUnlocked, Color accent) {
    final top = isUnlocked ? accent.withValues(alpha: 0.55) : Colors.grey.shade400;
    final bottom = isUnlocked ? accent : Colors.grey.shade500;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [top, bottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _MonumentDoodlePainter(muted: !isUnlocked),
          ),
          if (!isUnlocked)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.lock_rounded, size: 12, color: AppColors.lockedSubtitle),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sparkle(double size, Color color) {
    return CustomPaint(size: Size(size, size), painter: _StarSparklePainter(color: color));
  }
}

/// Vẽ một cụm "công trình cổ" cách điệu đơn giản (bậc thang + mái) làm
/// minh hoạ chung cho mọi thời kỳ — phong cách vector phẳng, không chi
/// tiết thực tế, phù hợp trẻ em.
class _MonumentDoodlePainter extends CustomPainter {
  final bool muted;
  _MonumentDoodlePainter({required this.muted});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final base = Paint()
      ..color = Colors.white.withValues(alpha: muted ? 0.18 : 0.35)
      ..style = PaintingStyle.fill;

    Path tri(double cx, double topY) {
      return Path()
        ..moveTo(cx - w * 0.16, h)
        ..lineTo(cx, topY)
        ..lineTo(cx + w * 0.16, h)
        ..close();
    }

    canvas.drawPath(tri(w * 0.32, h * 0.35), base);
    canvas.drawPath(tri(w * 0.55, h * 0.15), base..color = Colors.white.withValues(alpha: muted ? 0.24 : 0.45));
    canvas.drawPath(tri(w * 0.76, h * 0.42), base..color = Colors.white.withValues(alpha: muted ? 0.18 : 0.35));

    final sunPaint = Paint()..color = Colors.white.withValues(alpha: muted ? 0.2 : 0.55);
    canvas.drawCircle(Offset(w * 0.86, h * 0.2), w * 0.07, sunPaint);
  }

  @override
  bool shouldRepaint(covariant _MonumentDoodlePainter oldDelegate) => oldDelegate.muted != muted;
}

class _StarSparklePainter extends CustomPainter {
  final Color color;
  _StarSparklePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    final path = Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx + r * 0.28, cy - r * 0.28)
      ..lineTo(cx + r, cy)
      ..lineTo(cx + r * 0.28, cy + r * 0.28)
      ..lineTo(cx, cy + r)
      ..lineTo(cx - r * 0.28, cy + r * 0.28)
      ..lineTo(cx - r, cy)
      ..lineTo(cx - r * 0.28, cy - r * 0.28)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StarSparklePainter oldDelegate) => oldDelegate.color != color;
}

/// Dây leo được vẽ thuần Canvas, không cần asset ảnh.
/// Hai đầu của mỗi item sử dụng cùng một chu kỳ đường cong (210 px), nên
/// khi các item đứng sát nhau trong danh sách, thân dây tiếp nối tự nhiên.
class _VineConnectorPainter extends CustomPainter {
  final bool active;
  const _VineConnectorPainter({required this.active});

  static const _dark = Color(0xFF285B36);
  static const _mid = Color(0xFF4D9650);
  static const _light = Color(0xFF8ACA70);
  static const _highlight = Color(0xFFC5E6A0);
  static const _gold = Color(0xFFF5C768);
  static const _pink = Color(0xFFEF96B9);
  static const _blue = Color(0xFF8FBDD9);
  static const _orange = Color(0xFFF5AF73);

  static double _stemX(double cx, double y) =>
      cx + math.sin(y * math.pi / 120) * 2.8;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    if (!active) {
      canvas.drawLine(
        Offset(cx, 0),
        Offset(cx, size.height),
        Paint()
          ..color = const Color(0xFFD8D2C4)
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
      return;
    }

    // Không còn đắp một "thân chính" quá dày ở giữa vì nó làm 3 sợi
    // nhìn như dính lại thành một cục. Thay vào đó, vẽ 3 sợi độc lập, có
    // khoảng cách rõ ràng hơn nhưng vẫn cùng uốn nhịp để giữ cảm giác dây leo.
    const strandOffsets = [-10.0, 0.0, 10.0];
    for (var band = 0; band < 3; band++) {
      final phase = band * 2 * math.pi / 3;
      final offset = strandOffsets[band];
      final strand = _curve(
        (y) =>
            _stemX(cx, y) +
            offset +
            math.sin(y * 2 * math.pi / 112 + phase) * 3.6,
        -3,
        size.height + 3,
      );

      // Bóng đổ nhẹ riêng cho từng sợi để tăng tách lớp.
      final shadow = _curve(
        (y) =>
            _stemX(cx, y) +
            offset +
            1.8 +
            math.sin(y * 2 * math.pi / 112 + phase) * 3.6,
        -3,
        size.height + 3,
      );
      _stroke(canvas, shadow, Colors.black.withValues(alpha: 0.07), 8.2);
      _stroke(canvas, strand, _dark.withValues(alpha: 0.82), 6.4);
      _stroke(canvas, strand, band == 1 ? _light : _mid, 4.4);
      _stroke(canvas, strand, _highlight.withValues(alpha: 0.56), 1.1);
    }

    // Cụm lá, tua cuốn và hạt đậu phát sáng, phân bố tương đối thưa để
    // tránh che nội dung card. Phần phía sau card được card che tự nhiên.
    _leaf(canvas, Offset(_stemX(cx, 24) - 12, 24), side: -1, length: 27, tilt: -0.10);
    _leaf(canvas, Offset(_stemX(cx, 58) + 12, 58), side: 1, length: 30, tilt: 0.14);
    _leaf(canvas, Offset(_stemX(cx, 96) - 10, 96), side: -1, length: 26, tilt: 0.08);
    _leaf(canvas, Offset(_stemX(cx, 148) + 10, 148), side: 1, length: 29, tilt: -0.10);
    _leaf(canvas, Offset(_stemX(cx, 188) - 12, 188), side: -1, length: 27, tilt: 0.12);

    _tendril(canvas, Offset(cx - 16, 38), side: -1, scale: 0.62);
    _tendril(canvas, Offset(cx + 16, 181), side: 1, scale: 0.65);

    _bean(canvas, Offset(cx - 36, 34), _light, angle: 0.35);
    _bean(canvas, Offset(cx + 36, 76), _blue, angle: -0.20);
    _bean(canvas, Offset(cx - 38, 176), _orange, angle: -0.32);

    _spark(canvas, Offset(cx - 44, 60), 6, _gold);
    _spark(canvas, Offset(cx + 44, 30), 5, _pink);
    _spark(canvas, Offset(cx + 42, 170), 6, _gold);
    _dots(canvas, cx, size.height);
  }

  static Path _curve(double Function(double) xAt, double start, double end) {
    final p = Path()..moveTo(xAt(start), start);
    for (var y = start + 2.0; y < end; y += 2) {
      p.lineTo(xAt(y), y);
    }
    p.lineTo(xAt(end), end);
    return p;
  }

  static void _stroke(Canvas canvas, Path path, Color color, double width) {
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true,
    );
  }

  static void _leaf(
    Canvas canvas,
    Offset root, {
    required int side,
    double length = 31,
    double tilt = 0,
  }) {
    canvas.save();
    canvas.translate(root.dx, root.dy);
    canvas.scale(side.toDouble(), 1);
    canvas.rotate(tilt);
    // Gốc lá ở thân, đầu lá hướng ra ngoài và hơi ngóc lên.
    final shape = Path()
      ..moveTo(0, 0)
      ..cubicTo(length * .25, -length * .49, length * .70, -length * .42,
          length, -length * .58)
      ..cubicTo(length * .89, -length * .08, length * .44, length * .18, 0, 0)
      ..close();
    final bounds = Rect.fromLTWH(0, -length * .65, length, length);
    canvas.drawPath(
      shape,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA7D884), Color(0xFF4D9950), Color(0xFF347344)],
          stops: [0, .55, 1],
        ).createShader(bounds),
    );
    _stroke(canvas, shape, _dark, 1.5);
    final vein = Path()
      ..moveTo(1, -1)
      ..quadraticBezierTo(length * .55, -length * .20, length * .93, -length * .53);
    _stroke(canvas, vein, _dark.withValues(alpha: .65), 1.0);
    _stroke(
      canvas,
      Path()
        ..moveTo(length * .35, -length * .11)
        ..lineTo(length * .44, -length * .31),
      _dark.withValues(alpha: .35),
      .8,
    );
    canvas.restore();
  }

  static void _tendril(Canvas canvas, Offset start,
      {required int side, double scale = 1}) {
    canvas.save();
    canvas.translate(start.dx, start.dy);
    canvas.scale(side.toDouble() * scale, scale);
    final curl = Path()
      ..moveTo(0, 0)
      ..cubicTo(13, -8, 27, -13, 30, -26)
      ..cubicTo(34, -42, 14, -47, 10, -32)
      ..cubicTo(6, -19, 23, -18, 21, -28);
    _stroke(canvas, curl, _dark, 4.8);
    _stroke(canvas, curl, _light, 2.8);
    canvas.restore();
  }

  static void _bean(Canvas canvas, Offset center, Color color,
      {double angle = 0}) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final bean = Path()
      ..moveTo(0, -9)
      ..cubicTo(9, -12, 12, -4, 10, 3)
      ..cubicTo(8, 12, -6, 12, -9, 5)
      ..cubicTo(-13, -3, -7, -8, 0, -9)
      ..close();
    canvas.drawPath(
      bean,
      Paint()
        ..color = color.withValues(alpha: .4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );
    canvas.drawPath(bean, Paint()..color = color);
    _stroke(canvas, bean, _dark.withValues(alpha: .55), 1.3);
    canvas.drawOval(
      const Rect.fromLTWH(-5, -7, 4, 6),
      Paint()..color = Colors.white.withValues(alpha: .75),
    );
    canvas.restore();
  }

  static void _spark(Canvas canvas, Offset c, double r, Color color) {
    final p = Path()
      ..moveTo(c.dx, c.dy - r)
      ..quadraticBezierTo(c.dx + r * .2, c.dy - r * .2, c.dx + r, c.dy)
      ..quadraticBezierTo(c.dx + r * .2, c.dy + r * .2, c.dx, c.dy + r)
      ..quadraticBezierTo(c.dx - r * .2, c.dy + r * .2, c.dx - r, c.dy)
      ..quadraticBezierTo(c.dx - r * .2, c.dy - r * .2, c.dx, c.dy - r)
      ..close();
    canvas.drawPath(p, Paint()..color = color);
  }

  static void _dots(Canvas canvas, double cx, double height) {
    const colors = [_gold, _pink, _blue, _light];
    for (var i = 0; i < 10; i++) {
      final y = (i * 47.0 + 13) % height;
      final side = i.isEven ? -1.0 : 1.0;
      final x = cx + side * (36 + i % 3 * 10);
      canvas.drawCircle(
        Offset(x, y),
        i % 4 == 0 ? 2.0 : 1.3,
        Paint()..color = colors[i % colors.length].withValues(alpha: .8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VineConnectorPainter oldDelegate) =>
      oldDelegate.active != active;
}

/// Nhánh nổi nằm TRÊN card, chỉ ôm sát viền, không đè lên tiêu đề/nội dung.
/// Kích thước card phải khớp với _buildCard (cardW + 8 và cardH + 8 khi active).
class _VineFramePainter extends CustomPainter {
  final bool active;
  final double cardWidth;
  final double cardHeight;

  const _VineFramePainter({
    required this.active,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!active) return;
    final cx = size.width / 2;
    final left = cx - cardWidth / 2;
    final right = cx + cardWidth / 2;
    final top = (size.height - cardHeight) / 2;
    final bottom = top + cardHeight;

    // Tua phía trên: đi từ thân ra phía mép PHẢI của card.
    final upper = Path()
      ..moveTo(cx - 2, top - 10)
      ..cubicTo(cx + 14, top - 18, cx + 42, top - 10, cx + 64, top - 7)
      ..cubicTo(right + 4, top - 6, right + 8, top + 5, right - 1, top + 20);
    _VineConnectorPainter._stroke(canvas, upper, _VineConnectorPainter._dark, 5.8);
    _VineConnectorPainter._stroke(canvas, upper, _VineConnectorPainter._mid, 4.0);
    _VineConnectorPainter._stroke(canvas, upper, _VineConnectorPainter._highlight, 1.1);
    _VineConnectorPainter._leaf(
      canvas, Offset(right - 1, top + 19), side: 1, length: 21, tilt: .24,
    );
    _VineConnectorPainter._tendril(
      canvas, Offset(right + 3, top + 8), side: 1, scale: .40,
    );

    // Tua phía dưới: vòng qua mép TRÁI, rồi trở về thân chính.
    final lower = Path()
      ..moveTo(cx + 4, bottom + 11)
      ..cubicTo(cx - 24, bottom + 18, left + 24, bottom + 18, left + 7, bottom - 2)
      ..cubicTo(left - 9, bottom - 22, left - 5, bottom - 39, left + 8, bottom - 44);
    _VineConnectorPainter._stroke(canvas, lower, _VineConnectorPainter._dark, 5.6);
    _VineConnectorPainter._stroke(canvas, lower, _VineConnectorPainter._mid, 3.9);
    _VineConnectorPainter._stroke(canvas, lower, _VineConnectorPainter._highlight, 1.0);
    _VineConnectorPainter._leaf(
      canvas, Offset(left + 5, bottom - 38), side: -1, length: 20, tilt: -.28,
    );
    _VineConnectorPainter._leaf(
      canvas, Offset(left + 46, bottom + 10), side: 1, length: 20, tilt: -.16,
    );

    _VineConnectorPainter._bean(
      canvas, Offset(right + 16, top + 30), _VineConnectorPainter._blue,
      angle: -.25,
    );
    _VineConnectorPainter._spark(
      canvas, Offset(left - 16, bottom - 10), 5,
      _VineConnectorPainter._gold,
    );
    _VineConnectorPainter._spark(
      canvas, Offset(right + 14, top - 8), 4.5,
      _VineConnectorPainter._pink,
    );
  }

  @override
  bool shouldRepaint(covariant _VineFramePainter oldDelegate) =>
      oldDelegate.active != active ||
      oldDelegate.cardWidth != cardWidth ||
      oldDelegate.cardHeight != cardHeight;
}
