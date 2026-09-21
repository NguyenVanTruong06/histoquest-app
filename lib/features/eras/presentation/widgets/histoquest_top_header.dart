import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Header HistoQuest thiết kế thanh thoát, màu nền trùng với background:
/// - Chế độ Thời kỳ (isEraMode == true):
///   + Nền header trùng màu hoàn toàn với background (không dải màu đứt gãy, không đổ bóng).
///   + Bỏ hoàn toàn xu và chuỗi ngày.
///   + Góc trái: Mũi tên thoát về (nút tròn viền mảnh, icon mũi tên tối màu).
///   + Ở giữa: Tên nước (căn giữa, font chữ tinh tế, thanh lịch).
///   + Góc phải: Lá cờ quốc gia (cờ đỏ sao vàng bo góc mềm mại).
/// - Chế độ Chuẩn (Bảng vàng, Trò chơi, Bản tin, Bản đồ tổng):
///   + Nền trùng màu background (AppColors.background).
///   + Tiêu đề chữ màu than đậm (AppColors.textPrimary).
///   + Bộ đôi pill Xu vàng & Chuỗi ngày streak nền trắng bo góc nhẹ nhàng.
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
    // 1. Chế độ Thời kỳ (isEraMode): Chuẩn pixel theo hình mẫu của người dùng
    // -------------------------------------------------------------------------
    if (isEraMode) {
      final effectiveBg = backgroundColor ?? AppColors.background;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 7, bottom: 10, left: 16, right: 16),
        color: effectiveBg,
        child: Row(
          children: [
            // Góc trái: Mũi tên thoát về (Nút tròn viền mảnh)
            if (onBack != null)
              _buildCircularBackButton()
            else
              const SizedBox(width: 40),

            // Ở giữa: Tên nước (căn giữa, kích thước chữ thanh lịch ~14.5)
            Expanded(
              child: Text(
                (countryName ?? 'VIỆT NAM').toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C2A29),
                  letterSpacing: 0.8,
                ),
              ),
            ),

            // Góc phải: Cờ nước (hình chữ nhật bo góc đỏ sao vàng)
            _buildCountryFlag(countryFlagEmoji),
          ],
        ),
      );
    }

    // -------------------------------------------------------------------------
    // 2. Chế độ Tiêu chuẩn (Tab chính: Bảng vàng, Trò chơi, Tin tức):
    //    Nền trùng màu với background, chữ màu than đậm, không đổ bóng thô.
    // -------------------------------------------------------------------------
    final effectiveBg = backgroundColor ?? AppColors.background;
    final shouldShowStats = showStats ?? true;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 6,
        bottom: 10,
        left: 16,
        right: 16,
      ),
      color: effectiveBg,
      child: Row(
        children: [
          // Nút Back nếu có
          if (onBack != null) ...[
            _buildCircularBackButton(),
            const SizedBox(width: 10),
          ],

          // Tiêu đề màn hình
          Text(
            title ?? 'Histoquest',
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
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

          if (extraAction != null) ...[const SizedBox(width: 8), extraAction!],
        ],
      ),
    );
  }

  Widget _buildCircularBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onBack,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF8C867A).withValues(alpha: 0.35),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF2C2A28),
              size: 21,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryFlag(String? emoji) {
    final isVn =
        countryName == null || countryName!.toLowerCase().contains('việt');
    if (isVn) {
      return Container(
        width: 32,
        height: 24,
        decoration: BoxDecoration(
          color: const Color(0xFFDA251D),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.star_rounded, color: Color(0xFFFFEB3B), size: 15),
        ),
      );
    }

    if (emoji != null && emoji.isNotEmpty) {
      return Container(
        width: 32,
        height: 24,
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 22)),
      );
    }

    return const SizedBox(width: 32, height: 24);
  }

  Widget _buildPill({required Widget icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2D9CB), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
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
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
