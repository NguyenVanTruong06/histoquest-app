import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/country_model.dart';

/// Thẻ nền văn minh cho PageView ngang (Bước 1 của tab Bản đồ).
///
/// Banner 16:9 trên đầu ưu tiên dùng [CountryModel.assetImagePath] khi có;
/// nếu ảnh chưa sẵn sàng (thiếu file / load lỗi) sẽ tự rơi về gradient
/// [CountryModel.accentColor] kết hợp icon nền văn minh làm banner thay thế.
class CountryPageCard extends StatelessWidget {
  final CountryModel country;
  final bool unlocked;
  final bool active;
  final int doneCount;
  final int requiredCount;
  final VoidCallback onTap;

  const CountryPageCard({
    super.key,
    required this.country,
    required this.unlocked,
    required this.active,
    required this.doneCount,
    required this.requiredCount,
    required this.onTap,
  });

  Widget _buildBannerFallback() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: unlocked
              ? [country.accentColor, _darken(country.accentColor)]
              : [Colors.grey.shade400, Colors.grey.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pattern hoạ tiết đường chéo trang trí nhẹ
          Positioned.fill(
            child: CustomPaint(painter: _DiagonalPatternPainter()),
          ),
          Icon(
            unlocked ? country.icon : Icons.lock_rounded,
            size: 64,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ],
      ),
    );
  }

  Color _darken(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.18).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = country.assetImagePath;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: active ? country.accentColor : AppColors.cardBorder,
            width: active ? 2.4 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D2B2B).withValues(alpha: active ? 0.16 : 0.07),
              offset: const Offset(0, 10),
              blurRadius: active ? 28 : 18,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner 16:9
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (assetPath != null)
                      Image.asset(
                        assetPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _buildBannerFallback(),
                      )
                    else
                      _buildBannerFallback(),
                    // Lớp phủ tối nhẹ đáy ảnh để chữ/emoji nổi bật
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.28)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.55, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 10,
                      child: Text(
                        country.flagEmoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    if (!unlocked)
                      Positioned(
                        left: 12,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lock_rounded, size: 16, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),

              // Nội dung: tên, trạng thái, subtitle
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primaryLight : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          !unlocked
                              ? 'Đang khóa · $doneCount/$requiredCount mốc'
                              : (active ? 'Sẵn sàng khám phá' : 'Sắp ra mắt'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: active ? AppColors.primary : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        country.name,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Text(
                          unlocked ? country.subtitle : (country.unlockHint ?? country.subtitle),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hoạ tiết đường chéo trang trí nhẹ cho banner fallback (khi chưa có ảnh thật)
class _DiagonalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 3;
    const spacing = 22.0;
    for (double x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
