import 'package:flutter/material.dart';

/// Bảng màu chính xác trích xuất từ thiết kế HistoQuest (HistoQuest.html)
class AppColors {
  // Màu thương hiệu chính: Đỏ gạch nung / Terracotta lịch sử
  static const Color primary = Color(0xFFD95D39);
  static const Color primaryDark = Color(0xFFA53B20); // Viền đáy 3D của nút
  static const Color primaryLight = Color(0xFFFDEDE7); // Nền badge đang học

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

  // Nền giấy thời gian cổ kính (Parchment) & bề mặt
  static const Color background = Color(0xFFF7F2E8); // Nền giấy ngà ấm áp
  static const Color surface = Colors.white;
  static const Color cardBorder = Color(0xFFDED4C4); // Viền thẻ
  static const Color cardBorderActive = Color(0xFFD95D39); // Viền thẻ đang học

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
}
