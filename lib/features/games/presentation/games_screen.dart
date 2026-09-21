import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../shared/widgets/histoquest_top_header.dart';
import '../data/games_catalog.dart';
import '../domain/models/game_item_model.dart';
import 'widgets/game_app_icon_tile.dart';
import 'widgets/game_mode_detail_sheet.dart';

/// Màn hình Trò Chơi Dân Gian & Lịch Sử (Kỳ Đài HistoQuest)
/// Thiết kế dạng App Launcher Grid 4x4 (4 Cột icon app chuẩn di động)
class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  String _selectedCategory = 'Tất cả';

  final List<String> _categories = const [
    'Tất cả',
    'Trí tuệ',
    'Chiến thuật',
    'Dân gian',
    'Đối kháng',
    'Khám phá',
  ];

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    // Lọc danh sách trò chơi theo danh mục được chọn
    final filteredGames = _selectedCategory == 'Tất cả'
        ? GamesCatalog.allGames
        : GamesCatalog.allGames
            .where((g) => g.category == _selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Header trên cùng (Xu & Chuỗi ngày học)
          HistoquestTopHeader(
            title: 'Trò Chơi Dân Gian',
            coins: user.coins,
            streakDays: user.streakDays,
          ),

          // 2. Nội dung cuộn chính
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Banner sảnh Kỳ Đài (Dạng thẻ cao cấp)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF212B36), Color(0xFF161C24)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x20000000),
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'KỲ ĐÀI TRẠNG NGUYÊN',
                                  style: TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sảnh Trò Chơi Lịch Sử',
                                  style: GoogleFonts.philosopher(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'Chạm vào từng biểu tượng để xem luật chơi và thi đấu nhận Xu & XP.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.gold, width: 1.5),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.sports_esports_rounded,
                                color: AppColors.gold,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Thanh chọn bộ lọc thể loại (Chips)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 38,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = cat == _selectedCategory;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : const Color(0xFFE0E0E0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategory = cat);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 14),
                ),

                // Tiêu đề số lượng trò chơi
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kho Trò Chơi (${filteredGames.length})',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Lưới 4 Cột • Chạm để xem',
                          style: GoogleFonts.roboto(
                            fontSize: 11,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 10),
                ),

                // 3. LƯỚI APP ICON 4X4 (4 Cột chuẩn biểu tượng ứng dụng)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 4 Cột chuẩn 4x4
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 6,
                      childAspectRatio: 0.74, // Tỉ lệ chiều cao cân đối cho Icon + 2 dòng chữ
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final game = filteredGames[index];
                        return GameAppIconTile(
                          game: game,
                          onTap: () => _onGameTap(context, game),
                        );
                      },
                      childCount: filteredGames.length,
                    ),
                  ),
                ),

                // Đệm khoảng trống cuối trang để không bị che bởi Floating Bottom Dock
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Khi chạm vào một biểu tượng trò chơi -> Mở Sheet sơ lược chế độ chơi
  void _onGameTap(BuildContext context, GameItemModel game) {
    GameModeDetailSheet.show(context, game);
  }
}
