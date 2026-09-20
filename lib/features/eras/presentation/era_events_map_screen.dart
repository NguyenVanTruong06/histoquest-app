import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/year_format.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/era_model.dart';
import '../../../data/models/historical_event_model.dart';
import '../../../shared/widgets/bottom_sheet_wrapper.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/stat_badge.dart';
import '../../../shared/widgets/app_modal_dialog.dart';
import '../../../shared/widgets/app_empty_view.dart';
import 'widgets/antique_map_background_painter.dart';
import 'widgets/era_map_header.dart';
import 'widgets/map_winding_path_painter.dart';
import 'widgets/map_event_node.dart';

/// Phân loại mốc trên bản đồ Kingdom Rush (Bước 3):
/// - Cứ 3 mốc con liên tiếp thì mốc thứ 3 là mốc lớn ([major]).
/// - Mốc cuối cùng của thời đại luôn là Boss ([boss]) — quiz tổng hợp — bất
///   kể vị trí đó có rơi đúng bội số 3 hay không (ghi đè lên quy tắc trên).
enum _NodeKind { minor, major, boss }

_NodeKind _kindForIndex(int index, int total) {
  if (index == total - 1) return _NodeKind.boss;
  final position = index + 1;
  if (position % 3 == 0) return _NodeKind.major;
  return _NodeKind.minor;
}

MapNodeType _mapNodeType(_NodeKind kind) {
  switch (kind) {
    case _NodeKind.boss:
      return MapNodeType.bossShield;
    case _NodeKind.major:
      return MapNodeType.majorStar;
    case _NodeKind.minor:
      return MapNodeType.minorCircle;
  }
}

