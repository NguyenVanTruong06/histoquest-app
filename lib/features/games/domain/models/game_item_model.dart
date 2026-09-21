import 'package:flutter/material.dart';

/// Dữ liệu mô tả một trò chơi lịch sử trong sảnh Kỳ Đài (Dạng App Icon 4x4)
class GameItemModel {
  final String id;
  final String title;
  final String shortName;
  final String category;
  final IconData icon;
  final List<Color> gradientColors;
  final String? badge; // 'HOT', 'MỚI', '1v1', 'SẮP CÓ'...
  final bool isPlayable;
  final bool isLandscape; // Yêu cầu xoay ngang màn hình
  final String howToPlay;
  final String gameMode;
  final String duration;
  final String difficulty;
  final int coinReward;
  final int xpReward;
  final String itemReward;
  final Widget Function(BuildContext context)? screenBuilder;

  const GameItemModel({
    required this.id,
    required this.title,
    required this.shortName,
    required this.category,
    required this.icon,
    required this.gradientColors,
    this.badge,
    this.isPlayable = false,
    this.isLandscape = false,
    required this.howToPlay,
    required this.gameMode,
    required this.duration,
    required this.difficulty,
    required this.coinReward,
    required this.xpReward,
    required this.itemReward,
    this.screenBuilder,
  });
}
