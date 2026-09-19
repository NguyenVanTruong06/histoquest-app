import 'package:flutter/material.dart';

/// Bảng màu chính xác trích xuất từ thiết kế HistoQuest (HistoQuest.html)
class AppColors {
  // Màu thương hiệu chính: Xanh pastel #85B9D1
  static const Color primary = Color(0xFF85B9D1);
  static const Color primaryDark = Color(0xFF5A9BB9); // Viền đáy 3D của nút
  static const Color primaryLight = Color(0xFFEFF7FA); // Nền badge đang học

  // Màu phụ / Vàng kim cổ điển (Coin, Cúp vàng, Sao)
  static const Color gold = Color(0xFFE4A93A);
  static const Color goldDark = Color(0xFF8A5D12);
  static const Color goldLight = Color(0xFFFBF3E2);

  // Màu chỉ số Gamification (XP, Xu, Streak)
  static const Color xpColor = Color(0xFF7C3AED); // Tím XP
  static const Color xpBg = Color(0xFFEDE9FE);

  static const Color coinColor = Color(0xFFE4A93A); // Vàng kim xu
  static const Color coinBg = Color(0xFFFBF3E2);

  static const Color streakColor = Color(0xFFD95D39); // Đỏ cam lửa streak
  static const Color streakBg = Color(0xFFFDEDE7);

  // Nền ứng dụng đồng điệu màu chủ đạo (#E3F6FF) & bề mặt
  static const Color background = Color(0xFFE3F6FF); // Nền xanh pastel dịu mát
  static const Color surface = Colors.white;
  static const Color cardBorder = Color(0xFFCDE8F5); // Viền thẻ
  static const Color cardBorderActive = Color(0xFF85B9D1); // Viền thẻ đang học

  // Nền tối (Appbar cổ kính / Dark Coffee)
  static const Color darkBackground = Color(0xFF2A241F);
  static const Color darkSurface = Color(0xFF382810);

  // Màu chữ (Typography)
  static const Color textPrimary = Color(0xFF25221F);
  static const Color textSecondary = Color(0xFF6E675D);
  static const Color textMuted = Color(0xFF9E9589);

  // Trạng thái (Status)
  static const Color success = Color(0xFF2E8B57); // Xanh hoàn thành
  static const Color danger = Color(0xFFC94747); // Đỏ cảnh báo
  static const Color warning = Color(0xFFE4A93A);
  static const Color info = Color(0xFF3B82F6);

  // Thẻ thời kỳ đang khóa (Locked Card State)
  static const Color lockedCardBg = Color(0xFFEAE5DA);
  static const Color lockedCardBorder = Color(0xFFD3CBBB);
  static const Color lockedTitle = Color(0xFF8C857B);
  static const Color lockedSubtitle = Color(0xFFA8A196);

  // Hiệu ứng phát sáng & lấp lánh (Glow & Sparkle)
  static const List<Color> glowGradient = [
    Color(0xFFFFD54F),
    Color(0xFFFF8A65),
    Color(0xFFFFD54F),
  ];
  static const Color sparkleGold = Color(0xFFFFD54F);
  static const Color sparkleBlue = Color(0xFF81D4FA);
  static const Color sparklePink = Color(0xFFF48FB1);
}
