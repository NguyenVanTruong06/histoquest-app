import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/era_model.dart';
import '../../../data/models/historical_event_model.dart';
import '../../../shared/widgets/bottom_sheet_wrapper.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/stat_badge.dart';
import '../../../shared/widgets/app_modal_dialog.dart';
import 'widgets/era_map_header.dart';
import 'widgets/map_winding_path_painter.dart';
import 'widgets/map_event_node.dart';

/// Màn hình Bản đồ Sự kiện uốn lượn phong cách Board Game (Bước 2 trong Gamification)
class EraEventsMapScreen extends StatefulWidget {
  final String eraId;

  const EraEventsMapScreen({
    super.key,
    required this.eraId,
  });

  @override
  State<EraEventsMapScreen> createState() => _EraEventsMapScreenState();
}

class _EraEventsMapScreenState extends State<EraEventsMapScreen> {
  late EraModel _era;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadEraData();
  }

  void _loadEraData() {
    _era = MockData.eras.firstWhere(
      (e) => e.id == widget.eraId,
      orElse: () => MockData.eras.first,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Mở Bottom Sheet xem thông tin chi tiết sự kiện và nút vào Quiz
  void _openEventDetails(HistoricalEventModel event) {
    BottomSheetWrapper.show(
      context,
      title: '${event.year} · ${event.title}',
      subtitle: event.summary,
      bottomAction: PrimaryButton(
        label: event.isCompleted ? 'Ôn tập mốc này' : 'Bắt đầu học ngay',
        isFullWidth: true,
        height: 56,
        icon: Icon(
          event.isCompleted ? Icons.replay_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 22,
        ),
        onPressed: () {
          Navigator.pop(context);
          context.push('/quiz');
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner minh họa lịch sử
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: event.isMajorMilestone
                    ? [const Color(0xFFD95D39), const Color(0xFFA53B20)]
                    : [const Color(0xFF4A443D), const Color(0xFF2A241F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -15,
                  bottom: -20,
                  child: Icon(
                    event.isMajorMilestone ? Icons.star_rounded : Icons.menu_book_rounded,
                    size: 130,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.isMajorMilestone ? 'ĐẠI THẮNG BƯỚC NGOẶT' : 'MỐC LỊCH SỬ',
                          style: const TextStyle(
                            color: AppColors.darkBackground,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hành trình năm ${event.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Phần thưởng hoàn thành:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatBadge(type: StatType.xp, label: '+${event.xpReward} XP'),
              StatBadge(type: StatType.coin, label: '+${event.coinReward} xu'),
              StatBadge(type: StatType.time, label: '${event.estimatedMinutes} phút'),
              if (event.rewardCardName != null)
                StatBadge(type: StatType.reward, label: event.rewardCardName!),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Bối cảnh lịch sử:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            event.storyContent,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// Thông báo khi bấm vào node đang khóa
  void _showLockedAlert(HistoricalEventModel event) {
    AppModalDialog.show(
      context,
      title: 'Mốc Sự Kiện Đang Khóa',
      message: 'Sự kiện "${event.title} (Năm ${event.year})" đang bị khóa. Hãy hoàn thành các mốc trước để tiếp tục hành trình!',
      icon: Icons.lock_clock_rounded,
      confirmText: 'Đã hiểu',
      onConfirm: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = _era.events;
    final user = MockData.currentUser;

    // Tìm index của node đang active và completed
    int completedIdx = -1;
    int activeIdx = -1;

    for (int i = 0; i < events.length; i++) {
      if (events[i].isCompleted) {
        completedIdx = i;
      }
      if (events[i].isCurrentActive) {
        activeIdx = i;
      }
    }

    // Nếu không có node nào active, node đầu tiên chưa hoàn thành sẽ là active
    if (activeIdx == -1) {
      activeIdx = (completedIdx + 1).clamp(0, events.length - 1);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Header thời kỳ & Stats
            EraMapHeader(
              era: _era,
              completedCount: events.where((e) => e.isCompleted).length,
              totalCount: events.length,
              userXp: user.xp,
              userCoins: user.coins,
              streakDays: user.streakDays,
              onBack: () => context.pop(),
            ),

            // 2. Khu vực Bản đồ uốn lượn Board Game
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  const itemHeight = 175.0;
                  const topOffset = 70.0;
                  final totalMapHeight = topOffset + (events.length * itemHeight) + 120.0;

                  // Tính toán tọa độ tâm của các Node theo đường cong hình chữ S
                  final List<Offset> nodePositions = [];
                  for (int i = 0; i < events.length; i++) {
                    // Xen kẽ các mốc lệch trái (30%) và lệch phải (70%)
                    final double xRatio = (i % 2 == 0) ? 0.32 : 0.68;
                    final double x = screenWidth * xRatio;
                    final double y = topOffset + (i * itemHeight);
                    nodePositions.add(Offset(x, y));
                  }

                  return SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: screenWidth,
                      height: totalMapHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 2.1. Vẽ đường uốn lượn Bezier board game ở lớp nền
                          Positioned.fill(
                            child: CustomPaint(
                              painter: MapWindingPathPainter(
                                nodePositions: nodePositions,
                                completedIndex: completedIdx,
                                activeIndex: activeIdx,
                              ),
                            ),
                          ),

                          // 2.2. Điểm xuất phát (Cột mốc mở đầu)
                          Positioned(
                            left: nodePositions.first.dx - 45,
                            top: nodePositions.first.dy - 65,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A443D),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.flag_rounded, color: AppColors.gold, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'XUẤT PHÁT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 2.3. Dựng các Node sự kiện nối liền nhau
                          for (int i = 0; i < events.length; i++) ...[
                            _buildPositionedNode(
                              event: events[i],
                              position: nodePositions[i],
                              index: i,
                              activeIdx: activeIdx,
                            ),
                          ],

                          // 2.4. Cột mốc kết thúc chặng (Rương kho báu / Kỷ nguyên kế)
                          Positioned(
                            left: (screenWidth / 2) - 85,
                            top: totalMapHeight - 110,
                            child: _buildEraEndCheckpoint(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Định vị từng Node sự kiện tại tọa độ đường cong
  Widget _buildPositionedNode({
    required HistoricalEventModel event,
    required Offset position,
    required int index,
    required int activeIdx,
  }) {
    // Xác định trạng thái của Node
    MapNodeState state;
    if (event.isCompleted) {
      state = MapNodeState.completed;
    } else if (index == activeIdx) {
      state = MapNodeState.active;
    } else {
      state = MapNodeState.locked;
    }

    // Phân loại mốc lớn (ngôi sao) hay mốc phụ (vòng tròn)
    final nodeType = event.isMajorMilestone
        ? MapNodeType.majorStar
        : MapNodeType.minorCircle;

    const widgetWidth = 190.0;
    // Căn tâm node icon trùng khít với tọa độ đường cong
    const nodeIconCenterYOffset = 72.0;

    return Positioned(
      left: position.dx - (widgetWidth / 2),
      top: position.dy - nodeIconCenterYOffset,
      width: widgetWidth,
      child: Center(
        child: MapEventNode(
          event: event,
          nodeType: nodeType,
          state: state,
          onTap: () => _openEventDetails(event),
          onLockedTap: () => _showLockedAlert(event),
        ),
      ),
    );
  }

  /// Khối cán đích / Rương kho báu ở cuối bản đồ
  Widget _buildEraEndCheckpoint() {
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2DDD2), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x153A2A1A),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3D6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.military_tech_rounded, color: AppColors.gold, size: 24),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'HOÀN THÀNH',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFB57715),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Thế kỷ 10',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
