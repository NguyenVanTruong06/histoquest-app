import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/country_model.dart';
import '../../../data/models/era_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/mock_data.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_empty_view.dart';

class ErasScreen extends StatefulWidget {
  const ErasScreen({super.key});

  @override
  State<ErasScreen> createState() => _ErasScreenState();
}

class _ErasScreenState extends State<ErasScreen> {
  final UserModel _user = MockData.currentUser;

  List<EraModel> get _eras => MockData.erasForSelectedCountry;

  CountryModel get _selectedCountry => MockData.countries.firstWhere(
        (c) => c.id == MockData.selectedCountryId,
        orElse: () => MockData.countries.first,
      );

  @override
  Widget build(BuildContext context) {
    final country = _selectedCountry;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        titleSpacing: 16,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'HistoQuest',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 10),
            // Nút đổi quốc gia / nền văn minh đang khám phá
            InkWell(
              onTap: () => context.go('/countries'),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5DFC9)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(country.flagEmoji, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 5),
                    Text(
                      country.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 3),
                    const Icon(Icons.unfold_more_rounded, size: 14, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ],
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
                  const Icon(Icons.monetization_on_rounded, color: AppColors.gold, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${_user.coins}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.local_fire_department_rounded, color: Colors.deepOrange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${_user.streakDays}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _eras.isEmpty ? _buildEmptyState(country) : _buildErasGrid(),
    );
  }

  Widget _buildEmptyState(CountryModel country) {
    return AppEmptyView(
      icon: Icons.hourglass_top_rounded,
      title: 'Đang xây dựng nội dung ${country.name}',
      message:
          'Hiện tại chưa có dữ liệu lịch sử cho ${country.name}. Hãy quay lại chọn Việt Nam hoặc thử lại sau nhé!',
      actionText: 'Chọn nền văn minh khác',
      onActionPressed: () => context.go('/countries'),
    );
  }

  Widget _buildErasGrid() {
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
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          sliver: SliverGrid(
            // Landscape: màn hình rộng hơn cao, nên dùng lưới co giãn theo
            // chiều rộng thay vì cố định 2 cột, và thẻ dẹt hơn (đỡ tốn chiều cao).
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.05,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final era = _eras[index];
                return _buildEraCard(context, era);
              },
              childCount: _eras.length,
            ),
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
            color: isUnlocked ? AppColors.cardBorderActive : AppColors.cardBorder,
            width: isUnlocked ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D2B2B).withValues(alpha: isUnlocked ? 0.14 : 0.06),
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
                    color: isUnlocked ? AppColors.primary : Colors.grey.shade300,
                  ),
                  child: Center(
                    child: Icon(
                      isUnlocked ? Icons.account_balance_rounded : Icons.lock_rounded,
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
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: isUnlocked ? AppColors.surface : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: isUnlocked ? const Color(0xFFE5DFC9) : Colors.transparent),
                        ),
                        child: Text(
                          isUnlocked ? 'Đã mở' : 'Đang khóa',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? AppColors.primary : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        era.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? AppColors.textPrimary : Colors.grey.shade600,
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
                          color: isUnlocked ? AppColors.textSecondary : Colors.grey.shade500,
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
