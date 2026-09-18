import 'package:flutter/material.dart';

enum DecorationType { frame, banner }

class ProfileDecorationItem {
  final String id;
  final String name;
  final DecorationType type;
  final int price;
  final String description;
  final List<Color> gradientColors;
  final IconData icon;
  final double borderWidth;
  final bool hasGlow;

  const ProfileDecorationItem({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.description,
    required this.gradientColors,
    required this.icon,
    this.borderWidth = 3.5,
    this.hasGlow = false,
  });
}

class MockProfileDecorations {
  static const List<ProfileDecorationItem> items = [
    // -------------------------------------------------------------
    // KHUNG ĐẠI DIỆN (AVATAR FRAMES)
    // -------------------------------------------------------------
    ProfileDecorationItem(
      id: 'frame_default',
      name: 'Viền Đồng Cổ',
      type: DecorationType.frame,
      price: 0,
      description: 'Khung viền đồng mộc mạc thuở ban đầu gia nhập HistoQuest.',
      gradientColors: [Color(0xFFC5A059), Color(0xFF8C6D3B)],
      icon: Icons.circle_outlined,
      borderWidth: 3.0,
    ),
    ProfileDecorationItem(
      id: 'frame_dragon',
      name: 'Rồng Thời Lý',
      type: DecorationType.frame,
      price: 350,
      description: 'Họa tiết rồng uốn lượn mềm mại thời Lý dát vàng ánh kim rực rỡ.',
      gradientColors: [Color(0xFFFFD700), Color(0xFFFFA000), Color(0xFFB8860B)],
      icon: Icons.auto_awesome_rounded,
      borderWidth: 4.5,
      hasGlow: true,
    ),
    ProfileDecorationItem(
      id: 'frame_general',
      name: 'Mũ Giáp Tướng Quân',
      type: DecorationType.frame,
      price: 500,
      description: 'Uy lực dũng tướng sa trường với sắc đỏ thắm khí phách kiên cường.',
      gradientColors: [Color(0xFFE53935), Color(0xFF8E0000), Color(0xFFD32F2F)],
      icon: Icons.shield_rounded,
      borderWidth: 4.0,
      hasGlow: true,
    ),
    ProfileDecorationItem(
      id: 'frame_lotus',
      name: 'Sen Hồng Thanh Khiết',
      type: DecorationType.frame,
      price: 600,
      description: 'Quốc hoa thanh tao mang vẻ đẹp trang nhã của văn hóa truyền thống.',
      gradientColors: [Color(0xFFFF80AB), Color(0xFFE040FB), Color(0xFF7B1FA2)],
      icon: Icons.spa_rounded,
      borderWidth: 4.0,
      hasGlow: true,
    ),
    ProfileDecorationItem(
      id: 'frame_imperial',
      name: 'Vương Triều Hoàng Gia',
      type: DecorationType.frame,
      price: 1000,
      description: 'Khung viền tối cao dành riêng cho bậc hiền tài đỗ đạt khoa cử.',
      gradientColors: [Color(0xFFFFE082), Color(0xFFFFB300), Color(0xFFFF6F00), Color(0xFFD50000)],
      icon: Icons.military_tech_rounded,
      borderWidth: 5.0,
      hasGlow: true,
    ),

    // -------------------------------------------------------------
    // ẢNH BÌA PROFILE (PROFILE BANNERS)
    // -------------------------------------------------------------
    ProfileDecorationItem(
      id: 'banner_default',
      name: 'Bản Đồ Cổ Đại Việt',
      type: DecorationType.banner,
      price: 0,
      description: 'Họa tiết nền giấy gió cổ điển cùng hải trình sông núi ngàn năm.',
      gradientColors: [Color(0xFF3E2F23), Color(0xFF241C15)],
      icon: Icons.map_rounded,
    ),
    ProfileDecorationItem(
      id: 'banner_bach_dang',
      name: 'Sóng Nước Bạch Đằng',
      type: DecorationType.banner,
      price: 450,
      description: 'Sóng cuộn trùng điệp gợi nhắc chiến tích cọc gỗ lẫy lừng non sông.',
      gradientColors: [Color(0xFF0F3057), Color(0xFF00587A), Color(0xFF008891)],
      icon: Icons.waves_rounded,
    ),
    ProfileDecorationItem(
      id: 'banner_thang_long',
      name: 'Kinh Thành Thăng Long',
      type: DecorationType.banner,
      price: 700,
      description: 'Bình minh rực rỡ trên cổng thành Thăng Long trầm mặc cổ kính.',
      gradientColors: [Color(0xFF5D4037), Color(0xFF795548), Color(0xFF3E2723)],
      icon: Icons.fort_rounded,
    ),
    ProfileDecorationItem(
      id: 'banner_hue',
      name: 'Đêm Huyền Ảo Cố Đô',
      type: DecorationType.banner,
      price: 900,
      description: 'Ánh trăng soi bóng dòng Hương Giang cùng cung điện nguy nga tráng lệ.',
      gradientColors: [Color(0xFF311B92), Color(0xFF4A148C), Color(0xFF1A237E)],
      icon: Icons.nights_stay_rounded,
    ),
  ];

  static ProfileDecorationItem getFrame(String id) {
    return items.firstWhere(
      (item) => item.id == id && item.type == DecorationType.frame,
      orElse: () => items.first,
    );
  }

  static ProfileDecorationItem getBanner(String id) {
    return items.firstWhere(
      (item) => item.id == id && item.type == DecorationType.banner,
      orElse: () => items.firstWhere((item) => item.type == DecorationType.banner),
    );
  }
}
