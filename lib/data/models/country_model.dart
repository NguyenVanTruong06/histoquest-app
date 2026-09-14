import 'package:flutter/material.dart';

/// Model đại diện cho một quốc gia / nền văn minh mà người chơi có thể
/// chọn để bắt đầu hành trình khám phá lịch sử.
class CountryModel {
  final String id;
  final String name;
  final String subtitle;
  final String flagEmoji;
  final IconData icon;
  final Color accentColor;
  final bool hasContent;

  const CountryModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.flagEmoji,
    required this.icon,
    required this.accentColor,
    this.hasContent = true,
  });
}
