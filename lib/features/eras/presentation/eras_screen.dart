import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/country_model.dart';
import '../../../data/models/era_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/mock_data.dart';
import 'widgets/country_page_card.dart';
import 'widgets/era_vertical_item.dart';

/// Màn hình gốc của tab "Bản đồ" (branch đầu tiên trong shell chính).
///
/// Luồng chơi 3 bước liên tiếp:
///   Bước 1 — PageView ngang snap từng thẻ chọn nền văn minh.
///   Bước 2 — PageView dọc chọn thời kỳ, item trung tâm phóng to/nét, các
///            item lân cận thu nhỏ/mờ/blur dần theo khoảng cách.
///   Bước 3 — Bản đồ Kingdom Rush dọc (xem `EraEventsMapScreen`).
///
/// Cơ chế mở khóa nền văn minh: mỗi nền văn minh (trừ nền văn minh khởi đầu)
/// yêu cầu người chơi đạt một số mốc lịch sử nhất định ở nền văn minh tiên
/// quyết (xem [CountryModel.requiresCountryId] /
/// [CountryModel.requiresMilestoneCount] và [MockData.isCountryUnlocked]).
/// Khi còn khóa, thẻ nền văn minh hiển thị luôn lời giải thích cơ chế này.
class ErasScreen extends StatefulWidget {
  const ErasScreen({super.key});

  @override
  State<ErasScreen> createState() => _ErasScreenState();
}

class _ErasScreenState extends State<ErasScreen> {
  final UserModel _user = MockData.currentUser;
  final List<CountryModel> _countries = MockData.countries;

  /// Nền văn minh đang được xem trong tab này. `null` = đang ở bước chọn nền
  /// văn minh (bước đầu tiên của tab Bản đồ). Được giữ nguyên khi chuyển
  /// qua lại giữa các tab khác trong phiên chơi (nhờ IndexedStack của
  /// StatefulShellRoute), chỉ reset khi mở lại app.
  String? _activeCountryId;

  late final PageController _countryPageController =
      PageController(viewportFraction: 0.88);
  late final PageController _eraPageController =
      PageController(viewportFraction: 0.62);

  @override
  void dispose() {
    _countryPageController.dispose();
    _eraPageController.dispose();
    super.dispose();
  }

  List<EraModel> get _eras => MockData.eras
      .where((e) => e.countryId == _activeCountryId)
      .toList();

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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        titleSpacing: 16,
        leading: activeCountry == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                tooltip: 'Đổi nền văn minh',
                onPressed: _backToCountrySelect,
              ),
        automaticallyImplyLeading: activeCountry != null,
        title: Text(
          activeCountry == null ? 'HistoQuest' : '${activeCountry.flagEmoji}  ${activeCountry.name}',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5DFC9)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on_rounded,
                    color: AppColors.gold,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_user.coins}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.deepOrange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_user.streakDays}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: activeCountry == null ? _buildCountrySelectBody() : _buildErasBody(),
    );
  }

  // ---------------------------------------------------------------------
  // Bước 1: Chọn nền văn minh — PageView ngang snap từng thẻ.
  // ---------------------------------------------------------------------
  Widget _buildCountrySelectBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn một nền văn minh',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Vuốt ngang để khám phá — mỗi nền văn minh là một hành trình lịch sử riêng.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _countryPageController,
            physics: const PageScrollPhysics(),
            itemCount: _countries.length,
            padEnds: true,
            itemBuilder: (context, index) {
              final country = _countries[index];
              return AnimatedBuilder(
                animation: _countryPageController,
                builder: (context, child) {
                  double page = index.toDouble();
                  if (_countryPageController.hasClients &&
                      _countryPageController.position.haveDimensions) {
                    page = _countryPageController.page ?? page;
                  }
                  final delta = (page - index).abs().clamp(0.0, 1.0);
                  final scale = 1.0 - delta * 0.08;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Transform.scale(scale: scale, child: child),
                  );
                },
                child: _buildCountryCard(country),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        _buildDotIndicator(_countryPageController, _countries.length),
        const SizedBox(height: 22),
      ],
    );
  }

  Widget _buildDotIndicator(PageController controller, int count) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        double page = 0;
        if (controller.hasClients && controller.position.haveDimensions) {
          page = controller.page ?? 0;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (i) {
            final delta = (page - i).abs().clamp(0.0, 1.0);
            final isActive = delta < 0.5;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.cardBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildCountryCard(CountryModel country) {
    final unlocked = MockData.isCountryUnlocked(country);
    final requiredId = country.requiresCountryId;
    final requiredCount = country.requiresMilestoneCount ?? 0;
    final doneCount =
        requiredId == null ? 0 : MockData.completedMilestonesForCountry(requiredId);
    final active = unlocked && country.hasContent;

    return CountryPageCard(
      country: country,
      unlocked: unlocked,
      active: active,
      doneCount: doneCount,
      requiredCount: requiredCount,
      onTap: () => _selectCountry(country),
    );
  }

  // ---------------------------------------------------------------------
  // Bước 2: Chọn thời kỳ — PageView dọc, item trung tâm nổi bật, các item
  // lân cận thu nhỏ/mờ/blur dần theo khoảng cách tới trang trung tâm.
  // ---------------------------------------------------------------------
  Widget _buildErasBody() {
    final eras = _eras;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chào ${_user.name}!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Vuốt dọc để chọn một thời kỳ, thời kỳ đang chọn sẽ được phóng to',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView.builder(
            key: ValueKey(_activeCountryId),
            controller: _eraPageController,
            scrollDirection: Axis.vertical,
            itemCount: eras.length,
            itemBuilder: (context, index) {
              final era = eras[index];
              return AnimatedBuilder(
                animation: _eraPageController,
                builder: (context, _) {
                  double page = index.toDouble();
                  if (_eraPageController.hasClients &&
                      _eraPageController.position.haveDimensions) {
                    page = _eraPageController.page ?? page;
                  }
                  final delta = (page - index).abs().clamp(0.0, 1.0);
                  final scale = 1.0 - delta * 0.15; // 1.0 tâm → 0.85 rìa
                  final opacity = 1.0 - delta * 0.55; // 1.0 tâm → 0.45 rìa
                  final blurSigma = delta * 3.0; // 0 tâm → 3.0 rìa
                  final isCenter = delta < 0.5;

                  Widget item = EraVerticalItem(
                    era: era,
                    isCenter: isCenter,
                    onTap: () => context.push('/eras/${era.id}'),
                    onLockedTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Thời kỳ ${era.name} đang khóa!'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                  );

                  Widget content = Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Transform.scale(scale: scale, child: item),
                  );

                  if (blurSigma > 0.02) {
                    content = ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                      child: content,
                    );
                  }
                  return content;
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
