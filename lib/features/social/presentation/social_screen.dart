import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/news_article_model.dart';
import '../../../shared/widgets/app_empty_view.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loading_view.dart';
import '../../../shared/widgets/app_modal_dialog.dart';
import '../../../shared/widgets/stat_badge.dart';
import 'widgets/news_article_card.dart';
import 'widgets/news_category_chips.dart';
import 'widgets/news_detail_sheet.dart';
import 'widgets/weekly_event_banner.dart';

enum DemoUiState { normal, loading, empty, error }

/// Màn hình Tin tức & Sự kiện Lịch sử (Social / News Tab) - Day 5
class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  String _selectedCategory = 'Tất cả';
  DemoUiState _currentUiState = DemoUiState.normal;
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<NewsArticleModel> get _filteredArticles {
    return MockNewsData.articles.where((article) {
      final matchesCategory = _selectedCategory == 'Tất cả' ||
          article.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.summary.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _onWeeklyEventAction() {
    AppModalDialog.show(
      context,
      title: 'Tuần Lễ Khải Hoàn',
      message:
          'Bạn đang tham gia thử thách tuần!\n\nHãy hoàn thành các ải bài học tại Bản đồ sự kiện Thế kỷ 10 và thi thố Cờ Ô Ăn Quan để nhận trọn vẹn +300 XP và +120 xu.',
      confirmText: 'Bắt Đầu Ngay',
      type: DialogType.success,
      onConfirm: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Màn hình Tin tức
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bản Tin Sử Việt',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Khám phá sử liệu & di sản ngàn năm',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const StatBadge(
                    type: StatType.coin,
                    label: '1250 xu',
                  ),
                  const SizedBox(width: 8),
                  const StatBadge(
                    type: StatType.xp,
                    label: '+350 XP',
                  ),
                ],
              ),
            ),

            // 2. Thanh chuyển đổi trạng thái kiểm thử (Demo State Switcher)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  _buildStateTab('Bình thường', DemoUiState.normal),
                  _buildStateTab('Đang tải', DemoUiState.loading),
                  _buildStateTab('Trống', DemoUiState.empty),
                  _buildStateTab('Lỗi', DemoUiState.error),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // 3. Nội dung chính theo trạng thái UI
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateTab(String label, DemoUiState state) {
    final isSelected = _currentUiState == state;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _currentUiState = state;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_currentUiState) {
      case DemoUiState.loading:
        return const AppLoadingView(
          message: 'Đang tải bản tin & sử liệu...',
        );

      case DemoUiState.empty:
        return AppEmptyView(
          title: 'Chưa có bài viết nào',
          message: 'Hiện tại chưa có bản tin nào trong danh mục đã chọn.',
          actionText: 'Xem Tất Cả Bài Viết',
          onActionPressed: () {
            setState(() {
              _currentUiState = DemoUiState.normal;
              _selectedCategory = 'Tất cả';
            });
          },
        );

      case DemoUiState.error:
        return AppErrorView(
          title: 'Không thể kết nối sử quán',
          errorMessage:
              'Đã có sự cố gián đoạn mạng. Vui lòng kiểm tra lại kết nối của bạn.',
          onRetry: () {
            setState(() {
              _currentUiState = DemoUiState.normal;
            });
          },
        );

      case DemoUiState.normal:
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
            if (mounted) setState(() {});
          },
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              // Banner Sự kiện tuần nổi bật
              WeeklyEventBanner(
                event: MockNewsData.weeklyEvent,
                onAction: _onWeeklyEventAction,
              ),

              const SizedBox(height: 18),

              // Thanh chọn chuyên mục bài viết
              NewsCategoryChips(
                categories: MockNewsData.categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),

              const SizedBox(height: 14),

              // Tiêu đề danh sách bài viết
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory == 'Tất cả'
                          ? 'Bài Viết Mới Nhất'
                          : 'Chủ đề: $_selectedCategory',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${_filteredArticles.length} bài viết',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Danh sách các thẻ bài viết hoặc Empty state nếu lọc không ra
              if (_filteredArticles.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: AppEmptyView(
                    title: 'Không tìm thấy bài viết',
                    message:
                        'Chưa có bài viết nào thuộc chuyên mục "$_selectedCategory". Hãy chọn chuyên mục khác nhé!',
                    actionText: 'Về Tất Cả Bài Viết',
                    onActionPressed: () {
                      setState(() {
                        _selectedCategory = 'Tất cả';
                      });
                    },
                  ),
                )
              else
                ..._filteredArticles.map((article) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: NewsArticleCard(
                      article: article,
                      onTap: () => NewsDetailSheet.show(context, article),
                    ),
                  );
                }),
            ],
          ),
        );
    }
  }
}
