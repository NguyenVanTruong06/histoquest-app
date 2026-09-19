import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/era_model.dart';
import '../../../../shared/widgets/primary_button.dart';
import 'landscape_banner_painter.dart';

/// Thẻ thời kỳ gắn trên trục Dây Leo Thần Thoại (Beanstalk).
///
/// Thiết kế chuẩn theo mockup:
/// - Thẻ trung tâm (isCenter == true):
///   - Badge "★ Đang chọn" ở góc trên bên trái
///   - Viền xanh lá cây tươi sáng (`#7CB24E`)
///   - Tranh mẫu (bích họa khảo cổ nguyên thủy / Trống Đồng Đông Sơn / di tích)
///   - Khối trắng chân thẻ chứa tên thời kỳ, tiến độ và nút bấm 3D "Vào bản đồ"
/// - Thẻ phụ lân cận (isCenter == false):
///   - Tỷ lệ thu nhỏ nằm cân đối dọc theo dây leo
///   - Viền xanh nhạt, hiển thị tranh mẫu và thông tin tóm tắt
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

  @override
  Widget build(BuildContext context) {
    final isUnlocked = era.isUnlocked;

    return Center(
      child: SizedBox(
        width: isCenter ? 295 : 220,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Thân thẻ
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCenter
                      ? AppColors.primary
                      : AppColors.cardBorder,
                  width: isCenter ? 2.4 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isCenter ? 0.12 : 0.05),
                    blurRadius: isCenter ? 14 : 6,
                    offset: Offset(0, isCenter ? 6 : 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nửa trên: Hình ảnh banner mẫu
                    SizedBox(
                      height: isCenter ? 110 : 70,
                      child: _buildBanner(isCenter),
                    ),

                    // Nửa dưới: Khối trắng chứa nội dung thông tin & nút bấm
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isCenter ? 12 : 8,
                        vertical: isCenter ? 9 : 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  era.name,
                                  style: TextStyle(
                                    fontSize: isCenter ? 15 : 12,
                                    fontWeight: FontWeight.w800,
                                    color: isUnlocked
                                        ? AppColors.textPrimary
                                        : Colors.grey.shade500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isUnlocked
                                      ? AppColors.primaryLight
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  isUnlocked ? 'Đã mở' : 'Đang khóa',
                                  style: TextStyle(
                                    fontSize: isCenter ? 10 : 8.5,
                                    fontWeight: FontWeight.bold,
                                    color: isUnlocked
                                        ? AppColors.primary
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            era.timelineSpan,
                            style: TextStyle(
                              fontSize: isCenter ? 11.5 : 10,
                              fontWeight: FontWeight.w600,
                              color: isUnlocked
                                  ? AppColors.textSecondary
                                  : Colors.grey.shade400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Thanh tiến độ sự kiện (khi ở trung tâm)
                          if (isCenter && era.totalEvents > 0) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: LinearProgressIndicator(
                                      value: era.progress,
                                      backgroundColor: const Color(0xFFEBE6D9),
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        AppColors.gold,
                                      ),
                                      minHeight: 4.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${era.completedEvents}/${era.totalEvents} mốc',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          // Nút bấm 3D "Vào bản đồ" chuẩn HistoQuest
                          if (isCenter) ...[
                            const SizedBox(height: 7),
                            PrimaryButton(
                              label: isUnlocked ? 'Vào bản đồ' : 'Đang khóa',
                              icon: Icon(
                                isUnlocked
                                    ? Icons.map_rounded
                                    : Icons.lock_rounded,
                                size: 15,
                                color: Colors.white,
                              ),
                              height: 35,
                              fontSize: 13,
                              isFullWidth: true,
                              backgroundColor: isUnlocked
                                  ? AppColors.primary
                                  : Colors.grey.shade400,
                              shadowColor: isUnlocked
                                  ? AppColors.primaryDark
                                  : Colors.grey.shade600,
                              onPressed: isUnlocked ? onTap : onLockedTap,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Badge "★ Đang chọn" trên đỉnh thẻ trung tâm
            if (isCenter)
              Positioned(
                top: -11,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
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
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(bool isCenter) {
    // 1. Thời kỳ Tiền sử (era_1): Tranh bích họa khảo cổ nguyên thủy
    if (era.id == 'era_1' || era.name.contains('Tiền sử')) {
      return Image.asset(
        'assets/images/eras/prehistoric_cave_art.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const LandscapeBannerWidget(
          showFlagBadge: false,
        ),
      );
    }

    // 2. Thời kỳ Hồng Bàng / Dựng nước (era_2): Tranh chạm khắc Trống Đồng Đông Sơn
    if (era.id == 'era_2' || era.name.contains('Hồng Bàng') || era.name.contains('Văn Lang')) {
      return Image.asset(
        'assets/images/eras/dong_son_art.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const LandscapeBannerWidget(
          showFlagBadge: false,
        ),
      );
    }

    // 3. Thời kỳ tiếp theo: Ảnh di tích Việt Nam mẫu
    if (era.id == 'era_3' || era.name.contains('Bắc thuộc')) {
      return Image.asset(
        'assets/images/countries/vn.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const LandscapeBannerWidget(
          showFlagBadge: false,
        ),
      );
    }

    // Các thẻ khác: Tranh phong cảnh đồi cỏ xanh & mây trời bồng bềnh
    return const LandscapeBannerWidget(
      showFlagBadge: false,
    );
  }
}
