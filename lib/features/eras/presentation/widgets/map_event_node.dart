import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/year_format.dart';
import '../../../../data/models/historical_event_model.dart';
import 'star_clipper.dart';

/// Loại Node sự kiện trên bản đồ.
///
/// Cứ 3 mốc con (minorCircle) liên tiếp thì mốc thứ 3 trở thành mốc lớn
/// (majorStar); mốc cuối cùng của thời đại luôn là Boss (bossShield), bất
/// kể có rơi đúng vào bội số của 3 hay không. Xem `EraEventsMapScreen` cho
/// logic tính toán.
enum MapNodeType {
  majorStar, // Mốc lớn — cứ 3 mốc con thì 1 mốc lớn (ngôi sao 6 cánh, vàng)
  minorCircle, // Mốc phụ (vòng tròn, primary)
  bossShield, // Mốc cuối cùng của thời đại — quiz tổng hợp (khiên, đỏ đậm)
}

/// Trạng thái hiển thị của Node sự kiện
enum MapNodeState {
  completed, // Đã hoàn thành (Vàng gold / Tích xanh)
  active,    // Chưa khóa / Đang học (Cam đất nung / Hào quang nhấp nháy / Tooltip)
  locked,    // Đang khóa (Xám bạc / Ổ khóa)
}

