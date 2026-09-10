import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/historical_event_model.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/stat_badge.dart';

class EventDetailScreen extends StatefulWidget {
  final String eraId;
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eraId,
    required this.eventId,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  HistoricalEventModel? _event;
  String _eraName = '';
  String _eraCentury = '';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _loadEvent();
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _loadEvent() {
    for (final era in MockData.eras) {
      if (era.id == widget.eraId) {
        _eraName = era.name;
        _eraCentury = era.centuryTitle;
        for (final event in era.events) {
          if (event.id == widget.eventId) {
            _event = event;
            break;
          }
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Không tìm thấy sự kiện.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final event = _event!;
    final facts = _extractFacts(event.storyContent);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(event),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Giai đoạn lịch sử badge
                      _buildEraBadge(),

                      const SizedBox(height: 16),

                      // Tiêu đề sự kiện
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.6,
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Stat badges hàng ngang
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          StatBadge.time('${event.estimatedMinutes} phút'),
                          StatBadge.xp(event.xpReward),
                          StatBadge.coin(event.coinReward),
                          if (event.rewardCardName != null)
                            StatBadge.reward(event.rewardCardName!),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Đường phân cách
                      _buildDivider(),

                      const SizedBox(height: 20),

                      // Tóm tắt 2–3 câu
                      _buildSectionTitle('📖 Tóm tắt bài học'),
                      const SizedBox(height: 12),
                      _buildSummaryCard(event.summary),

                      const SizedBox(height: 24),

                      // 3 Fact thú vị
                      _buildSectionTitle('💡 Điều thú vị cần biết'),
                      const SizedBox(height: 12),
                      ...facts.asMap().entries.map(
                        (entry) => _buildFactCard(entry.key, entry.value),
                      ),

                      const SizedBox(height: 28),

                      // Phần thưởng nổi bật nếu có thẻ
                      if (event.rewardCardName != null) ...[
                        _buildRewardPreview(event),
                        const SizedBox(height: 28),
                      ],

                      // Nút Bắt đầu Quiz
                      _buildStartButton(event),

                      const SizedBox(height: 16),
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

  Widget _buildAppBar(HistoricalEventModel event) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.darkBackground,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient nền tối cổ kính
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3D2B1F), AppColors.darkBackground],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Pattern trang trí
            Positioned.fill(
              child: Opacity(
                opacity: 0.07,
                child: Image.network(
                  'https://www.transparenttextures.com/patterns/old-map.png',
                  repeat: ImageRepeat.repeat,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
            // Năm sự kiện to ở góc phải
            Positioned(
              right: 20,
              bottom: 24,
              child: Text(
                '${event.year}',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.1),
                  letterSpacing: -4,
                ),
              ),
            ),
            // Nội dung chính
            Positioned(
              left: 20,
              bottom: 20,
              right: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Năm ${event.year}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEraBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.goldLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_edu_rounded, size: 15, color: AppColors.goldDark),
          const SizedBox(width: 6),
          Text(
            '$_eraCentury · $_eraName',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.goldDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.cardBorder, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '✦',
            style: TextStyle(color: AppColors.gold, fontSize: 14),
          ),
        ),
        Expanded(child: Divider(color: AppColors.cardBorder, height: 1)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildSummaryCard(String summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        summary,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
          height: 1.65,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget _buildFactCard(int index, String fact) {
    final colors = [
      AppColors.primaryLight,
      AppColors.goldLight,
      const Color(0xFFE8F4EC),
    ];
    final borderColors = [
      AppColors.primary.withValues(alpha: 0.3),
      AppColors.gold.withValues(alpha: 0.4),
      const Color(0xFF2E8B57).withValues(alpha: 0.25),
    ];
    final iconColors = [
      AppColors.primary,
      AppColors.goldDark,
      const Color(0xFF2E8B57),
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors[index % colors.length],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColors[index % borderColors.length]),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: iconColors[index % iconColors.length].withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: iconColors[index % iconColors.length],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fact,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardPreview(HistoricalEventModel event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFAF0D7), Color(0xFFFBF3E2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE4A93A), Color(0xFFD95D39)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.card_membership_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Phần thưởng hoàn thành',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.goldDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.rewardCardName!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.goldDark),
        ],
      ),
    );
  }

  Widget _buildStartButton(HistoricalEventModel event) {
    final hasQuestions = event.questions.isNotEmpty;
    return PrimaryButton(
      label: hasQuestions ? 'Bắt đầu Quiz →' : 'Đọc bài học',
      isFullWidth: true,
      height: 58,
      icon: Icon(
        hasQuestions ? Icons.quiz_rounded : Icons.menu_book_rounded,
        color: Colors.white,
        size: 21,
      ),
      onPressed: () {
        context.push('/quiz', extra: event);
      },
    );
  }

  /// Trích xuất tối đa 3 câu từ storyContent làm facts
  List<String> _extractFacts(String storyContent) {
    final sentences = storyContent
        .split(RegExp(r'(?<=[.!?。])\s+'))
        .where((s) => s.trim().isNotEmpty)
        .toList();
    if (sentences.length <= 3) return sentences;
    // Lấy câu 1, câu giữa và câu cuối để đa dạng
    return [
      sentences.first,
      sentences[sentences.length ~/ 2],
      sentences.last,
    ];
  }
}
