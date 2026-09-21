import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/landscape_game_wrapper.dart';
import '../../domain/models/game_item_model.dart';

/// Modal Bottom Sheet hiển thị thông tin tổng quan về chế độ chơi, luật chơi và phần thưởng
class GameModeDetailSheet extends StatelessWidget {
  final GameItemModel game;

  const GameModeDetailSheet({
    super.key,
    required this.game,
  });

  /// Hàm tiện ích mở Sheet chi tiết chế độ chơi
  static Future<void> show(BuildContext context, GameItemModel game) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GameModeDetailSheet(game: game),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.85),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Thanh kéo (Drag handle)
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 6),
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // 2. Nội dung cuộn được
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header: Icon App lớn + Tên trò chơi + Thể loại
                  Row(
                    children: [
                      // Icon Squircle lớn
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: game.gradientColors,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: game.gradientColors.first.withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            game.icon,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Tiêu đề & Danh mục
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.title,
                              style: GoogleFonts.philosopher(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF263238),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: game.gradientColors.first.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    game.category,
                                    style: TextStyle(
                                      color: game.gradientColors.first,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  game.isPlayable ? '🟢 Sẵn sàng chơi' : '⏳ Đang hoàn thiện',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: game.isPlayable
                                        ? const Color(0xFF2E7D32)
                                        : Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),

                  // Khung thông số nhanh (Thời lượng • Độ khó • Chế độ)
                  Row(
                    children: [
                      _buildQuickParam(
                        icon: Icons.timer_outlined,
                        label: 'Thời lượng',
                        value: game.duration,
                      ),
                      _buildQuickParam(
                        icon: Icons.offline_bolt_outlined,
                        label: 'Độ khó',
                        value: game.difficulty,
                      ),
                      _buildQuickParam(
                        icon: Icons.gamepad_outlined,
                        label: 'Kiểu chơi',
                        value: game.isPlayable ? 'Có thể chơi' : 'Sắp mở',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 3. Sơ lược Chế độ chơi (Game Mode Overview)
                  _buildSectionTitle('🎮 Chế Độ Thi Đấu'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE9ECEF)),
                    ),
                    child: Text(
                      game.gameMode,
                      style: GoogleFonts.roboto(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF37474F),
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 4. Luật chơi & Cách chơi
                  _buildSectionTitle('📜 Cách Chơi & Luật Thi Đấu'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF8),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF0E6D2)),
                    ),
                    child: Text(
                      game.howToPlay,
                      style: GoogleFonts.roboto(
                        fontSize: 13.5,
                        color: const Color(0xFF4E342E),
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 5. Phần thưởng chiến thắng
                  _buildSectionTitle('🎁 Phần Thưởng Chiến Thắng'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildRewardPill(
                        icon: Icons.monetization_on_rounded,
                        color: AppColors.gold,
                        text: '+${game.coinReward} xu',
                      ),
                      const SizedBox(width: 10),
                      _buildRewardPill(
                        icon: Icons.bolt_rounded,
                        color: const Color(0xFF1976D2),
                        text: '+${game.xpReward} XP',
                      ),
                      const SizedBox(width: 10),
                      _buildRewardPill(
                        icon: Icons.card_giftcard_rounded,
                        color: const Color(0xFF8E24AA),
                        text: game.itemReward,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Nút hành động cuối màn hình
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomInset),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (game.isPlayable && game.screenBuilder != null) {
                    Navigator.pop(context); // Đóng modal
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          final screen = game.screenBuilder!(context);
                          if (game.isLandscape) {
                            return LandscapeGameWrapper(child: screen);
                          }
                          return screen;
                        },
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Trò chơi "${game.title}" đang hoàn thiện và sẽ ra mắt ở bản cập nhật tiếp theo!',
                                style: GoogleFonts.roboto(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color(0xFF37474F),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: game.isPlayable
                      ? game.gradientColors.first
                      : const Color(0xFFECEFF1),
                  foregroundColor: game.isPlayable ? Colors.white : Colors.black45,
                  elevation: game.isPlayable ? 3 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      game.isPlayable ? Icons.play_arrow_rounded : Icons.lock_clock_rounded,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      game.isPlayable ? 'VÀO CHƠI NGAY' : 'CHẾ ĐỘ SẮP RA MẮT',
                      style: GoogleFonts.roboto(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.philosopher(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF263238),
      ),
    );
  }

  Widget _buildQuickParam({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.roboto(fontSize: 11, color: Colors.black45),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF263238),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardPill({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