/// Widget biểu diễn một Node sự kiện dạng Board Game Gamification
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

    // 1. Hiệu ứng hào quang nhịp tim (Pulse Glow) cho node đang học
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 2. Hiệu ứng nhấp nhô (Floating Bounce) cho tooltip "BẮT ĐẦU"
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

    // 3. Hiệu ứng rung lắc (Shake) khi chạm vào node đang bị khóa
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
        // Tính toán độ lệch ngang rung lắc
        final shakeOffset = sin(_shakeAnimation.value * pi * 4) * 8.0;
        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Tooltip bay "BẮT ĐẦU / HỌC TIẾP" chỉ hiện khi đang ở node Active
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

          // 2. Thân Node chính (Khiên / Ngôi sao / Vòng tròn 3D)
          GestureDetector(
            onTap: _handleTap,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Vòng hào quang phát sáng xung quanh node active
                if (widget.state == MapNodeState.active)
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      final isRound = widget.nodeType == MapNodeType.minorCircle;
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: nodeSize + 24,
                          height: nodeSize + 24,
                          decoration: BoxDecoration(
                            shape: isRound ? BoxShape.circle : BoxShape.rectangle,
                            borderRadius: isRound ? null : BorderRadius.circular(28),
                            gradient: RadialGradient(
                              colors: [
                                _glowColor.withValues(alpha: 0.35),
                                _glowColor.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                // Hình dáng Node 3D theo loại
                _buildNodeShape(nodeSize),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 3. Nhãn thông tin sự kiện bên dưới (Năm & Tiêu đề)
          _buildNodeInfoLabels(),
        ],
      ),
    );
  }

  /// Chọn hình dáng Node 3D tương ứng với [MapNodeType].
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
    if (widget.nodeType == MapNodeType.bossShield) return AppColors.danger;
    return AppColors.primary;
  }

  /// Tooltip bay nổi bật cho mốc Active
  Widget _buildActiveTooltip() {
    final isBoss = widget.nodeType == MapNodeType.bossShield;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isBoss ? AppColors.danger : AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isBoss ? AppColors.danger : AppColors.primary).withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBoss ? Icons.local_fire_department_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            isBoss
                ? 'THỬ THÁCH BOSS'
                : (widget.event.isCompleted ? 'ÔN TẬP' : 'BẮT ĐẦU'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  /// Dựng Mốc lớn (Ngôi sao 6 cánh 3D) — cứ 3 mốc con thì có 1 mốc lớn.
  Widget _buildMajorStarNode(double size) {
    Color topColor;
    Color bottomColor;
    Widget centerIcon;

    switch (widget.state) {
      case MapNodeState.completed:
        topColor = const Color(0xFFF0B33A);
        bottomColor = const Color(0xFFB57715);
        centerIcon = const Icon(Icons.check_rounded, color: Colors.white, size: 34);
        break;
      case MapNodeState.active:
        topColor = AppColors.gold;
        bottomColor = AppColors.goldDark;
        centerIcon = const Icon(Icons.star_rounded, color: Colors.white, size: 36);
        break;
      case MapNodeState.locked:
        topColor = const Color(0xFFCCCCCC);
        bottomColor = const Color(0xFF9E9E9E);
        centerIcon = const Icon(Icons.lock_rounded, color: Color(0xFF6E6E6E), size: 30);
        break;
    }

    return SizedBox(
      width: size,
      height: size + 6, // Dư 6px cho bóng đổ đáy 3D
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Lớp đáy đổ bóng 3D của ngôi sao
          Positioned(
            bottom: 0,
            child: ClipPath(
              clipper: const StarClipper(innerRadiusRatio: 0.55, points: 6),
              child: Container(
                width: size,
                height: size,
                color: bottomColor,
              ),
            ),
          ),

          // Lớp mặt nổi chính của ngôi sao
          Positioned(
            top: 0,
            child: ClipPath(
              clipper: const StarClipper(innerRadiusRatio: 0.55, points: 6),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      topColor.withValues(alpha: 0.9),
                      topColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: centerIcon,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Dựng Mốc Boss (Khiên 3D đỏ đậm) — mốc cuối cùng của thời đại, quiz tổng.
  Widget _buildBossShieldNode(double size) {
    Color topColor;
    Color bottomColor;
    Widget centerIcon;

    switch (widget.state) {
      case MapNodeState.completed:
        topColor = const Color(0xFFF0B33A);
        bottomColor = const Color(0xFFB57715);
        centerIcon = const Icon(Icons.check_rounded, color: Colors.white, size: 40);
        break;
      case MapNodeState.active:
        topColor = AppColors.danger;
        bottomColor = const Color(0xFF7A2323);
        centerIcon = const Icon(Icons.shield_rounded, color: Colors.white, size: 42);
        break;
      case MapNodeState.locked:
        topColor = const Color(0xFFCCCCCC);
        bottomColor = const Color(0xFF9E9E9E);
        centerIcon = const Icon(Icons.lock_rounded, color: Color(0xFF6E6E6E), size: 34);
        break;
    }

    return SizedBox(
      width: size,
      height: size + 8, // Dư 8px cho bóng đổ đáy 3D
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 0,
            child: ClipPath(
              clipper: const ShieldClipper(),
              child: Container(
                width: size,
                height: size,
                color: bottomColor,
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: ClipPath(
              clipper: const ShieldClipper(),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      topColor.withValues(alpha: 0.92),
                      topColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: centerIcon,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Dựng Mốc phụ (Vòng tròn 3D phong cách nút HistoQuest)
  Widget _buildMinorCircleNode(double size) {
    Color topColor;
    Color bottomColor;
    Color rimBorderColor;
    Widget centerIcon;

    switch (widget.state) {
      case MapNodeState.completed:
        topColor = const Color(0xFF4CAF50);
        bottomColor = const Color(0xFF2E7D32);
        rimBorderColor = const Color(0xFF81C784);
        centerIcon = const Icon(Icons.check_rounded, color: Colors.white, size: 26);
        break;
      case MapNodeState.active:
        topColor = AppColors.primary;
        bottomColor = AppColors.primaryDark;
        rimBorderColor = const Color(0xFFF28F72);
        centerIcon = const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 28);
        break;
      case MapNodeState.locked:
        topColor = const Color(0xFFD4CEC3);
        bottomColor = const Color(0xFFA8A195);
        rimBorderColor = const Color(0xFFE8E4DC);
        centerIcon = const Icon(Icons.lock_rounded, color: Color(0xFF757575), size: 22);
        break;
    }

    return Container(
      width: size,
      height: size + 5, // 5px cho bóng đổ 3D
      decoration: BoxDecoration(
        color: bottomColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: bottomColor.withValues(alpha: 0.35),
            offset: const Offset(0, 5),
            blurRadius: 6,
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: topColor,
            border: Border.all(color: rimBorderColor, width: 3),
            gradient: LinearGradient(
              colors: [
                topColor.withValues(alpha: 0.9),
                topColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(child: centerIcon),
        ),
      ),
    );
  }

  /// Nhãn thông tin mốc sự kiện (Năm, Tên tóm gọn, Thẻ tướng nếu có)
  Widget _buildNodeInfoLabels() {
    final isLocked = widget.state == MapNodeState.locked;
    final isActive = widget.state == MapNodeState.active;
    final isBoss = widget.nodeType == MapNodeType.bossShield;

    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      child: Column(
        children: [
          // Badge Năm sự kiện (hoặc nhãn BOSS)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: isLocked
                  ? const Color(0xFFDDD8CE)
                  : (isBoss
                      ? AppColors.danger
                      : (isActive ? AppColors.darkBackground : const Color(0xFF4A443D))),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isBoss
                  ? 'BOSS · ${formatHistoricalYear(widget.event.year)}'
                  : 'Năm ${formatHistoricalYear(widget.event.year)}',
              style: TextStyle(
                color: isLocked ? const Color(0xFF7D776C) : Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Tên sự kiện
          Text(
            widget.event.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isLocked ? const Color(0xFF8C857B) : AppColors.textPrimary,
              height: 1.25,
            ),
          ),

          if (widget.event.rewardCardName != null && !isLocked) ...[
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: AppColors.gold, size: 13),
                const SizedBox(width: 3),
                Text(
                  widget.event.rewardCardName!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB57715),
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
