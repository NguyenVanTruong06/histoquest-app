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

  /// Đường dẫn asset ảnh banner 16:9 hiển thị trên thẻ chọn nền văn minh
  /// (Bước 1 của tab Bản đồ). `null` nghĩa là chưa có ảnh — UI sẽ tự
  /// dùng gradient [accentColor] kết hợp [icon] để thay thế.
  final String? assetImagePath;

  /// Id của nền văn minh cần chinh phục trước để mở khóa nền văn minh này.
  /// `null` nghĩa là không có điều kiện tiên quyết (mở sẵn ngay từ đầu).
  final String? requiresCountryId;

  /// Số mốc lịch sử (sự kiện) cần hoàn thành ở [requiresCountryId] để mở
  /// khóa nền văn minh này. Chỉ có ý nghĩa khi [requiresCountryId] != null.
  final int? requiresMilestoneCount;

  /// Lời giải thích cơ chế mở khóa, hiển thị trên thẻ khi nền văn minh còn
  /// đang khóa (vd: "Mở khóa khi đạt mốc thứ 7 của nền văn minh Việt Nam").
  final String? unlockHint;

  const CountryModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.flagEmoji,
    required this.icon,
    required this.accentColor,
    this.hasContent = true,
    this.assetImagePath,
    this.requiresCountryId,
    this.requiresMilestoneCount,
    this.unlockHint,
  });
}
