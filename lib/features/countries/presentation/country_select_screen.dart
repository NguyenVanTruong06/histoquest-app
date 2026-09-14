import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/country_model.dart';

/// Màn hình chọn quốc gia / nền văn minh — hiển thị TRƯỚC màn hình chọn
/// thời kỳ (ErasScreen). Người chơi chọn một nền văn minh (hiện mock:
/// Việt Nam, Trung Quốc, Ai Cập) rồi mới vào bản đồ thời kỳ tương ứng.
/// Dữ liệu thật cho Trung Quốc & Ai Cập sẽ được bổ sung sau — hiện chỉ
/// Việt Nam có nội dung, hai nước còn lại hiển thị nhãn "Sắp ra mắt".
class CountrySelectScreen extends StatelessWidget {
  const CountrySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final countries = MockData.countries;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.public_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'HistoQuest',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Chọn một nền văn minh',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Mỗi nền văn minh là một hành trình lịch sử riêng để bạn khám phá.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Landscape: các thẻ quốc gia xếp thành hàng ngang, tận
                  // dụng chiều rộng dư ra thay vì xếp chồng dọc.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < countries.length; i++) ...[
                        if (i > 0) const SizedBox(width: 16),
                        Expanded(child: _buildCountryCard(context, countries[i])),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryCard(BuildContext context, CountryModel country) {
    return GestureDetector(
      onTap: () {
        MockData.selectedCountryId = country.id;
        context.go('/eras');
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: country.hasContent ? country.accentColor : AppColors.cardBorder,
            width: country.hasContent ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D2B2B).withValues(alpha: country.hasContent ? 0.14 : 0.06),
              offset: const Offset(0, 8),
              blurRadius: country.hasContent ? 24 : 16,
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
                  color: country.accentColor,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(country.icon, size: 46, color: Colors.white.withValues(alpha: 0.9)),
                      Positioned(
                        right: 10,
                        top: 8,
                        child: Text(
                          country.flagEmoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: country.hasContent ? AppColors.primaryLight : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          country.hasContent ? 'Sẵn sàng khám phá' : 'Sắp ra mắt',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: country.hasContent ? AppColors.primary : Colors.grey.shade600,
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
                          country.subtitle,
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
}
