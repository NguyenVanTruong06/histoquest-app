import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/quiz_models.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/stat_badge.dart';
import 'widgets/quiz_progress_header.dart';
import 'widgets/single_choice_widget.dart';
import 'widgets/true_false_widget.dart';
import 'widgets/timeline_ordering_widget.dart';
import 'widgets/quiz_explanation_sheet.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizItem>? questions;

  const QuizScreen({
    super.key,
    this.questions,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<QuizItem> _questions;
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _isFinished = false;

  // Trạng thái của câu hỏi hiện tại
  AnswerStatus _currentStatus = AnswerStatus.unanswered;
  int? _selectedSingleChoiceIndex;
  bool? _selectedTrueFalseValue;
  List<TimelineItem> _currentTimelineItems = [];

  @override
  void initState() {
    super.initState();
    _questions = widget.questions ?? MockQuizData.bachDangQuiz;
    _initCurrentQuestion();
  }

  void _initCurrentQuestion() {
    final item = _questions[_currentIndex];
    _currentStatus = AnswerStatus.unanswered;
    _selectedSingleChoiceIndex = null;
    _selectedTrueFalseValue = null;

    if (item.type == QuizType.timelineOrdering) {
      // Bắt đầu bằng danh sách sự kiện đã xáo trộn
      _currentTimelineItems = List.from(item.timelineItems);
    }
  }

  bool get _isButtonEnabled {
    if (_currentStatus != AnswerStatus.unanswered) return true;
    final item = _questions[_currentIndex];
    switch (item.type) {
      case QuizType.singleChoice:
        return _selectedSingleChoiceIndex != null;
      case QuizType.trueFalse:
        return _selectedTrueFalseValue != null;
      case QuizType.timelineOrdering:
        // Đã có danh sách để kéo thả
        return true;
    }
  }

  void _checkAnswer() {
    final item = _questions[_currentIndex];
    bool isCorrect = false;

    switch (item.type) {
      case QuizType.singleChoice:
        isCorrect = _selectedSingleChoiceIndex == item.correctIndex;
        break;
      case QuizType.trueFalse:
        isCorrect = _selectedTrueFalseValue == item.correctBool;
        break;
      case QuizType.timelineOrdering:
        // Kiểm tra xem thứ tự các ID có khớp hoàn toàn với correctOrderIds không
        final currentOrderIds = _currentTimelineItems.map((e) => e.id).toList();
        isCorrect = _areListsEqual(currentOrderIds, item.correctOrderIds);
        break;
    }

    setState(() {
      _currentStatus = isCorrect ? AnswerStatus.correct : AnswerStatus.incorrect;
      if (isCorrect) _correctCount++;
    });
  }

  bool _areListsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _onContinue() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _initCurrentQuestion();
      });
    } else {
      setState(() {
        _isFinished = true;
      });
    }
  }

  void _onReorderTimeline(int oldIndex, int newIndex) {
    setState(() {
      final item = _currentTimelineItems.removeAt(oldIndex);
      _currentTimelineItems.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isFinished ? _buildResultView() : _buildQuizView(),
    );
  }

  Widget _buildQuizView() {
    final currentItem = _questions[_currentIndex];

    return Column(
      children: [
        // Header thanh tiến trình và nút thoát
        QuizProgressHeader(
          currentStep: _currentIndex + 1,
          totalSteps: _questions.length,
          onExit: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/eras');
            }
          },
        ),

        // Thân câu hỏi có hiệu ứng trượt đổi câu mượt mà
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(currentItem.id),
              child: _buildQuestionContent(currentItem),
            ),
          ),
        ),

        // Khung đáy chứa ô Giải thích và nút Tiếp tục
        QuizExplanationSheet(
          status: _currentStatus,
          isButtonEnabled: _isButtonEnabled,
          isLastQuestion: _currentIndex == _questions.length - 1,
          currentItem: currentItem,
          onCheckAnswer: _checkAnswer,
          onContinue: _onContinue,
        ),
      ],
    );
  }

  Widget _buildQuestionContent(QuizItem item) {
    switch (item.type) {
      case QuizType.singleChoice:
        return SingleChoiceWidget(
          item: item,
          selectedIndex: _selectedSingleChoiceIndex,
          status: _currentStatus,
          onSelectOption: (index) {
            setState(() {
              _selectedSingleChoiceIndex = index;
            });
          },
        );

      case QuizType.trueFalse:
        return TrueFalseWidget(
          item: item,
          selectedValue: _selectedTrueFalseValue,
          status: _currentStatus,
          onSelectValue: (val) {
            setState(() {
              _selectedTrueFalseValue = val;
            });
          },
        );

      case QuizType.timelineOrdering:
        return TimelineOrderingWidget(
          item: item,
          currentItems: _currentTimelineItems,
          status: _currentStatus,
          onReorder: _onReorderTimeline,
        );
    }
  }

  Widget _buildResultView() {
    final isMastery = _correctCount == _questions.length;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cúp vinh danh với gradient vàng
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE4A93A), Color(0xFFD95D39)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                isMastery ? 'Tuyệt Vời! Xuất Sắc!' : 'Hoàn Thành Bài Học!',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '938 · Chiến thắng Bạch Đằng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 20),

              // Thẻ kết quả
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cardBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Kết quả của bạn',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_correctCount / ${_questions.length} Câu đúng',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFF0EAE1)),
                    const SizedBox(height: 12),

                    const Text(
                      'Phần thưởng đã nhận:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        StatBadge(type: StatType.xp, label: '+120 XP'),
                        StatBadge(type: StatType.coin, label: '+40 xu'),
                        StatBadge(type: StatType.reward, label: 'Thẻ Ngô Quyền 3⭐'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                label: 'Trở về Bản Đồ',
                isFullWidth: true,
                height: 56,
                icon: const Icon(Icons.map_rounded, color: Colors.white, size: 20),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/eras');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
