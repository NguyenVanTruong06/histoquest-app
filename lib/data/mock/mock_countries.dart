import 'package:flutter/material.dart';

import '../models/country_model.dart';
import '../models/era_model.dart';

/// Danh sách các quốc gia / nền văn minh có thể chọn (mock).
///
/// Cơ chế mở khóa: mỗi nền văn minh (trừ Việt Nam — nền văn minh khởi
/// đầu) chỉ mở khóa sau khi người chơi đạt đủ số mốc lịch sử yêu cầu ở
/// nền văn minh tiên quyết. Ví dụ: đạt mốc thứ 7 của Việt Nam sẽ mở khóa
/// Trung Quốc.
final List<CountryModel> kMockCountries = [
  const CountryModel(
    id: 'vn',
    name: 'Việt Nam',
    subtitle: 'Rồng tiên · 4000 năm dựng nước và giữ nước',
    flagEmoji: '🇻🇳',
    icon: Icons.temple_buddhist_rounded,
    accentColor: Color(0xFF85B9D1),
    hasContent: true,
    assetImagePath: 'assets/images/countries/vn.jpg',
  ),
  const CountryModel(
    id: 'cn',
    name: 'Trung Quốc',
    subtitle: 'Vạn Lý Trường Thành · Các triều đại phong kiến',
    flagEmoji: '🇨🇳',
    icon: Icons.account_balance_rounded,
    accentColor: Color(0xFFC94747),
    hasContent: false,
    assetImagePath: 'assets/images/countries/cn.jpg',
    requiresCountryId: 'vn',
    requiresMilestoneCount: 7,
    unlockHint:
        'Mở khóa khi bạn đạt mốc lịch sử thứ 7 của nền văn minh Việt Nam.',
  ),
  const CountryModel(
    id: 'eg',
    name: 'Ai Cập',
    subtitle: 'Kim tự tháp · Nền văn minh sông Nile cổ đại',
    flagEmoji: '🇪🇬',
    icon: Icons.change_history_rounded,
    accentColor: Color(0xFFE4A93A),
    hasContent: false,
    assetImagePath: 'assets/images/countries/eg.jpg',
    requiresCountryId: 'cn',
    requiresMilestoneCount: 5,
    unlockHint:
        'Mở khóa khi bạn đạt mốc lịch sử thứ 5 của nền văn minh Trung Quốc.',
  ),
];

/// Tổng số mốc lịch sử (sự kiện) đã hoàn thành ở một nền văn minh.
int calculateCompletedMilestones(List<EraModel> eras, String countryId) {
  return eras
      .where((e) => e.countryId == countryId)
      .expand((e) => e.events)
      .where((ev) => ev.isCompleted)
      .length;
}

/// Kiểm tra xem nền văn minh [country] đã được mở khóa hay chưa.
bool checkCountryUnlocked(List<EraModel> eras, CountryModel country) {
  final requiredId = country.requiresCountryId;
  if (requiredId == null) return true;
  final required = country.requiresMilestoneCount ?? 0;
  return calculateCompletedMilestones(eras, requiredId) >= required;
}
