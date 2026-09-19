import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/country_model.dart';
import '../../../../shared/widgets/primary_button.dart';
import 'landscape_banner_painter.dart';

/// Thẻ nền văn minh cho màn hình "Chọn nền văn minh" (Screen 1 theo mockup).
///
/// Thiết kế gồm:
/// - Nửa trên: Tranh phong cảnh đồi cỏ xanh uốn lượn, mây trời trong trẻo,
///   góc trên phải là huy hiệu tròn cờ đỏ sao vàng (hoặc quốc kỳ tương ứng).
/// - Nửa dưới: Khối container trắng bo tròn hiển thị tên nền văn minh,
///   badge trạng thái, mô tả và nút bấm 3D "Khám phá ngay" chuẩn HistoQuest.
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: active ? const Color(0xFFC8DEC0) : const Color(0xFFDFD8C9),
          width: active ? 1.8 : 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: active ? 0.08 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nửa trên: Banner mẫu theo từng nền văn minh + Huy hiệu cờ tròn
            SizedBox(
              height: 145,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (country.id == 'vn')
                    const LandscapeBannerWidget(
                      showFlagBadge: false,
                    )
                  else if (country.assetImagePath != null)
                    Image.asset(
                      country.assetImagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const LandscapeBannerWidget(showFlagBadge: false),
                    )
                  else
                    const LandscapeBannerWidget(showFlagBadge: false),

                  Positioned(
                    top: 12,
                    right: 14,
                    child: _buildCountryFlagBadge(),
                  ),
                ],
              ),
            ),

            // Nửa dưới: Khối thông tin nền văn minh và nút hành động
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          country.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: unlocked
                              ? (active
                                  ? AppColors.primaryLight
                                  : Colors.grey.shade100)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: unlocked && active
                                ? AppColors.primary.withValues(alpha: 0.25)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          !unlocked
                              ? 'Đang khóa · $doneCount/$requiredCount mốc'
                              : (active ? 'Sẵn sàng khám phá' : 'Sắp ra mắt'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: unlocked && active
                                ? AppColors.primary
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    unlocked ? country.subtitle : (country.unlockHint ?? country.subtitle),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),

                  // Nút bấm 3D chuẩn HistoQuest
                  PrimaryButton(
                    label: active
                        ? 'Khám phá ngay'
                        : (unlocked ? 'Sắp ra mắt' : 'Đang khóa'),
                    icon: Icon(
                      active
                          ? Icons.explore_rounded
                          : (unlocked
                              ? Icons.hourglass_empty_rounded
                              : Icons.lock_rounded),
                      size: 18,
                      color: Colors.white,
                    ),
                    height: 44,
                    fontSize: 14.5,
                    isFullWidth: true,
                    backgroundColor: active ? AppColors.primary : Colors.grey.shade400,
                    shadowColor: active ? AppColors.primaryDark : Colors.grey.shade600,
                    onPressed: active ? onTap : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildCountryFlagBadge() {
    if (country.id == 'vn') {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFDA251D),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.95), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.star_rounded,
            color: Color(0xFFFFEB3B),
            size: 20,
          ),
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.95), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          country.flagEmoji,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
