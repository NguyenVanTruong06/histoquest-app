import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/year_format.dart';
import '../../../../data/models/historical_event_model.dart';
import 'star_clipper.dart';

/// Loại Node sự kiện trên địa đồ cổ phong.
///
/// Tên enum giữ nguyên để tương thích với `EraEventsMapScreen`, nhưng hình
/// dáng đã đổi sang phong cách kiếm hiệp / cổ phong:
/// - [minorCircle]: ấn triện đồng – ngọc bội tròn, tâm ngọc bích.
/// - [majorStar]: lệnh bài / biển thành trì dát vàng, chóp mái đình.
/// - [bossShield]: chiến khiên sơn mài đỏ viền vàng, cờ lệnh.
///
/// Cứ 3 mốc con liên tiếp thì mốc thứ 3 là mốc lớn; mốc cuối cùng của thời đại
/// luôn là Boss (xem `EraEventsMapScreen` cho logic tính toán).
enum MapNodeType {
  majorStar, // Mốc lớn — biển thành trì / lệnh bài quân công dát vàng
  minorCircle, // Mốc phụ — ấn ngọc bội đồng
  bossShield, // Mốc cuối thời đại — chiến khiên sơn mài đỏ viền vàng
}

/// Trạng thái hiển thị của Node sự kiện
enum MapNodeState {
  completed, // Đã hoàn thành (vàng / ngọc sáng + dấu tích)
  active, // Đang học (hào quang vàng nhấp nháy + tooltip)
  locked, // Đang khóa (đá xám / ổ khóa)
}

// Bảng màu cổ phong dùng chung cho node
const Color _kInk = Color(0xFF2B2119);
const Color _kLacquer = Color(0xFF8E2A22);
const Color _kLacquerDark = Color(0xFF5A1712);
const Color _kWood = Color(0xFF6A3E22);
const Color _kWoodDark = Color(0xFF4A2A15);
const Color _kGoldLight = Color(0xFFF6D66F);
const Color _kGoldDeep = Color(0xFFB9861F);
const Color _kJadeDark = Color(0xFF1F6656);
const Color _kStone = Color(0xFFB9B1A0);
const Color _kStoneDark = Color(0xFF8C8471);

/// Widget biểu diễn một Node sự kiện trên địa đồ cổ phong.
class MapEventNode extends StatefulWidget {
  final HistoricalEventModel event;
  final MapNodeType nodeType;
  final MapNodeState state;
  final VoidCallback onTap;
  final VoidCallback? onLockedTap;

  const MapEventNode({
    super.key,
    required this.event,
    required this.nodeType,
    required this.state,
    required this.onTap,
    this.onLockedTap,
  });

  @override
  State<MapEventNode> createState() => _MapEventNodeState();
}

