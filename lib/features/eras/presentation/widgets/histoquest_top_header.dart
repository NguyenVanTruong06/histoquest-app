import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Header HistoQuest phẳng (không bo tròn góc đáy) với tông màu chủ đạo thương hiệu (AppColors.primary).
///
/// Hỗ trợ linh hoạt cho tất cả các màn hình trong ứng dụng:
/// - Chế độ chuẩn / Tab chính: Hiển thị [title] ("Histoquest", "Bảng Vàng", "Trò Chơi Dân Gian", "Bản Tin Sử Việt").
/// - Chế độ quay lại (nếu có [onBack]): Nút tròn Back màu trắng mờ.
/// - Chế độ Thời kỳ ([isEraMode] == true): Badge cờ đỏ sao vàng + tên quốc gia VIỆT NAM dạng viên thuốc.
/// - Phía bên phải: Bộ đôi pill trắng viên thuốc bo tròn (`BorderRadius.circular(20)`) hiển thị số xu vàng và chuỗi ngày streak.
class HistoquestTopHeader extends StatelessWidget {
  final bool isEraMode;
  final String? title;
  final String? countryName;
  final String? countryFlagEmoji;
  final VoidCallback? onBack;
  final int coins;
  final int streakDays;
  final Widget? extraAction;

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
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 6,
        bottom: 11,
        left: 14,
        right: 14,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        // Header phẳng mép đáy, KHÔNG bo tròn theo thiết kế chuẩn
        borderRadius: BorderRadius.zero,
        boxShadow: [
          BoxShadow(
            color: Color(0x28000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Nút Back (nếu có onBack và không ở mode era)
          if (onBack != null && !isEraMode) ...[
            _buildCircularBackButton(),
            const SizedBox(width: 8),
          ],

          // 2. Nội dung bên trái
          if (isEraMode) ...[
            // Nút Back tròn
            _buildCircularBackButton(),
            const SizedBox(width: 8),

            // Badge quốc gia viên thuốc trắng
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(20),
                child: _buildPill(
                  icon: _buildVietnamFlagBadge(),
                  label: (countryName ?? 'VIỆT NAM').toUpperCase(),
                ),
              ),
            ),
          ] else ...[
            // Tiêu đề màn hình
            Text(
              title ?? 'Histoquest',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ],

          const Spacer(),

          // 3. Pill xu vàng
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

          // 4. Pill chuỗi ngày (ngọn lửa)
          _buildPill(
            icon: const Icon(
              Icons.local_fire_department_rounded,
              color: Color(0xFFFF5A1F),
              size: 18,
            ),
            label: '$streakDays ngày',
          ),

          if (extraAction != null) ...[
            const SizedBox(width: 8),
            extraAction!,
          ],
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
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.22),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildVietnamFlagBadge() {
    return Container(
      width: 24,
      height: 16,
      decoration: BoxDecoration(
        color: const Color(0xFFDA251D),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.star_rounded,
          color: Color(0xFFFFEB3B),
          size: 12,
        ),
      ),
    );
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
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C2F28),
            ),
          ),
        ],
      ),
    );
  }
}
