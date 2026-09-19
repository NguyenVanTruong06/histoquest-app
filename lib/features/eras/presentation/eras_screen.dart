import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/country_model.dart';
import '../../../data/models/period_item.dart';
import '../../../data/models/user_model.dart';
import '../../../data/mock_data.dart';
import 'widgets/beanstalk_pathway_painter.dart';
import 'widgets/country_page_card.dart';
import 'widgets/histoquest_top_header.dart';
import 'widgets/timeline_card.dart';

/// Màn hình gốc của tab "Bản đồ" (HistoQuest).
///
/// Thiết kế chuyên gia Flutter UI/UX phong cách gamification/phiêu lưu lịch sử:
/// - Màn 1: "Chọn nền văn minh" — Danh sách thẻ dọc với tranh phong cảnh
///   đồi cỏ xanh ngát, mây trời trong trẻo, huy hiệu cờ đỏ sao vàng.
/// - Màn 2: "Chọn Thời Kì" — Trục Dây Leo (Beanstalk Pathway) trải dọc
///   chính giữa màn hình, dùng SingleChildScrollView bọc Stack, các thẻ
///   thời kỳ (TimelineCard) sắp xếp so le sinh động, tích hợp chi tiết lá bám
///   và badge '★ Đang chọn'.
class ErasScreen extends StatefulWidget {
  const ErasScreen({super.key});

  @override
  State<ErasScreen> createState() => _ErasScreenState();
}

class _ErasScreenState extends State<ErasScreen> {
  final UserModel _user = MockData.currentUser;
  final List<CountryModel> _countries = MockData.countries;

  /// Nền văn minh đang được xem trong tab này. `null` = đang ở bước chọn nền văn minh.
  String? _activeCountryId;

  /// ID thời kỳ đang được chọn trên dòng thời gian dây leo
  String _selectedPeriodId = 'era_1';

  // 4 thời kỳ mẫu (Mock Data) theo yêu cầu chuẩn gamification
  final List<PeriodItem> _samplePeriods = const [
    PeriodItem(
      id: 'era_1',
      title: 'Thời kì Tiền Sử',
      subtitle: 'Khoảng 500.000 năm - 2879 TCN',
      imageUrl: 'assets/images/eras/prehistoric_cave_art.jpg',
      isSelected: true,
    ),
    PeriodItem(
      id: 'era_ly_tran',
      title: 'Thời kì Lý - Trần',
      subtitle: 'Năm 1009 - 1400',
      imageUrl: 'assets/images/eras/dong_son_art.jpg',
      isSelected: false,
    ),
    PeriodItem(
      id: 'era_khang_chien',
      title: 'Thời kì Kháng Chiến',
      subtitle: 'Năm 1945 - 1975',
      imageUrl: 'assets/images/countries/vn.jpg',
      isSelected: false,
    ),
    PeriodItem(
      id: 'era_hien_dai',
      title: 'Thời kỳ Hiện Đại',
      subtitle: 'Năm 1975 - Nay',
      imageUrl: 'assets/images/countries/vn.jpg',
      isSelected: false,
    ),
  ];

  CountryModel? get _activeCountry {
    if (_activeCountryId == null) return null;
    for (final c in _countries) {
      if (c.id == _activeCountryId) return c;
    }
    return null;
  }

