import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/period_item.dart';
import '../../../../shared/widgets/primary_button.dart';
import 'landscape_banner_painter.dart';

/// Widget Thẻ thời kỳ (Timeline Card Widget) tái sử dụng.
///
/// Thiết kế chuẩn UI/UX phong cách phiêu lưu lịch sử:
/// - Container bo góc mềm `BorderRadius.circular(24)`
/// - Viền mảnh màu xanh lá (`Color(0xFFA5D6A7)`)
/// - Nửa trên là ảnh minh họa bo góc trên (`ClipRRect`), nửa dưới nền trắng
/// - Khi [item.isSelected] == true:
///   - Kích thước phóng to nhẹ
///   - Đổ bóng mềm xanh lá
///   - Nhãn Positioned góc trên bên trái: Chip màu xanh đậm '★ Đang chọn' chữ trắng
///   - Các chi tiết trang trí lá cây nhỏ bám quanh mép viền của Card
///   - Nút hành động 3D "Vào bản đồ"
class TimelineCard extends StatelessWidget {
  final PeriodItem item;
  final VoidCallback onTap;
  final VoidCallback? onEnterMap;

  const TimelineCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onEnterMap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = item.isSelected;
    final cardWidth = isSelected ? 300.0 : 255.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      width: cardWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Thân thẻ chính
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF66BB6A)
                        : const Color(0xFFA5D6A7),
                    width: isSelected ? 2.4 : 1.4,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Nửa trên: Ảnh minh họa
                      SizedBox(
                        height: isSelected ? 120 : 85,
                        child: _buildCardImage(),
                      ),

                      // Nửa dưới: Khối trắng hiển thị tên thời kỳ và mô tả
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSelected ? 14 : 10,
                          vertical: isSelected ? 10 : 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: isSelected ? 16 : 13.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryLight
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.isUnlocked ? 'Đã mở' : 'Đang khóa',
                                    style: TextStyle(
                                      fontSize: isSelected ? 10 : 8.5,
                                      fontWeight: FontWeight.bold,
                                      color: item.isUnlocked
                                          ? AppColors.primary
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.subtitle,
                              style: TextStyle(
                                fontSize: isSelected ? 12 : 10.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Nút bấm 3D "Vào bản đồ" khi được chọn
                            if (isSelected) ...[
                              const SizedBox(height: 9),
                              PrimaryButton(
                                label: 'Vào bản đồ',
                                icon: const Icon(
                                  Icons.map_rounded,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                height: 36,
                                fontSize: 13,
                                isFullWidth: true,
                                backgroundColor: AppColors.primary,
                                shadowColor: AppColors.primaryDark,
                                onPressed: onEnterMap ?? onTap,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Nhãn Positioned ở góc trên bên trái: Chip màu xanh đậm '★ Đang chọn' chữ trắng
          if (isSelected)
            Positioned(
              top: -10,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 13,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Đang chọn',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Các chi tiết trang trí lá cây nhỏ bám quanh mép viền của Card
          if (isSelected) ...[
            // Lá leo ở mép trái
            Positioned(
              left: -14,
              top: 55,
              child: _buildLeafDecoration(angle: -0.6, size: 24),
            ),
            Positioned(
              left: -12,
              top: 85,
              child: _buildLeafDecoration(angle: -0.2, size: 20),
            ),
            // Lá leo ở mép góc đáy trái
            Positioned(
              left: -6,
              bottom: 8,
              child: _buildLeafDecoration(angle: 0.7, size: 22),
            ),
            // Lá leo bò mép đáy
            Positioned(
              left: 26,
              bottom: -10,
              child: _buildLeafDecoration(angle: 0.35, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardImage() {
    if (item.imageUrl.startsWith('assets/')) {
      return Image.asset(
        item.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const LandscapeBannerWidget(showFlagBadge: false),
      );
    }
    return const LandscapeBannerWidget(showFlagBadge: false);
  }

  Widget _buildLeafDecoration({required double angle, required double size}) {
    return Transform.rotate(
      angle: angle,
      child: CustomPaint(
        size: Size(size, size * 0.55),
        painter: const _CardLeafPainter(),
      ),
    );
  }
}

/// Painter vẽ lá cây nghệ thuật hai nửa sáng-tối bám viền thẻ
class _CardLeafPainter extends CustomPainter {
  const _CardLeafPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Đổ bóng mờ của lá
    final shadowPath = Path()
      ..moveTo(0, h * 0.5)
      ..cubicTo(w * 0.35, 0, w * 0.7, 0, w, h * 0.5)
      ..cubicTo(w * 0.7, h, w * 0.35, h, 0, h * 0.5)
      ..close();
    canvas.drawPath(
      shadowPath.shift(const Offset(1, 1.5)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0),
    );

    // Nửa lá tối (sườn trên)
    final topHalf = Path()
      ..moveTo(0, h * 0.5)
      ..cubicTo(w * 0.35, 0, w * 0.7, 0, w, h * 0.5)
      ..lineTo(0, h * 0.5)
      ..close();
    canvas.drawPath(topHalf, Paint()..color = const Color(0xFF265416));

    // Nửa lá sáng (sườn dưới)
    final bottomHalf = Path()
      ..moveTo(0, h * 0.5)
      ..cubicTo(w * 0.7, h, w * 0.35, h, w, h * 0.5)
      ..lineTo(0, h * 0.5)
      ..close();
    canvas.drawPath(bottomHalf, Paint()..color = const Color(0xFF75BE3D));

    // Gân lá phát sáng
    final veinPaint = Paint()
      ..color = const Color(0xFFB2F377)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, h * 0.5), Offset(w * 0.9, h * 0.5), veinPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
