import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/era_model.dart';

/// Một item trong PageView dọc chọn thời kỳ (Bước 2 của tab Bản đồ).
///
/// Vòng tròn trung tâm hiển thị icon + tên thời kỳ + khoảng năm; item mang
/// theo 2 đoạn nối (trên/dưới) để khi nhiều item xếp cạnh nhau trong
/// viewport tạo thành một đường kẻ dọc xuyên suốt. Hiệu ứng scale/opacity/
/// blur theo khoảng cách tới trang trung tâm được điều khiển từ bên ngoài
/// (`ErasScreen`) thông qua `AnimatedBuilder` bọc widget này.
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

    return GestureDetector(
      onTap: isUnlocked ? onTap : onLockedTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 175,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Đường kẻ dọc xuyên suốt: đoạn nối trên + dưới vòng tròn.
            Positioned.fill(
              child: CustomPaint(
                painter: _VerticalConnectorPainter(
                  color: isUnlocked ? AppColors.gold : const Color(0xFFD8D2C4),
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircle(isUnlocked, isCenter),
                const SizedBox(height: 10),
                Text(
                  era.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isCenter ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? AppColors.textPrimary : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  era.timelineSpan,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnlocked ? AppColors.textSecondary : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(bool isUnlocked, bool isCenter) {
    final size = isCenter ? 92.0 : 76.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isUnlocked
            ? LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
        border: Border.all(
          color: isUnlocked ? Colors.white : Colors.grey.shade200,
          width: isCenter ? 4 : 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (isUnlocked ? AppColors.primary : Colors.grey).withValues(alpha: 0.3),
            blurRadius: isCenter ? 18 : 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        isUnlocked ? Icons.account_balance_rounded : Icons.lock_rounded,
        color: Colors.white,
        size: isCenter ? 36 : 28,
      ),
    );
  }
}

class _VerticalConnectorPainter extends CustomPainter {
  final Color color;

  _VerticalConnectorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final cx = size.width / 2;
    // Đoạn nối trên (từ mép trên item tới sát vòng tròn)
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height * 0.30), paint);
    // Đoạn nối dưới (từ sát vòng tròn tới mép dưới item)
    canvas.drawLine(Offset(cx, size.height * 0.70), Offset(cx, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _VerticalConnectorPainter oldDelegate) =>
      oldDelegate.color != color;
}
