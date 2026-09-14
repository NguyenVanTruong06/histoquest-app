import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/historical_event_model.dart';
import 'star_clipper.dart';

/// Loại Node sự kiện trên bản đồ
enum MapNodeType {
  majorStar,   // Mốc lớn (Ngôi sao 5 cánh)
  minorCircle, // Mốc phụ (Vòng tròn)
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

  @override
  Widget build(BuildContext context) {
    final isMajor = widget.nodeType == MapNodeType.majorStar;
    final nodeSize = isMajor ? 84.0 : 68.0;

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

          // 2. Thân Node chính (Ngôi sao hoặc Vòng tròn 3D)
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
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: nodeSize + 24,
                          height: nodeSize + 24,
                          decoration: BoxDecoration(
                            shape: isMajor ? BoxShape.rectangle : BoxShape.circle,
                            borderRadius: isMajor ? BorderRadius.circular(28) : null,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.35),
                                AppColors.primary.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                // Hình dáng Node 3D
                if (isMajor)
                  _buildMajorStarNode(nodeSize)
                else
                  _buildMinorCircleNode(nodeSize),
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

  /// Tooltip bay nổi bật cho mốc Active
  Widget _buildActiveTooltip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x35D95D39),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            widget.event.isCompleted ? 'ÔN TẬP' : 'BẮT ĐẦU',
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

  /// Dựng Mốc lớn (Ngôi sao 5 cánh 3D)
  Widget _buildMajorStarNode(double size) {
    Color topColor;
    Color bottomColor;
    Widget centerIcon;

    switch (widget.state) {
      case MapNodeState.completed:
        topColor = const Color(0xFFF0B33A);
        bottomColor = const Color(0xFFB57715);
        centerIcon = const Icon(Icons.check_rounded, color: Colors.white, size: 36);
        break;
      case MapNodeState.active:
        topColor = AppColors.primary;
        bottomColor = AppColors.primaryDark;
        centerIcon = const Icon(Icons.star_rounded, color: Colors.white, size: 40);
        break;
      case MapNodeState.locked:
        topColor = const Color(0xFFCCCCCC);
        bottomColor = const Color(0xFF9E9E9E);
        centerIcon = const Icon(Icons.lock_rounded, color: Color(0xFF6E6E6E), size: 32);
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
              clipper: const StarClipper(innerRadiusRatio: 0.48),
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
              clipper: const StarClipper(innerRadiusRatio: 0.48),
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
        centerIcon = const Icon(Icons.check_rounded, color: Colors.white, size: 30);
        break;
      case MapNodeState.active:
        topColor = AppColors.primary;
        bottomColor = AppColors.primaryDark;
        rimBorderColor = const Color(0xFFF28F72);
        centerIcon = const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 32);
        break;
      case MapNodeState.locked:
        topColor = const Color(0xFFD4CEC3);
        bottomColor = const Color(0xFFA8A195);
        rimBorderColor = const Color(0xFFE8E4DC);
        centerIcon = const Icon(Icons.lock_rounded, color: Color(0xFF757575), size: 26);
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

    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      child: Column(
        children: [
          // Badge Năm sự kiện
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: isLocked
                  ? const Color(0xFFDDD8CE)
                  : (isActive ? AppColors.darkBackground : const Color(0xFF4A443D)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Năm ${widget.event.year}',
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
