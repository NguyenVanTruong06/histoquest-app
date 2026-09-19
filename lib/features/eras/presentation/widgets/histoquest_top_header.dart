import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Header HistoQuest hỗ trợ linh hoạt cho các màn hình trong ứng dụng:
/// - Chế độ chuẩn / Tab chính: Header phẳng tông màu đỏ gạch thương hiệu (AppColors.primary)
///   hoặc nền tùy biến với tiêu đề và pill xu/streak.
/// - Chế độ Thời kỳ (isEraMode == true):
///   + Nền header trùng màu hoàn toàn với background (không bóng đen đứt gãy).
///   + Bỏ hoàn toàn xu và chuỗi ngày.
///   + Góc trái: Mũi tên thoát về (Back button).
///   + Ở giữa: Tên nước (căn giữa tuyệt đối).
///   + Góc phải: Cờ nước (cờ đỏ sao vàng hoặc emoji cờ).
class HistoquestTopHeader extends StatelessWidget {
  final bool isEraMode;
  final String? title;
  final String? countryName;
  final String? countryFlagEmoji;
  final VoidCallback? onBack;
  final int coins;
  final int streakDays;
  final Widget? extraAction;
  final Color? backgroundColor;
  final bool? showStats;

  const HistoquestTopHeader({
    super.key,
    this.isEraMode = false,
    this.title,
    this.countryName,
    this.countryFlagEmoji,
    this.onBack,
    this.coins = 36,
    this.streakDays = 36,
    this.extraAction,
    this.backgroundColor,
    this.showStats,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    // -------------------------------------------------------------------------
    // 1. Chế độ Thời kỳ (isEraMode): Nền trùng background, bỏ xu/streak,
    //    chỉ còn: mũi tên góc trái, tên nước ở giữa, cờ ở góc phải.
    // -------------------------------------------------------------------------
    if (isEraMode) {
      final effectiveBg = backgroundColor ?? const Color(0xFFF3F0E6);

      return Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: topPadding + 6,
          bottom: 8,
          left: 16,
          right: 16,
        ),
        color: effectiveBg,
        child: Row(
          children: [
            // Góc trái: Nút mũi tên thoát về
            if (onBack != null)
              _buildCircularBackButton(isLightBg: true)
            else
              const SizedBox(width: 38),

            // Ở giữa: Tên nước (căn giữa)
            Expanded(
              child: Text(
                (countryName ?? 'VIỆT NAM').toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // Góc phải: Cờ nước
            _buildCountryFlag(countryFlagEmoji, width: 38, height: 26),
          ],
        ),
      );
    }

    // -------------------------------------------------------------------------
    // 2. Chế độ Tiêu chuẩn (Tab chính, Bảng vàng, Trò chơi, Tin tức):
    //    Header phẳng thương hiệu với title và bộ đôi pill Xu & Streak.
    // -------------------------------------------------------------------------
    final effectiveBg = backgroundColor ?? AppColors.primary;
    final shouldShowStats = showStats ?? true;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 6,
        bottom: 11,
        left: 14,
        right: 14,
      ),
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.zero,
        boxShadow: effectiveBg == Colors.transparent
            ? []
            : const [
                BoxShadow(
                  color: Color(0x28000000),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
      ),
      child: Row(
        children: [
          // Nút Back nếu có
          if (onBack != null) ...[
            _buildCircularBackButton(isLightBg: effectiveBg != AppColors.primary),
            const SizedBox(width: 8),
          ],

          // Tiêu đề màn hình
          Text(
            title ?? 'Histoquest',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: effectiveBg == AppColors.primary ? Colors.white : AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),

          const Spacer(),

          // Pill xu vàng và chuỗi ngày
          if (shouldShowStats) ...[
            _buildPill(
              icon: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3B438),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.monetization_on_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
              label: '${coins.toString().padLeft(3, '0')} xu',
            ),
            const SizedBox(width: 8),
            _buildPill(
              icon: const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFF5A1F),
                size: 18,
              ),
              label: '$streakDays ngày',
            ),
          ],

          if (extraAction != null) ...[
            const SizedBox(width: 8),
            extraAction!,
          ],
        ],
      ),
    );
  }

  Widget _buildCircularBackButton({bool isLightBg = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onBack,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isLightBg ? Colors.white : Colors.white.withValues(alpha: 0.22),
            shape: BoxShape.circle,
            border: Border.all(
              color: isLightBg ? const Color(0xFFDED4C4) : Colors.white.withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isLightBg ? 0.06 : 0.12),
                blurRadius: 4,
                offset: const Offset(0, 1.5),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: isLightBg ? AppColors.textPrimary : Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCountryFlag(String? emoji, {double width = 38, double height = 26}) {
    final isVn = countryName == null || countryName!.toLowerCase().contains('việt');
    if (isVn) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFDA251D),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 3,
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.star_rounded,
            color: Color(0xFFFFEB3B),
            size: 16,
          ),
        ),
      );
    }

    if (emoji != null && emoji.isNotEmpty) {
      return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 22),
        ),
      );
    }

    return SizedBox(width: width, height: height);
  }

  Widget _buildPill({required Widget icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
