import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/historical_event_model.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/stat_badge.dart';

class QuizResultScreen extends StatefulWidget {
  final int correctCount;
  final int totalCount;
  final HistoricalEventModel? event;

  const QuizResultScreen({
    super.key,
    required this.correctCount,
    required this.totalCount,
    this.event,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _badgesController;
  late final Animation<double> _badgesAnimation;
  late final AnimationController _confettiController;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _badgesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _badgesAnimation = CurvedAnimation(
      parent: _badgesController,
      curve: Curves.easeOut,
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Chuỗi animation vào màn
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _badgesController.forward();
    });
    if (_isPassed) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _confettiController.forward();
      });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _badgesController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  bool get _isPassed => widget.correctCount >= (widget.totalCount * 0.6).ceil();
  bool get _isMastery => widget.correctCount == widget.totalCount;

  @override
  Widget build(BuildContext context) {
    // Landscape: tách thành 2 cột thay vì 1 cột dọc rất dài — cột trái cố
    // định (icon + tiêu đề kết quả), cột phải cuộn được (điểm số, phần
    // thưởng, nút hành động) — tận dụng chiều rộng, giảm cuộn dọc.
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Confetti particles nếu đạt
          if (_isPassed) _buildConfettiLayer(),

          SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTopLabel(),
                        const SizedBox(height: 22),
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: _buildResultIcon(),
                        ),
                        const SizedBox(height: 18),
                        _buildResultTitle(),
                        const SizedBox(height: 6),
                        if (widget.event != null)
                          Text(
                            '${widget.event!.year} · ${widget.event!.title}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12, 20, 22, 20),
                    child: Column(
                      children: [
                        // Thẻ điểm số + trạng thái
                        _buildScoreCard(),

                        const SizedBox(height: 16),

                        // Thẻ phần thưởng
                        FadeTransition(
                          opacity: _badgesAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.15),
                              end: Offset.zero,
                            ).animate(_badgesAnimation),
                            child: _buildRewardsCard(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Các nút hành động
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfettiLayer() {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, _) {
        return CustomPaint(
          painter: _ConfettiPainter(_confettiController.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }

  Widget _buildTopLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.darkBackground,
            borderRadius: BorderRadius.circular(99),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.quiz_rounded, size: 14, color: Colors.white54),
              SizedBox(width: 6),
              Text(
                'Kết quả bài kiểm tra',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultIcon() {
    if (_isMastery) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE4A93A), Color(0xFFD95D39)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(Icons.emoji_events_rounded, size: 64, color: Colors.white),
      );
    } else if (_isPassed) {
      return Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F4EC),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.success, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.check_circle_rounded, size: 62, color: AppColors.success),
      );
    } else {
      return Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFFFEEAEA),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.danger, width: 3),
        ),
        child: const Icon(Icons.sentiment_dissatisfied_rounded, size: 62, color: AppColors.danger),
      );
    }
  }

  Widget _buildResultTitle() {
    final title = _isMastery
        ? '🎉 Tuyệt Vời! Xuất Sắc!'
        : _isPassed
            ? '✅ Đạt! Tiếp tục chinh phục!'
            : '📚 Chưa đạt – Cố lên nào!';

    final color = _isMastery
        ? AppColors.primary
        : _isPassed
            ? AppColors.success
            : AppColors.danger;

    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: -0.4,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildScoreCard() {
    final isPassed = _isPassed;
    final percent = widget.totalCount > 0
        ? widget.correctCount / widget.totalCount
        : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPassed
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.danger.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Điểm số lớn
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${widget.correctCount}',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: isPassed ? AppColors.success : AppColors.danger,
                  height: 1,
                ),
              ),
              Text(
                ' / ${widget.totalCount}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          const Text(
            'câu trả lời đúng',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // Thanh tiến trình
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: percent),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: AppColors.cardBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPassed ? AppColors.success : AppColors.danger,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Badge trạng thái
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isPassed
                  ? const Color(0xFFE8F4EC)
                  : const Color(0xFFFEEAEA),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPassed ? Icons.check_rounded : Icons.close_rounded,
                  size: 16,
                  color: isPassed ? AppColors.success : AppColors.danger,
                ),
                const SizedBox(width: 6),
                Text(
                  isPassed ? 'ĐẠT — Tiếp tục hành trình!' : 'CHƯA ĐẠT — Làm lại để nhận thưởng',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isPassed ? AppColors.success : AppColors.danger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsCard() {
    final event = widget.event;
    final xpEarned = _isPassed ? (event?.xpReward ?? 100) : (event?.xpReward ?? 100) ~/ 3;
    final coinsEarned = _isPassed ? (event?.coinReward ?? 30) : (event?.coinReward ?? 30) ~/ 3;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFAF5E8), Color(0xFFFBF3E2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium_rounded, size: 18, color: AppColors.goldDark),
              const SizedBox(width: 7),
              const Text(
                'Phần thưởng đã nhận:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.goldDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatBadge.xp('+$xpEarned'),
              StatBadge.coin('+$coinsEarned xu'),
              if (_isPassed && event?.rewardCardName != null)
                StatBadge.reward(event!.rewardCardName!),
            ],
          ),
          if (!_isPassed) ...[
            const SizedBox(height: 12),
            Text(
              '💡 Làm lại để nhận đầy đủ phần thưởng!',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Nút chính: Về bản đồ
        PrimaryButton(
          label: 'Về Bản Đồ',
          isFullWidth: true,
          height: 56,
          icon: const Icon(Icons.map_rounded, color: Colors.white, size: 20),
          onPressed: () {
            // Pop về màn tóm tắt, sau đó về bản đồ
            while (context.canPop()) {
              context.pop();
            }
            context.go('/eras');
          },
        ),

        const SizedBox(height: 12),

        // Nút phụ: Làm lại
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () {
              // Pop màn kết quả, quay lại quiz từ đầu
              context.pop();
            },
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text(
              'Làm lại ngay',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// CustomPainter vẽ confetti đơn giản
class _ConfettiPainter extends CustomPainter {
  final double progress;
  static final List<Map<String, dynamic>> _particles = List.generate(40, (i) {
    return {
      'x': (i * 37 + 50) % 100 / 100.0,
      'speed': 0.3 + (i % 5) * 0.15,
      'size': 5.0 + (i % 4) * 3,
      'color': [
        AppColors.primary,
        AppColors.gold,
        AppColors.success,
        AppColors.xpColor,
        Colors.orange,
      ][i % 5],
      'shape': i % 3,
    };
  });

  _ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final speed = p['speed'] as double;
      final t = (progress * speed).clamp(0.0, 1.0);
      final x = (p['x'] as double) * size.width;
      final y = t * size.height * 1.2 - size.height * 0.15;

      if (t <= 0 || t >= 1) continue;

      final paint = Paint()
        ..color = (p['color'] as Color).withValues(alpha: 1 - t * 0.8)
        ..style = PaintingStyle.fill;

      final sz = p['size'] as double;
      final shape = p['shape'] as int;

      canvas.save();
      canvas.translate(x + (t * 30 - 15) * (p['x'] as double > 0.5 ? 1 : -1), y);
      canvas.rotate(t * 6.28);

      if (shape == 0) {
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: sz, height: sz * 0.6), paint);
      } else if (shape == 1) {
        canvas.drawCircle(Offset.zero, sz / 2, paint);
      } else {
        final path = Path()
          ..moveTo(0, -sz / 2)
          ..lineTo(sz / 2, sz / 2)
          ..lineTo(-sz / 2, sz / 2)
          ..close();
        canvas.drawPath(path, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.progress != progress;
}
