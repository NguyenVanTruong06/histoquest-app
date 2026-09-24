import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/profile_decorations.dart';
import '../../../shared/widgets/histoquest_top_header.dart';
import 'widgets/player_profile_showcase_sheet.dart';

class RanksScreen extends StatefulWidget {
  const RanksScreen({super.key});

  @override
  State<RanksScreen> createState() => _RanksScreenState();
}

class _RanksScreenState extends State<RanksScreen> {
  // 0: Đấu Hạng Tuần (League), 1: Điểm Mùa (Tháng), 2: Đại Khoa Bảng (All-time)
  int _selectedTab = 0;

  List<Map<String, dynamic>> get _leaderboard {
    final list = List<Map<String, dynamic>>.from(MockData.leaderboard);

    // Đồng bộ thông tin người dùng "An (Bạn)" từ currentUser
    for (int i = 0; i < list.length; i++) {
      if ((list[i]['name'] as String).contains('(Bạn)')) {
        list[i] = {
          ...list[i],
          'frameId': MockData.currentUser.currentFrameId,
          'bannerId': MockData.currentUser.currentBannerId,
          'level': MockData.currentUser.level,
          'xp': MockData.currentUser.xp,
          'weeklyXp': MockData.currentUser.weeklyXp,
          'streak': MockData.currentUser.streakDays,
        };
      }
    }

    if (_selectedTab == 0) {
      // Đấu Hạng Tuần: Xếp theo XP tích lũy trong tuần hiện tại
      list.sort((a, b) => ((b['weeklyXp'] as int?) ?? 0).compareTo((a['weeklyXp'] as int?) ?? 0));
    } else if (_selectedTab == 1) {
      // Điểm Mùa: Xếp theo tổng XP trong chiến dịch tháng
      list.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));
    } else if (_selectedTab == 2) {
      // Đại Khoa Bảng: Xếp theo Cấp độ sử gia & Tri thức tích lũy
      list.sort((a, b) => (b['level'] as int).compareTo(a['level'] as int));
    }

    for (int i = 0; i < list.length; i++) {
      list[i] = {...list[i], 'rank': i + 1};
    }
    return list;
  }

  void _openPlayerShowcase(Map<String, dynamic> player) {
    PlayerProfileShowcaseSheet.show(
      context,
      player: player,
      onUpdateUser: (updated) {
        setState(() {});
      },
    );
  }

  void _showLeagueRulesModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.military_tech_rounded,
                        color: AppColors.goldDark,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cơ Chế Đấu Hạng & Thăng/Tụt Hạng',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Hệ thống thi cử công bằng cho mọi sĩ tử',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Card Cam Kết Công Bằng Cho Tân Thủ
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEFF6FF), Color(0xFFE0F2FE)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.verified_user_rounded, size: 16, color: Color(0xFF0284C7)),
                          SizedBox(width: 6),
                          Text(
                            'Cam Kết Công Bằng Cho Tân Thủ:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                              color: Color(0xFF0369A1),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        '• Tân thủ chỉ thi đấu với tân thủ cùng trình độ (bảng 30 người).\n'
                        '• Điểm tuần reset về 0 mỗi tuần — người tải trước không có lợi thế điểm cũ!\n'
                        '• Chuỗi ngày không dùng để xếp hạng thi đấu (tránh độc quyền top).',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF0C4A6E), height: 1.35),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _buildTierStep(
                  badge: '🥉',
                  tierName: '1. Bảng Đồng (Hương Cống)',
                  tierDesc: 'Nơi xuất phát của tân thủ. Bạn chỉ thi đấu với người mới, mọi người đều 0 XP tuần để ai cũng có cơ hội leo Top!',
                  color: const Color(0xFFC88252),
                ),
                const SizedBox(height: 10),
                _buildTierStep(
                  badge: '🥈',
                  tierName: '2. Bảng Bạc (Cử Nhân) - Bảng hiện tại',
                  tierDesc: 'Các sĩ tử bắt đầu chăm chỉ hơn. Top 3 sẽ thăng lên Bảng Vàng.',
                  color: const Color(0xFF7A8B9E),
                  isCurrent: true,
                ),
                const SizedBox(height: 10),
                _buildTierStep(
                  badge: '🥇',
                  tierName: '3. Bảng Vàng (Tiến Sĩ)',
                  tierDesc: 'Bảng đấu danh giá của các học giả chuyên sâu.',
                  color: AppColors.gold,
                ),
                const SizedBox(height: 10),
                _buildTierStep(
                  badge: '💎',
                  tierName: '4. Bảng Lam Ngọc (Bảng Nhãn)',
                  tierDesc: 'Hội tụ 5% người học sử chăm chỉ nhất hệ thống.',
                  color: const Color(0xFF0EA5E9),
                ),
                const SizedBox(height: 10),
                _buildTierStep(
                  badge: '👑',
                  tierName: '5. Bảng Kim Cương (Trạng Nguyên)',
                  tierDesc: 'Đỉnh cao khoa cử! Vinh danh trọn đời với rương báu huyền thoại.',
                  color: const Color(0xFF9333EA),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFDBA74)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.autorenew_rounded, size: 16, color: Color(0xFFEA580C)),
                          SizedBox(width: 6),
                          Text(
                            'Cơ Chế Tụt Hạng & Reset Tuần:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                              color: Color(0xFFC2410C),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Mỗi tuần reset điểm XP về 0 vào 23:59 Chủ Nhật.\n'
                        '• 🟢 Top 1 - 3: Thăng hạng lên Bảng cao hơn + Thưởng Xu lớn.\n'
                        '• ⚪ Hạng 4 - 6: Trụ hạng an toàn.\n'
                        '• 🔴 Hạng 7 - 8: Bị TỤT HẠNG xuống Bảng thấp hơn nếu lười biếng!',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF7C2D12), height: 1.35),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Đã Hiểu Luật Đấu Hạng',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showClimbRankActionSheet(Map<String, dynamic> currentUser) {
    const diff = 60; // cách Top 3
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFDBA74)),
                    ),
                    child: const Text('🔥', style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bứt Phá Lên Top 3 Thăng Hạng',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Chỉ cần +$diff XP để vượt lên và vào Bảng Vàng!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFEA580C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildXpTaskItem(
                icon: Icons.quiz_rounded,
                iconColor: const Color(0xFF2563EB),
                bgColor: const Color(0xFFEFF6FF),
                title: 'Giải Đố Sử Ký Nhanh',
                desc: 'Hoàn thành 5 câu hỏi lịch sử triều đại',
                reward: '+50 XP',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hãy chuyển sang Tab Bản đồ hoặc Trò chơi để giải đố nhận ngay +50 XP!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildXpTaskItem(
                icon: Icons.sports_kabaddi_rounded,
                iconColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFEF3C7),
                title: 'Đấu Trí 1v1 Cùng Sĩ Tử',
                desc: 'Thách đấu bạn bè trong phòng thi',
                reward: '+35 XP',
                onTap: () {
                  Navigator.pop(ctx);
                  if (_leaderboard.isNotEmpty) {
                    _openPlayerShowcase(_leaderboard.first);
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildXpTaskItem(
                icon: Icons.explore_rounded,
                iconColor: const Color(0xFF059669),
                bgColor: const Color(0xFFECFDF5),
                title: 'Khám Phá Di Tích Mới',
                desc: 'Đọc mốc sự kiện & mở khóa nhân vật',
                reward: '+20 XP',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Khám phá các di tích trên bản đồ để nhận thêm XP leo bảng vàng!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA580C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Đã Sẵn Sàng Bứt Phá!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildXpTaskItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String desc,
    required String reward,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Text(
                  reward,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTierStep({
    required String badge,
    required String tierName,
    required String tierDesc,
    required Color color,
    bool isCurrent = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrent ? color.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? color : Colors.grey.shade200,
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(badge, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      tierName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                        color: isCurrent ? color : AppColors.textPrimary,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Bạn ở đây',
                          style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  tierDesc,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    final leaderboard = _leaderboard;

    final currentUserIndex = leaderboard.indexWhere(
      (p) => (p['name'] as String).contains('(Bạn)'),
    );
    final currentUserData = currentUserIndex >= 0 ? leaderboard[currentUserIndex] : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          HistoquestTopHeader(
            title: 'Bảng Vàng',
            coins: user.coins,
            streakDays: user.streakDays,
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Bộ 3 Tab mới (Đấu Hạng Tuần / Điểm Mùa / Đại Khoa Bảng)
                    _buildToggle(),
                    // Banner giải đấu / Bảng đấu hiện tại
                    _buildLeagueBanner(),
                    // Hint banner
                    _buildHintBanner(),
                    const SizedBox(height: 6),
                    // Podium 3D Bục Vinh Quang
                    _buildPodium(),
                    const SizedBox(height: 4),
                    // Danh sách từ hạng 4 trở đi với vạch Thăng / Tụt Hạng
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        itemCount: leaderboard.length > 3 ? (leaderboard.length - 3) + (_selectedTab == 0 ? 2 : 0) : 0,
                        itemBuilder: (context, index) {
                          if (_selectedTab == 0) {
                            // Tab Đấu Hạng: Thêm 2 dải phân cách Thăng hạng & Tụt hạng
                            if (index == 0) {
                              return _buildZoneDivider(
                                isPromotion: true,
                                label: '▲ VÙNG THĂNG HẠNG (Top 1 - 3 thăng lên Bảng Vàng)',
                              );
                            }
                            if (index == 4) {
                              return _buildZoneDivider(
                                isPromotion: false,
                                label: '▼ VÙNG NGUY CƠ TỤT HẠNG (Hạng 7 - 8 sẽ rớt xuống Bảng Đồng)',
                              );
                            }
                            // Ánh xạ lại chỉ số người chơi
                            final playerIndex = index > 4 ? (index + 3 - 2) : (index + 3 - 1);
                            if (playerIndex < leaderboard.length) {
                              final rankUser = leaderboard[playerIndex];
                              return _buildRankItem(rankUser);
                            }
                            return const SizedBox();
                          } else {
                            final rankUser = leaderboard[index + 3];
                            return _buildRankItem(rankUser);
                          }
                        },
                      ),
                    ),
                    // Sticky Bottom Bar "Hạng Của Bạn"
                    if (currentUserData != null)
                      _buildStickyUserBar(currentUserData, leaderboard),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Dải phân cách Vùng Thăng Hạng / Vùng Tụt Hạng
  Widget _buildZoneDivider({required bool isPromotion, required String label}) {
    final color = isPromotion ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final bgColor = isPromotion ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPromotion ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Banner Bảng Đấu Hiện Tại (League Division Banner)
  Widget _buildLeagueBanner() {
    if (_selectedTab == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF93C5FD)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🥈', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'BẢNG BẠC (CỬ NHÂN) · PHÒNG #04',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Text(
                          '⏳ Kết thúc: Chủ Nhật 23:59 (Còn 2 ngày 14h)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF3B82F6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: _showLeagueRulesModal,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF93C5FD)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline_rounded, size: 13, color: Color(0xFF1E40AF)),
                          SizedBox(width: 4),
                          Text(
                            'Luật Đấu',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E40AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildMiniTierLadder(),
            ],
          ),
        ),
      );
    } else if (_selectedTab == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: const Row(
            children: [
              Text('🍁', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Chiến Dịch Tháng 9: Tích lũy điểm cống hiến nhận Khung Mùa!',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF92400E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F3FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFDDD6FE)),
          ),
          child: const Row(
            children: [
              Text('📜', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bia Tiến Sĩ Quốc Tử Giám: Lưu danh các bậc kỳ tài sử học.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF5B21B6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  /// Thanh tiến trình 5 cấp bậc khoa cử (Đồng -> Bạc -> Vàng -> Lam Ngọc -> Kim Cương)
  Widget _buildMiniTierLadder() {
    final tiers = [
      {'emoji': '🥉', 'name': 'Đồng', 'active': false, 'done': true},
      {'emoji': '🥈', 'name': 'Bạc', 'active': true, 'done': false},
      {'emoji': '🥇', 'name': 'Vàng', 'active': false, 'done': false},
      {'emoji': '💎', 'name': 'Lam Ngọc', 'active': false, 'done': false},
      {'emoji': '👑', 'name': 'K.Cương', 'active': false, 'done': false},
    ];

    return InkWell(
      onTap: _showLeagueRulesModal,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFBFDBFE)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(tiers.length * 2 - 1, (index) {
            if (index.isOdd) {
              final leftDone = (tiers[(index - 1) ~/ 2]['done'] as bool) || (tiers[(index - 1) ~/ 2]['active'] as bool);
              return Expanded(
                child: Container(
                  height: 2,
                  color: leftDone ? const Color(0xFF3B82F6) : Colors.grey.shade300,
                ),
              );
            }
            final t = tiers[index ~/ 2];
            final isActive = t['active'] as bool;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: isActive ? 6 : 4, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF1E40AF) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(t['emoji'] as String, style: const TextStyle(fontSize: 11)),
                  if (isActive) ...[
                    const SizedBox(width: 3),
                    Text(
                      t['name'] as String,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Hint Banner
  Widget _buildHintBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app_rounded,
            size: 14,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'Chạm vào người chơi để xem Khung, Danh hiệu & Thách đấu',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE4EFF4),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            _buildTabButton(0, 'Đấu Hạng Tuần'),
            _buildTabButton(1, 'Điểm Mùa'),
            _buildTabButton(2, 'Bia Tiến Sĩ'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String text) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  /// Podium 3D Bục Vinh Quang
  Widget _buildPodium() {
    if (_leaderboard.length < 3) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Rank 2 (Silver)
          Expanded(
            child: _buildPodiumItem(
              _leaderboard[1],
              2,
              const Color(0xFF8E9BAE),
              standHeight: 32,
              crownEmoji: '🥈',
            ),
          ),
          const SizedBox(width: 8),
          // Rank 1 (Gold - Cao nhất & Lộng lẫy nhất)
          Expanded(
            child: _buildPodiumItem(
              _leaderboard[0],
              1,
              AppColors.gold,
              isWinner: true,
              standHeight: 52,
              crownEmoji: '👑',
            ),
          ),
          const SizedBox(width: 8),
          // Rank 3 (Bronze)
          Expanded(
            child: _buildPodiumItem(
              _leaderboard[2],
              3,
              const Color(0xFFC88252),
              standHeight: 22,
              crownEmoji: '🥉',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(
    Map<String, dynamic> user,
    int rank,
    Color rankColor, {
    bool isWinner = false,
    required double standHeight,
    required String crownEmoji,
  }) {
    String statText = '';
    if (_selectedTab == 0) {
      statText = '${user['weeklyXp'] ?? 350} XP Tuần';
    } else if (_selectedTab == 1) {
      statText = '${user['xp']} XP Mùa';
    } else {
      statText = 'Cấp ${user['level']}';
    }

    final isCurrentUser = (user['name'] as String).contains('(Bạn)');
    String name = user['name'] as String;
    String initials = name
        .replaceAll('(Bạn)', '')
        .trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join('')
        .toUpperCase();
    if (initials.isEmpty) initials = 'HG';

    final frameId = isCurrentUser
        ? MockData.currentUser.currentFrameId
        : (user['frameId'] as String? ?? 'frame_default');
    final frame = MockProfileDecorations.getFrame(frameId);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => _openPlayerShowcase(user),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: isWinner ? 16 : 12,
                horizontal: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isWinner
                      ? AppColors.gold.withValues(alpha: 0.6)
                      : Colors.grey.shade200,
                  width: isWinner ? 1.8 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isWinner
                        ? AppColors.gold.withValues(alpha: 0.18)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: isWinner ? 12 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      crownEmoji,
                      style: TextStyle(fontSize: isWinner ? 20 : 16),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      if (frame.hasGlow || isWinner)
                        Container(
                          width: isWinner ? 64 : 52,
                          height: isWinner ? 64 : 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (isWinner ? AppColors.gold : frame.gradientColors.first)
                                    .withValues(alpha: 0.35),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      Container(
                        width: isWinner ? 60 : 48,
                        height: isWinner ? 60 : 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: frame.gradientColors.length > 1
                                ? [...frame.gradientColors, frame.gradientColors.first]
                                : [frame.gradientColors.first, frame.gradientColors.first],
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isWinner ? 3.0 : 2.5),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFEBE5D9),
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  fontSize: isWinner ? 16 : 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            color: frame.gradientColors.first,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Icon(frame.icon, size: 8, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name.replaceAll(' (Bạn)', ''),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isWinner
                          ? AppColors.goldLight
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      user['title'] as String? ?? 'Sử gia',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: isWinner ? AppColors.goldDark : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isWinner ? AppColors.goldDark : AppColors.textPrimary,
                    ),
                  ),
                  if (_selectedTab == 0) ...[
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '▲ Thăng Bảng Vàng',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: standHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                rankColor.withValues(alpha: 0.85),
                rankColor,
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: rankColor.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankItem(Map<String, dynamic> user) {
    bool isCurrentUser = (user['name'] as String).contains('(Bạn)');
    String name = user['name'] as String;
    String initials = name
        .replaceAll('(Bạn)', '')
        .trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join('')
        .toUpperCase();
    if (initials.isEmpty) initials = 'HG';

    if (isCurrentUser) {
      name = 'An';
    }

    final rank = user['rank'] as int? ?? 4;
    String statText = '';
    String statusTag = '';
    Color statusTagBg = Colors.grey.shade100;
    Color statusTagText = Colors.grey.shade700;

    if (_selectedTab == 0) {
      statText = '${user['weeklyXp'] ?? 350} XP';
      if (rank <= 3) {
        statusTag = '▲ Thăng hạng';
        statusTagBg = const Color(0xFFECFDF5);
        statusTagText = const Color(0xFF059669);
      } else if (rank >= 7) {
        statusTag = '▼ Tụt hạng';
        statusTagBg = const Color(0xFFFEF2F2);
        statusTagText = const Color(0xFFDC2626);
      } else {
        statusTag = '▬ Trụ hạng';
        statusTagBg = const Color(0xFFF1F5F9);
        statusTagText = const Color(0xFF475569);
      }
    } else if (_selectedTab == 1) {
      statText = '${user['xp']} XP';
    } else {
      statText = 'Cấp ${user['level']}';
    }

    final frameId = isCurrentUser
        ? MockData.currentUser.currentFrameId
        : (user['frameId'] as String? ?? 'frame_default');
    final frame = MockProfileDecorations.getFrame(frameId);

    Color bgColor = isCurrentUser ? const Color(0xFFEFF7FA) : Colors.white;
    Color borderColor = isCurrentUser
        ? AppColors.primary
        : Colors.grey.shade200;
    Color rankColor = isCurrentUser
        ? AppColors.primary
        : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isCurrentUser ? 1.5 : 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _openPlayerShowcase(user),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 26,
                  child: Text(
                    '${user['rank']}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: rankColor,
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    if (frame.hasGlow)
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: frame.gradientColors.first.withValues(alpha: 0.35),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: frame.gradientColors.length > 1
                              ? [...frame.gradientColors, frame.gradientColors.first]
                              : [frame.gradientColors.first, frame.gradientColors.first],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEBE5D9),
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -1,
                      top: -1,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: frame.gradientColors.first,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Icon(frame.icon, size: 7, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrentUser) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Bạn',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            user['title'] as String? ?? 'Sử gia',
                            style: TextStyle(
                              fontSize: 11,
                              color: isCurrentUser
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (statusTag.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: statusTagBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                statusTag,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: statusTagText,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      statText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Xem hồ sơ',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary.withValues(alpha: 0.8),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Sticky Bottom Bar "Hạng Của Bạn"
  Widget _buildStickyUserBar(
    Map<String, dynamic> currentUser,
    List<Map<String, dynamic>> leaderboard,
  ) {
    final rank = currentUser['rank'] as int? ?? 4;
    final top3Player = leaderboard.length >= 3 ? leaderboard[2] : null;

    String gapText = '';
    Color gapColor = AppColors.textSecondary;
    if (_selectedTab == 0) {
      if (top3Player != null && rank > 3) {
        final diff = ((top3Player['weeklyXp'] as int?) ?? 410) -
            ((currentUser['weeklyXp'] as int?) ?? 350);
        gapText = 'Chỉ cần +${diff > 0 ? diff : 0} XP để vào Top 3 Thăng Hạng! 🚀';
        gapColor = const Color(0xFFEA580C);
      } else if (rank <= 3) {
        gapText = 'Bạn đang trong Vùng Thăng Hạng Bảng Vàng (+250 Xu) 🎉';
        gapColor = const Color(0xFF059669);
      } else {
        gapText = '⚠️ Nguy cơ tụt Bảng Đồng! Cần thêm XP ngay.';
        gapColor = const Color(0xFFDC2626);
      }
    } else if (top3Player != null && rank > 3) {
      if (_selectedTab == 1) {
        final diff = (top3Player['xp'] as int) - (currentUser['xp'] as int);
        gapText = 'Cách Top 3: ${diff > 0 ? diff : 0} XP';
      } else {
        final diff = (top3Player['level'] as int) - (currentUser['level'] as int);
        gapText = 'Cách Top 3: ${diff > 0 ? diff : 0} Cấp';
      }
    } else {
      gapText = 'Đang trong Vùng Thăng Hạng 🏆';
    }

    String statText = '';
    if (_selectedTab == 0) {
      statText = '${currentUser['weeklyXp'] ?? 350} XP';
    } else if (_selectedTab == 1) {
      statText = '${currentUser['xp']} XP';
    } else {
      statText = 'Cấp ${currentUser['level']}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '#$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Vị trí của bạn',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '($statText)',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    gapText,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: _selectedTab == 0 && rank > 3 ? FontWeight.bold : FontWeight.normal,
                      color: gapColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (_selectedTab == 0 && rank > 3) ...[
              ElevatedButton(
                onPressed: () => _showClimbRankActionSheet(currentUser),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEA580C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Leo Hạng ⚔️',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            ElevatedButton(
              onPressed: () => _openPlayerShowcase(currentUser),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Chi Tiết',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
