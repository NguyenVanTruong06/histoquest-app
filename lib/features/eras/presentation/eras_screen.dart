import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/era_model.dart';
import '../../../data/models/historical_event_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/mock_data.dart';
import '../../../data/repositories/history_repository.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/stat_badge.dart';
import '../../../shared/widgets/bottom_sheet_wrapper.dart';
import '../../../shared/widgets/app_modal_dialog.dart';

class ErasScreen extends StatefulWidget {
  const ErasScreen({super.key});

  @override
  State<ErasScreen> createState() => _ErasScreenState();
}

class _ErasScreenState extends State<ErasScreen> {
  final HistoryRepository _repository = MockHistoryRepository();
  UserModel _user = MockData.currentUser;
  final EraModel _currentEra = MockData.eras.first;
  late HistoricalEventModel _activeEvent;

  @override
  void initState() {
    super.initState();
    _activeEvent = _currentEra.events.firstWhere(
      (e) => e.isCurrentActive,
      orElse: () => _currentEra.events[1],
    );
  }

  void _showDemoBottomSheet() {
    BottomSheetWrapper.show(
      context,
      title: '${_activeEvent.year} · ${_activeEvent.title}',
      subtitle: _activeEvent.summary,
      bottomAction: PrimaryButton(
        label: 'Vào học ngay',
        isFullWidth: true,
        icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
        onPressed: () {
          Navigator.pop(context);
          context.go('/eras/${_currentEra.id}');
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD95D39), Color(0xFFA53B20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.sailing_rounded,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Phần thưởng sự kiện:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatBadge(type: StatType.xp, label: '+${_activeEvent.xpReward} XP'),
              StatBadge(type: StatType.coin, label: '+${_activeEvent.coinReward} xu'),
              if (_activeEvent.rewardCardName != null)
                StatBadge(type: StatType.reward, label: _activeEvent.rewardCardName!),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _activeEvent.storyContent,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showDemoModalDialog() {
    AppModalDialog.show(
      context,
      title: 'Nhận Thưởng Điểm Danh!',
      message: 'Chúc mừng bạn đã duy trì chuỗi ${_user.streakDays} ngày thám hiểm lịch sử liên tiếp.',
      type: DialogType.success,
      icon: Icons.emoji_events_rounded,
      confirmText: 'Nhận 100 Xu',
      cancelText: 'Để sau',
      onConfirm: () async {
        final updatedUser = await _repository.addRewards(coins: 100, xp: 50);
        if (mounted) {
          setState(() {
            _user = updatedUser;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: AppColors.primary,
              content: Text('Đã nhận thành công 100 Xu & 50 XP!'),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        titleSpacing: 16,
        title: const Text(
          'HistoQuest',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: UserStatsRow(
              xp: _user.xp,
              coins: _user.coins,
              streakDays: _user.streakDays,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header chào mừng đúng như HistoQuest.html
            Row(
              children: [
                Expanded(
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
                      const SizedBox(height: 2),
                      Text(
                        'Cấp ${_user.level} · ${_user.title}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.darkBackground,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.timeline_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Dòng thời gian',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Banner mốc thời gian (Thế kỷ 10)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentEra.timelineSpan,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Bạn đang ở đây · ${_currentEra.centuryTitle}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Còn ${_currentEra.totalEvents - _currentEra.completedEvents} sự kiện nữa là mở mốc tiếp theo',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card sự kiện chính: 938 · Chiến thắng Bạch Đằng
            AppCard(
              isActive: true,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header badge row
                  Row(
                    children: [
                      const StatBadge(type: StatType.ongoing, label: 'HỌC TIẾP'),
                      const Spacer(),
                      Text(
                        'Sự kiện 2 / ${_currentEra.totalEvents}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '${_activeEvent.year} · ${_activeEvent.title}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _activeEvent.summary,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF4A443D),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Badges list
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatBadge(type: StatType.time, label: '${_activeEvent.estimatedMinutes} phút'),
                      StatBadge(type: StatType.xp, label: '+${_activeEvent.xpReward} XP'),
                      StatBadge(type: StatType.coin, label: '+${_activeEvent.coinReward} xu'),
                      if (_activeEvent.rewardCardName != null)
                        StatBadge(type: StatType.reward, label: '${_activeEvent.rewardCardName} nếu 3⭐'),
                    ],
                  ),

                  const SizedBox(height: 18),

                  PrimaryButton(
                    label: 'Bắt đầu học',
                    isFullWidth: true,
                    height: 58,
                    fontSize: 18,
                    icon: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
                    onPressed: () => context.go('/eras/era_1'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section: Thành phẩm Reusable UI Kit của Dev B
            const Text(
              'Thành Phẩm UI Kit (Dev B)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            AppCard(
              title: 'Thử Nghiệm Component Dùng Chung',
              subtitle: 'Bottom Sheet Wrapper & Modal Popup',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Mở Bottom Sheet',
                          icon: const Icon(Icons.vertical_align_top_rounded, color: Colors.white, size: 18),
                          onPressed: _showDemoBottomSheet,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: 'Mở Modal Popup',
                          icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primaryDark, size: 18),
                          onPressed: _showDemoModalDialog,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Nút đang tải (Loading)...',
                          isLoading: true,
                          onPressed: null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