  void _selectCountry(CountryModel country) {
    final unlocked = MockData.isCountryUnlocked(country);
    if (!unlocked) {
      final requiredId = country.requiresCountryId;
      final required = country.requiresMilestoneCount ?? 0;
      final done = requiredId == null
          ? 0
          : MockData.completedMilestonesForCountry(requiredId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            country.unlockHint ??
                'Nền văn minh ${country.name} đang khóa ($done/$required mốc).',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (!country.hasContent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nội dung ${country.name} đang được cập nhật, quay lại sau nhé!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    setState(() {
      _activeCountryId = country.id;
      MockData.selectedCountryId = country.id;
    });
  }

  void _backToCountrySelect() {
    setState(() => _activeCountryId = null);
  }

  @override
  Widget build(BuildContext context) {
    final activeCountry = _activeCountry;
    // Bố cục & Cấu trúc chính: Background màu be nhạt theo yêu cầu
    const backgroundColor = Color(0xFFF3F0E6);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // 2. Thanh AppBar / Header tùy biến
          HistoquestTopHeader(
            isEraMode: activeCountry != null,
            countryName: activeCountry?.name,
            countryFlagEmoji: activeCountry?.flagEmoji,
            onBack: activeCountry != null ? _backToCountrySelect : null,
            backgroundColor: activeCountry != null ? backgroundColor : null,
            coins: _user.coins,
            streakDays: _user.streakDays,
          ),

          // Thân màn hình theo từng bước
          Expanded(
            child: activeCountry == null
                ? _buildCountrySelectBody()
                : _buildErasBody(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Bước 1: Chọn nền văn minh (Screen 1)
  // ---------------------------------------------------------------------
  Widget _buildCountrySelectBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chọn nền văn minh',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Vuốt dọc theo dây leo để chọn một thời kì muốn khám phá',
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
            itemCount: _countries.length,
            itemBuilder: (context, index) {
              final country = _countries[index];
              final unlocked = MockData.isCountryUnlocked(country);
              final requiredId = country.requiresCountryId;
              final requiredCount = country.requiresMilestoneCount ?? 0;
              final doneCount = requiredId == null
                  ? 0
                  : MockData.completedMilestonesForCountry(requiredId);
              final active = unlocked && country.hasContent;

              return CountryPageCard(
                country: country,
                unlocked: unlocked,
                active: active,
                doneCount: doneCount,
                requiredCount: requiredCount,
                onTap: () => _selectCountry(country),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Bước 2: Chọn Thời Kì (SingleChildScrollView + Stack + BeanstalkPathway)
  // ---------------------------------------------------------------------
  Widget _buildErasBody() {
    // Cập nhật trạng thái isSelected cho danh sách thời kỳ mẫu
    final periods = _samplePeriods.map((p) {
      return p.copyWith(isSelected: p.id == _selectedPeriodId);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề & Phụ đề ngay dưới Header
        const Padding(
          padding: EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chọn Thời Kì',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Vuốt dọc theo dây leo để chọn một thời kì muốn khám phá',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Color(0xFF75746E),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        // 1 & 3. Thân trang: SingleChildScrollView bọc một Stack
        // để tạo hiệu ứng trục dây leo nằm sau và các card nằm đè lên trên
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                // 3. Trục dây leo (Beanstalk Pathway) trải dài dọc chính giữa
                Positioned.fill(
                  child: CustomPaint(
                    painter: BeanstalkPathwayPainter(
                      itemCount: periods.length,
                    ),
                  ),
                ),

                // 4. Các thẻ thời kỳ (TimelineCard) sắp xếp so le trái / phải dọc trục
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 36.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < periods.length; i++) ...[
                        // Sắp xếp so le trái / phải rõ nét theo đường cong của thân cây
                        Align(
                          alignment: i % 2 == 0
                              ? const Alignment(-0.24, 0)
                              : const Alignment(0.24, 0),
                          child: TimelineCard(
                            item: periods[i],
                            onTap: () {
                              setState(() {
                                _selectedPeriodId = periods[i].id;
                              });
                            },
                            onEnterMap: () {
                              // Điều hướng vào bản đồ sự kiện
                              context.push('/eras/era_1');
                            },
                          ),
                        ),
                        // Khoảng cách thoáng đãng giữa các thời kỳ để khoe trọn vẻ đẹp của cây đậu thần
                        if (i < periods.length - 1) const SizedBox(height: 85),
                      ],
                      const SizedBox(height: 64),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
