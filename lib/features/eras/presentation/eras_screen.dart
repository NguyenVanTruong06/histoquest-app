import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/country_model.dart';
import '../../../data/models/era_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/mock_data.dart';

/// Màn hình gốc của tab "Bản đồ" (branch đầu tiên trong shell chính).
///
/// Luồng: người chơi VÀO GAME trước (thấy shell chính với thanh điều hướng),
/// rồi mới chọn nền văn minh, rồi mới chọn thời kỳ — thay vì phải chọn nền
/// văn minh ở một màn hình chặn riêng TRƯỚC khi vào game như trước đây.
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
  // Bước 1: Chọn nền văn minh — bước đầu tiên trong tab Bản đồ.
  // ---------------------------------------------------------------------
  Widget _buildCountrySelectBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 12.0),
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
                  'Mỗi nền văn minh là một hành trình lịch sử riêng để bạn khám phá.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.92,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildCountryCard(_countries[index]),
              childCount: _countries.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  Widget _buildCountryCard(CountryModel country) {
    final unlocked = MockData.isCountryUnlocked(country);
    final requiredId = country.requiresCountryId;
    final requiredCount = country.requiresMilestoneCount ?? 0;
    final doneCount =
        requiredId == null ? 0 : MockData.completedMilestonesForCountry(requiredId);
    final active = unlocked && country.hasContent;

    return GestureDetector(
      onTap: () => _selectCountry(country),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: active ? country.accentColor : AppColors.cardBorder,
            width: active ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D2B2B).withValues(alpha: active ? 0.14 : 0.06),
              offset: const Offset(0, 8),
              blurRadius: active ? 24 : 16,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: unlocked ? country.accentColor : Colors.grey.shade400,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        unlocked ? country.icon : Icons.lock_rounded,
                        size: 42,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      Positioned(
                        right: 10,
                        top: 8,
                        child: Text(
                          country.flagEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primaryLight : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          !unlocked
                              ? 'Đang khóa · $doneCount/$requiredCount mốc'
                              : (active ? 'Sẵn sàng khám phá' : 'Sắp ra mắt'),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: active ? AppColors.primary : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        country.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          unlocked ? country.subtitle : (country.unlockHint ?? country.subtitle),
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Bước 2: Chọn thời kỳ — sau khi đã chọn nền văn minh ở bước 1.
  // ---------------------------------------------------------------------
  Widget _buildErasBody() {
    final eras = _eras;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 12.0),
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
                  'Chọn một thời kỳ để bắt đầu thám hiểm',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 8.0,
          ),
          sliver: SliverGrid(
            // Landscape: màn hình rộng hơn cao, nên dùng lưới co giãn theo
            // chiều rộng thay vì cố định 2 cột, và thẻ dẹt hơn (đỡ tốn chiều cao).
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.05,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final era = eras[index];
              return _buildEraCard(context, era);
            }, childCount: eras.length),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  Widget _buildEraCard(BuildContext context, EraModel era) {
    final isUnlocked = era.isUnlocked;

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          context.push('/eras/${era.id}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thời kỳ ${era.name} đang khóa!'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked
                ? AppColors.cardBorderActive
                : AppColors.cardBorder,
            width: isUnlocked ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D2B2B)
                  .withValues(alpha: isUnlocked ? 0.14 : 0.06),
              offset: const Offset(0, 8),
              blurRadius: isUnlocked ? 24 : 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? AppColors.primary
                        : Colors.grey.shade300,
                  ),
                  child: Center(
                    child: Icon(
                      isUnlocked
                          ? Icons.account_balance_rounded
                          : Icons.lock_rounded,
                      size: 48,
                      color: isUnlocked ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? AppColors.surface
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isUnlocked
                                ? const Color(0xFFE5DFC9)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          isUnlocked ? 'Đã mở' : 'Đang khóa',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked
                                ? AppColors.primary
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        era.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked
                              ? AppColors.textPrimary
                              : Colors.grey.shade600,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        era.centuryTitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isUnlocked
                              ? AppColors.textSecondary
                              : Colors.grey.shade500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