/// Màn hình Bản đồ Sự kiện dọc phong cách Kingdom Rush (Bước 3 của tab Bản đồ).
///
/// Cơ chế: cứ 3 mốc con thì có 1 mốc lớn (ngôi sao 6 cánh, vàng); mốc cuối
/// cùng của thời đại luôn là Boss (khiên, đỏ đậm) — một quiz tổng hợp coi
/// như bài kiểm tra cuối chặng. Các mốc phải hoàn thành tuần tự, không thể
/// bỏ qua (mốc chưa mở khóa sẽ rung + báo khi chạm vào).
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
  void _openEventDetails(HistoricalEventModel event, _NodeKind kind) {
    final isBoss = kind == _NodeKind.boss;
    final isMajor = kind == _NodeKind.major;

    final List<Color> gradientColors = isBoss
        ? [AppColors.danger, const Color(0xFF7A2323)]
        : isMajor
            ? [AppColors.gold, AppColors.goldDark]
            : [const Color(0xFF4A443D), const Color(0xFF2A241F)];

    final IconData bgIcon = isBoss
        ? Icons.shield_rounded
        : (isMajor ? Icons.star_rounded : Icons.menu_book_rounded);

    final String badgeLabel = isBoss
        ? 'THỬ THÁCH BOSS'
        : (isMajor ? 'ĐẠI THẮNG BƯỚC NGOẶT' : 'MỐC LỊCH SỬ');

    BottomSheetWrapper.show(
      context,
      title: '${formatHistoricalYear(event.year)} · ${event.title}',
      subtitle: event.summary,
      bottomAction: PrimaryButton(
        label: event.isCompleted
            ? 'Ôn tập mốc này'
            : (isBoss ? 'Vào trận Boss' : 'Bắt đầu học ngay'),
        isFullWidth: true,
        height: 56,
        icon: Icon(
          event.isCompleted ? Icons.replay_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 22,
        ),
        onPressed: () {
          Navigator.pop(context);
          context.push('/eras/${widget.eraId}/events/${event.id}');
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
                colors: gradientColors,
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
                    bgIcon,
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
                          color: isBoss ? Colors.white : AppColors.gold,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                            color: isBoss ? AppColors.danger : AppColors.darkBackground,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hành trình năm ${formatHistoricalYear(event.year)}',
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
      message: 'Sự kiện "${event.title} (Năm ${formatHistoricalYear(event.year)})" đang bị khóa. Hãy hoàn thành các mốc trước để tiếp tục hành trình!',
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
    // (cơ chế tuần tự: không thể bỏ qua mốc nào). Chỉ tính khi thời kỳ này đã
    // có sự kiện — thời kỳ chưa có nội dung (events rỗng) sẽ hiện trạng thái
    // "đang cập nhật" thay vì cố dựng bản đồ trên một danh sách rỗng.
    if (events.isNotEmpty && activeIdx == -1) {
      activeIdx = (completedIdx + 1).clamp(0, events.length - 1);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFD7C79E),
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

            // 2. Khu vực Bản đồ dọc Kingdom Rush — hoặc trạng thái "đang cập
            // nhật" nếu thời kỳ này chưa có mốc sự kiện nào.
            if (events.isEmpty)
              Expanded(
                child: AppEmptyView(
                  icon: Icons.hourglass_empty_rounded,
                  title: 'Thời kỳ đang được cập nhật',
                  message: '"${_era.name}" chưa có mốc sự kiện nào. Hãy quay lại chọn thời kỳ khác nhé!',
                  actionText: 'Quay lại',
                  onActionPressed: () => context.pop(),
                ),
              )
            else
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  // Landscape: màn hình có thể rất rộng, nên giới hạn bề rộng
                  // "bàn cờ" để các node không bị dạt quá xa nhau theo chiều
                  // ngang; phần dư ra hai bên chỉ là nền.
                  final mapWidth = math.min(screenWidth, 640.0);
                  final mapLeftOffset = (screenWidth - mapWidth) / 2;
                  const itemHeight = 185.0;
                  const topOffset = 76.0;
                  final totalMapHeight = topOffset + (events.length * itemHeight) + 130.0;

                  // Tính toán tọa độ tâm của các Node theo đường cong uốn lượn
                  // trái-phải xen kẽ.
                  final List<Offset> nodePositions = [];
                  for (int i = 0; i < events.length; i++) {
                    final double xRatio = (i % 2 == 0) ? 0.32 : 0.68;
                    final double x = mapLeftOffset + (mapWidth * xRatio);
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
                          // 2.0. Nền địa đồ cổ phong (giấy da dê, núi thuỷ mặc,
                          // sông, tùng bách, mây tường vân) — tĩnh nên cô lập
                          // repaint để cuộn mượt.
                          const Positioned.fill(
                            child: RepaintBoundary(
                              child: CustomPaint(
                                painter: AntiqueMapBackgroundPainter(),
                              ),
                            ),
                          ),

                          // 2.1. Đường cổ đạo uốn lượn, dát vàng đoạn đã đi
                          Positioned.fill(
                            child: CustomPaint(
                              painter: MapWindingPathPainter(
                                nodePositions: nodePositions,
                                completedIndex: completedIdx,
                                activeIndex: activeIdx,
                              ),
                            ),
                          ),

                          // 2.2. Điểm xuất phát: cờ trận "XUẤT QUÂN"
                          Positioned(
                            left: nodePositions.first.dx - 52,
                            top: nodePositions.first.dy - 68,
                            child: _buildStartBanner(),
                          ),

                          // 2.3. Dựng các Node sự kiện nối liền nhau, phân loại
                          // minor/major/boss theo vị trí tuần tự.
                          for (int i = 0; i < events.length; i++) ...[
                            _buildPositionedNode(
                              event: events[i],
                              position: nodePositions[i],
                              index: i,
                              total: events.length,
                              activeIdx: activeIdx,
                            ),
                          ],

                          // 2.4. Cột mốc kết thúc chặng (sau Boss)
                          Positioned(
                            left: mapLeftOffset + (mapWidth / 2) - 85,
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
    required int total,
    required int activeIdx,
  }) {
    // Xác định trạng thái của Node — hoàn thành tuần tự, không thể bỏ qua.
    MapNodeState state;
    if (event.isCompleted) {
      state = MapNodeState.completed;
    } else if (index == activeIdx) {
      state = MapNodeState.active;
    } else {
      state = MapNodeState.locked;
    }

    // Phân loại: cứ 3 mốc con → 1 mốc lớn; mốc cuối cùng của thời đại = Boss.
    final kind = _kindForIndex(index, total);
    final nodeType = _mapNodeType(kind);

    const widgetWidth = 190.0;
    // Căn tâm node icon trùng khít với tọa độ đường cong
    const nodeIconCenterYOffset = 74.0;

    return Positioned(
      left: position.dx - (widgetWidth / 2),
      top: position.dy - nodeIconCenterYOffset,
      width: widgetWidth,
      child: Center(
        child: MapEventNode(
          event: event,
          nodeType: nodeType,
          state: state,
          onTap: () => _openEventDetails(event, kind),
          onLockedTap: () => _showLockedAlert(event),
        ),
      ),
    );
  }

  /// Cờ trận "XUẤT QUÂN" ở điểm khởi hành.
  Widget _buildStartBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFA8362B), Color(0xFF5A1712)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFF6D66F), width: 1.6),
        boxShadow: const [
          BoxShadow(color: Color(0x552B2119), offset: Offset(0, 3), blurRadius: 5),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_rounded, color: Color(0xFFF6D66F), size: 14),
          SizedBox(width: 4),
          Text(
            'XUẤT QUÂN',
            style: TextStyle(
              color: Color(0xFFFFF3C4),
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  /// "KHẢI HOÀN MÔN" / bia công thần ở cuối bản đồ, sau khi hạ Boss.
  Widget _buildEraEndCheckpoint() {
    const gold = Color(0xFFF6D66F);
    const goldDeep = Color(0xFFB9861F);
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7A4A26), Color(0xFF4A2A15)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
        border: Border.all(color: goldDeep, width: 2.5),
        boxShadow: const [
          BoxShadow(color: Color(0x662B2119), offset: Offset(0, 4), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2B2119),
              border: Border.all(color: gold, width: 1.5),
            ),
            child: const Icon(Icons.military_tech_rounded, color: gold, size: 22),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'KHẢI HOÀN MÔN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: gold,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  _era.centuryTitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFF3C4),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
