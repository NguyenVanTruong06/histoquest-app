import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/quiz_models.dart';
import '../../../data/models/historical_event_model.dart';
import 'widgets/quiz_progress_header.dart';
import 'widgets/single_choice_widget.dart';
import 'widgets/true_false_widget.dart';
import 'widgets/timeline_ordering_widget.dart';
import 'widgets/quiz_explanation_sheet.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizItem>? questions;
  final HistoricalEventModel? event;

  const QuizScreen({
    super.key,
    this.questions,
    this.event,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<QuizItem> _questions;
  int _currentIndex = 0;
  int _correctCount = 0;

  // Trạng thái của câu hỏi hiện tại
  AnswerStatus _currentStatus = AnswerStatus.unanswered;
  int? _selectedSingleChoiceIndex;
  bool? _selectedTrueFalseValue;
  List<TimelineItem> _currentTimelineItems = [];

  @override
  void initState() {
    super.initState();
    // Ưu tiên câu hỏi từ event (Màn 1 → Màn 2), sau đó fallback sang mock data
    if (widget.event != null && widget.event!.questions.isNotEmpty) {
      _questions = widget.event!.questions.map((q) => QuizItem(
        id: q.id,
        type: QuizType.singleChoice,
        question: q.question,
        options: q.options,
        correctIndex: q.correctAnswerIndex,
        explanation: q.explanation,
      )).toList();
    } else {
      _questions = widget.questions ?? MockQuizData.bachDangQuiz;
    }
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
      // Điều hướng sang màn Kết quả (Màn 3)
      context.push(
        '/quiz/result',
        extra: {
          'correctCount': _correctCount,
          'totalCount': _questions.length,
          'event': widget.event,
        },
      );
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
      body: _buildQuizView(),
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

}