class _MapEventNodeState extends State<MapEventNode>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Hào quang nhịp tim cho node đang học
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 2. Tooltip nhấp nhô
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: -6.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    if (widget.state == MapNodeState.active) {
      _pulseController.repeat(reverse: true);
      _bounceController.repeat(reverse: true);
    }

    // 3. Rung lắc khi chạm node khóa
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.linear),
    );
  }

  @override
  void didUpdateWidget(covariant MapEventNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == MapNodeState.active && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
      _bounceController.repeat(reverse: true);
    } else if (widget.state != MapNodeState.active && _pulseController.isAnimating) {
      _pulseController.stop();
      _bounceController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.state == MapNodeState.locked) {
      _shakeController.forward(from: 0.0);
      widget.onLockedTap?.call();
    } else {
      widget.onTap();
    }
  }

  double get _nodeSize {
    switch (widget.nodeType) {
      case MapNodeType.bossShield:
        return 88.0;
      case MapNodeType.majorStar:
        return 72.0;
      case MapNodeType.minorCircle:
        return 56.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final nodeSize = _nodeSize;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final shakeOffset = sin(_shakeAnimation.value * pi * 4) * 8.0;
        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Thẻ lệnh "BẮT ĐẦU" chỉ hiện khi đang ở node Active
          if (widget.state == MapNodeState.active)
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: child,
                );
              },
              child: _buildActiveTooltip(),
            )
          else
            const SizedBox(height: 28), // Giữ khoảng đệm để cân đối độ cao

          const SizedBox(height: 6),

          // 2. Thân node
          GestureDetector(
            onTap: _handleTap,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Hào quang hoàng kim quanh node active
                if (widget.state == MapNodeState.active)
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      final isRound = widget.nodeType == MapNodeType.minorCircle;
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: nodeSize + 28,
                          height: nodeSize + 28,
                          decoration: BoxDecoration(
                            shape: isRound ? BoxShape.circle : BoxShape.rectangle,
                            borderRadius: isRound ? null : BorderRadius.circular(30),
                            gradient: RadialGradient(
                              colors: [
                                _glowColor.withValues(alpha: 0.5),
                                _glowColor.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                _buildNodeShape(nodeSize),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 3. Nhãn thông tin
          _buildNodeInfoLabels(),
        ],
      ),
    );
  }

  Widget _buildNodeShape(double size) {
    switch (widget.nodeType) {
      case MapNodeType.bossShield:
        return _buildBossShieldNode(size);
      case MapNodeType.majorStar:
        return _buildMajorStarNode(size);
      case MapNodeType.minorCircle:
        return _buildMinorCircleNode(size);
    }
  }

  Color get _glowColor {
    if (widget.nodeType == MapNodeType.bossShield) return const Color(0xFFFF6A3D);
    return AppColors.gold;
  }

  /// Thẻ lệnh nổi bật cho mốc Active: bảng gỗ sơn son viền vàng.
  Widget _buildActiveTooltip() {
    final isBoss = widget.nodeType == MapNodeType.bossShield;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isBoss
              ? const [Color(0xFFB03A2E), _kLacquerDark]
              : const [_kLacquer, _kLacquerDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: _kGoldLight, width: 1.8),
        boxShadow: [
          BoxShadow(
            color: _kInk.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBoss ? Icons.local_fire_department_rounded : Icons.play_arrow_rounded,
            color: _kGoldLight,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            isBoss
                ? 'THỬ THÁCH BOSS'
                : (widget.event.isCompleted ? 'ÔN TẬP' : 'BẮT ĐẦU'),
            style: const TextStyle(
              color: Color(0xFFFFF3C4),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────── Mốc lớn: Biển thành trì / lệnh bài dát vàng ───────────────
  Widget _buildMajorStarNode(double size) {
    late final Color rimTop;
    late final Color rimBottom;
    late final Color faceTop;
    late final Color faceBottom;
    late final Widget centerIcon;

    switch (widget.state) {
      case MapNodeState.completed:
        rimTop = _kGoldLight;
        rimBottom = _kGoldDeep;
        faceTop = const Color(0xFF7A4A26);
        faceBottom = _kWoodDark;
        centerIcon = const Icon(Icons.check_rounded, color: _kGoldLight, size: 32);
        break;
      case MapNodeState.active:
        rimTop = _kGoldLight;
        rimBottom = _kGoldDeep;
        faceTop = const Color(0xFFA8362B);
        faceBottom = _kLacquerDark;
        centerIcon = const Icon(Icons.fort_rounded, color: _kGoldLight, size: 34);
        break;
      case MapNodeState.locked:
        rimTop = const Color(0xFFD5CDB8);
        rimBottom = _kStoneDark;
        faceTop = const Color(0xFF8F8878);
        faceBottom = const Color(0xFF6E6858);
        centerIcon = const Icon(Icons.lock_rounded, color: Color(0xFFD8D1BE), size: 28);
        break;
    }

    final width = size * 1.2;
    final height = size + 6;

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _PlaquePainter(
          rimTop: rimTop,
          rimBottom: rimBottom,
          faceTop: faceTop,
          faceBottom: faceBottom,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Center(child: centerIcon),
        ),
      ),
    );
  }

  // ─────────────── Boss: Chiến khiên sơn mài viền vàng ───────────────
  Widget _buildBossShieldNode(double size) {
    late final Color rimTop;
    late final Color rimBottom;
    late final Color faceTop;
    late final Color faceBottom;
    late final Widget centerIcon;

    switch (widget.state) {
      case MapNodeState.completed:
        rimTop = _kGoldLight;
        rimBottom = _kGoldDeep;
        faceTop = const Color(0xFF7A4A26);
        faceBottom = _kWoodDark;
        centerIcon = const Icon(Icons.check_rounded, color: _kGoldLight, size: 40);
        break;
      case MapNodeState.active:
        rimTop = _kGoldLight;
        rimBottom = _kGoldDeep;
        faceTop = const Color(0xFFC0392B);
        faceBottom = _kLacquerDark;
        centerIcon = const Icon(Icons.flag_rounded, color: _kGoldLight, size: 40);
        break;
      case MapNodeState.locked:
        rimTop = const Color(0xFFD5CDB8);
        rimBottom = _kStoneDark;
        faceTop = const Color(0xFF8F8878);
        faceBottom = const Color(0xFF6E6858);
        centerIcon = const Icon(Icons.lock_rounded, color: Color(0xFFD8D1BE), size: 32);
        break;
    }

    final inner = size * 0.80;

    return SizedBox(
      width: size,
      height: size + 8,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Bóng đổ đáy
          Positioned(
            bottom: 0,
            child: ClipPath(
              clipper: const ShieldClipper(),
              child: Container(width: size, height: size, color: _kInk.withValues(alpha: 0.55)),
            ),
          ),
          // Viền vàng chạm rồng
          Positioned(
            top: 0,
            child: ClipPath(
              clipper: const ShieldClipper(),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [rimTop, rimBottom],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          // Mặt khiên sơn mài
          Positioned(
            top: size * 0.09,
            child: ClipPath(
              clipper: const ShieldClipper(),
              child: Container(
                width: inner,
                height: inner,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [faceTop, faceBottom],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Center(child: centerIcon),
                ),
              ),
            ),
          ),
          // Đinh tán vàng hai vai khiên
          Positioned(top: size * 0.06, left: size * 0.16, child: _stud()),
          Positioned(top: size * 0.06, right: size * 0.16, child: _stud()),
        ],
      ),
    );
  }

  Widget _stud() {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _kGoldLight,
        border: Border.all(color: _kGoldDeep, width: 0.8),
      ),
    );
  }

  // ─────────────── Mốc phụ: Ấn triện đồng – ngọc bội ───────────────
  Widget _buildMinorCircleNode(double size) {
    late final Color bronzeTop;
    late final Color bronzeBottom;
    late final Color jadeTop;
    late final Color jadeBottom;
    late final Widget centerIcon;

    switch (widget.state) {
      case MapNodeState.completed:
        bronzeTop = _kGoldLight;
        bronzeBottom = _kGoldDeep;
        jadeTop = const Color(0xFF63C2A8);
        jadeBottom = _kJadeDark;
        centerIcon = const Icon(Icons.check_rounded, color: Colors.white, size: 24);
        break;
      case MapNodeState.active:
        bronzeTop = _kGoldLight;
        bronzeBottom = _kGoldDeep;
        jadeTop = const Color(0xFFFFD36B);
        jadeBottom = const Color(0xFFE0891F);
        centerIcon = const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 26);
        break;
      case MapNodeState.locked:
        bronzeTop = const Color(0xFFD5CDB8);
        bronzeBottom = _kStoneDark;
        jadeTop = _kStone;
        jadeBottom = const Color(0xFF7E7765);
        centerIcon = const Icon(Icons.lock_rounded, color: Color(0xFF5F5A4C), size: 20);
        break;
    }

    final jadeSize = size * 0.66;

    return SizedBox(
      width: size,
      height: size + 5,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Bóng đổ đáy
          Positioned(
            bottom: 0,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kInk.withValues(alpha: 0.55),
              ),
            ),
          ),
          // Vành đồng khắc răng cưa
          Positioned(
            top: 0,
            child: CustomPaint(
              size: Size(size, size),
              painter: _SealRingPainter(top: bronzeTop, bottom: bronzeBottom),
            ),
          ),
          // Tâm ngọc bích
          Positioned(
            top: (size - jadeSize) / 2,
            child: Container(
              width: jadeSize,
              height: jadeSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [jadeTop, jadeBottom],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: _kInk.withValues(alpha: 0.55), width: 1.4),
              ),
              child: Center(child: centerIcon),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────── Nhãn: bảng gỗ / trúc thư ───────────────
  Widget _buildNodeInfoLabels() {
    final isLocked = widget.state == MapNodeState.locked;
    final isActive = widget.state == MapNodeState.active;
    final isBoss = widget.nodeType == MapNodeType.bossShield;

    final List<Color> plankColors = isLocked
        ? const [Color(0xFFCFC7B0), Color(0xFFB4AC94)]
        : (isBoss
            ? const [_kLacquer, _kLacquerDark]
            : (isActive
                ? const [Color(0xFF8A5530), _kWoodDark]
                : const [Color(0xFF7A4A26), _kWood]));
    final Color plankBorder = isLocked ? const Color(0xFF8C8471) : _kGoldDeep;
    final Color plankText = isLocked ? const Color(0xFF5F5A4C) : const Color(0xFFFFF3C4);

    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      child: Column(
        children: [
          // Bảng gỗ năm sự kiện (hoặc nhãn BOSS)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: plankColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: plankBorder, width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: _kInk.withValues(alpha: 0.25),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              isBoss
                  ? 'BOSS · ${formatHistoricalYear(widget.event.year)}'
                  : 'Năm ${formatHistoricalYear(widget.event.year)}',
              style: TextStyle(
                color: plankText,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Tên sự kiện — chữ mực trên giấy, có quầng sáng để dễ đọc
          Text(
            widget.event.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
              color: isLocked ? const Color(0xFF6E6858) : _kInk,
              height: 1.25,
              shadows: const [
                Shadow(color: Color(0xCCF0E4BE), blurRadius: 4),
                Shadow(color: Color(0xCCF0E4BE), blurRadius: 8),
              ],
            ),
          ),

          if (widget.event.rewardCardName != null && !isLocked) ...[
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: _kGoldDeep, size: 13),
                const SizedBox(width: 3),
                Text(
                  widget.event.rewardCardName!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8A5A0E),
                    shadows: [Shadow(color: Color(0xCCF0E4BE), blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Vẽ biển thành trì / lệnh bài: chóp mái đình cong, thân chữ nhật, viền vàng.
class _PlaquePainter extends CustomPainter {
  final Color rimTop;
  final Color rimBottom;
  final Color faceTop;
  final Color faceBottom;

  const _PlaquePainter({
    required this.rimTop,
    required this.rimBottom,
    required this.faceTop,
    required this.faceBottom,
  });

  Path _plaque(Rect r, double roofH) {
    final w = r.width;
    final p = Path()
      ..moveTo(r.left, r.top + roofH)
      // Mái đình cong vút hai đầu
      ..quadraticBezierTo(r.left + w * 0.10, r.top + roofH * 0.9, r.left + w * 0.30, r.top + roofH * 0.45)
      ..quadraticBezierTo(r.left + w * 0.45, r.top + roofH * 0.1, r.center.dx, r.top)
      ..quadraticBezierTo(r.right - w * 0.45, r.top + roofH * 0.1, r.right - w * 0.30, r.top + roofH * 0.45)
      ..quadraticBezierTo(r.right - w * 0.10, r.top + roofH * 0.9, r.right, r.top + roofH)
      ..lineTo(r.right - w * 0.05, r.bottom - 6)
      ..quadraticBezierTo(r.right - w * 0.05, r.bottom, r.right - w * 0.11, r.bottom)
      ..lineTo(r.left + w * 0.11, r.bottom)
      ..quadraticBezierTo(r.left + w * 0.05, r.bottom, r.left + w * 0.05, r.bottom - 6)
      ..close();
    return p;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final outer = Rect.fromLTWH(0, 0, size.width, size.height - 6);
    final roofH = outer.height * 0.30;

    // Bóng đổ đáy
    canvas.drawPath(_plaque(outer.shift(const Offset(0, 6)), roofH), Paint()..color = _kInk.withValues(alpha: 0.55));

    // Viền vàng
    final rim = _plaque(outer, roofH);
    canvas.drawPath(
      rim,
      Paint()
        ..shader = LinearGradient(
          colors: [rimTop, rimBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(outer),
    );
    canvas.drawPath(
      rim,
      Paint()
        ..color = _kInk.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // Mặt biển (thụt vào)
    final inner = outer.deflate(4.5);
    final face = _plaque(inner, roofH * 0.9);
    canvas.drawPath(
      face,
      Paint()
        ..shader = LinearGradient(
          colors: [faceTop, faceBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(inner),
    );
    canvas.drawPath(
      face,
      Paint()
        ..color = _kInk.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Đinh tán vàng dưới hai góc
    final stud = Paint()..color = rimTop;
    canvas.drawCircle(Offset(inner.left + 6, inner.bottom - 6), 1.8, stud);
    canvas.drawCircle(Offset(inner.right - 6, inner.bottom - 6), 1.8, stud);
  }

  @override
  bool shouldRepaint(covariant _PlaquePainter old) =>
      old.rimTop != rimTop ||
      old.rimBottom != rimBottom ||
      old.faceTop != faceTop ||
      old.faceBottom != faceBottom;
}

/// Vành ấn triện đồng: vòng tròn gradient + răng cưa khắc quanh viền.
class _SealRingPainter extends CustomPainter {
  final Color top;
  final Color bottom;

  const _SealRingPainter({required this.top, required this.bottom});

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final rect = Rect.fromCircle(center: c, radius: r);

    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = LinearGradient(
          colors: [top, bottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect),
    );
    canvas.drawCircle(
      c,
      r - 0.7,
      Paint()
        ..color = _kInk.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // Răng cưa khắc chìm
    final tick = Paint()
      ..color = _kInk.withValues(alpha: 0.38)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;
    const n = 16;
    for (int i = 0; i < n; i++) {
      final a = i * 2 * pi / n;
      canvas.drawLine(
        c + Offset(cos(a), sin(a)) * (r - 6.5),
        c + Offset(cos(a), sin(a)) * (r - 3),
        tick,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SealRingPainter old) => old.top != top || old.bottom != bottom;
}
