enum QuizType {
  singleChoice,
  trueFalse,
  timelineOrdering,
}

enum AnswerStatus {
  unanswered,
  correct,
  incorrect,
}

class TimelineItem {
  final String id;
  final String title;
  final int year;
  final String description;

  const TimelineItem({
    required this.id,
    required this.title,
    required this.year,
    this.description = '',
  });

  TimelineItem copyWith({
    String? id,
    String? title,
    int? year,
    String? description,
  }) {
    return TimelineItem(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      description: description ?? this.description,
    );
  }
}

class QuizItem {
  final String id;
  final QuizType type;
  final String question;
  final String? subtitle;

  // Dành cho Single Choice (1/4)
  final List<String> options;
  final int? correctIndex;

  // Dành cho True / False
  final bool? correctBool;

  // Dành cho Timeline Ordering (Sắp xếp thứ tự thời gian)
  final List<TimelineItem> timelineItems;
  final List<String> correctOrderIds;

  // Giải thích đáp án sau khi kiểm tra
  final String explanation;
  final String? funFact;

  const QuizItem({
    required this.id,
    required this.type,
    required this.question,
    this.subtitle,
    this.options = const [],
    this.correctIndex,
    this.correctBool,
    this.timelineItems = const [],
    this.correctOrderIds = const [],
    required this.explanation,
    this.funFact,
  });
}

class MockQuizData {
  MockQuizData._();

  static final List<QuizItem> bachDangQuiz = [
    // Dạng 1: Chọn 1 trong 4 (Single Choice)
    const QuizItem(
      id: 'q_1',
      type: QuizType.singleChoice,
      question: 'Ngô Quyền đã chọn dòng sông nào để đóng cọc ngầm đánh tan quân Nam Hán?',
      subtitle: 'Sự kiện năm 938 chấm dứt 1000 năm Bắc thuộc',
      options: [
        'Sông Hồng',
        'Sông Bạch Đằng',
        'Sông Như Nguyệt',
        'Sông Gianh',
      ],
      correctIndex: 1,
      explanation:
          'Sông Bạch Đằng có biên độ thủy triều lên xuống rất lớn và địa thế hiểm trở, Ngô Quyền đã lợi dụng đặc điểm tự nhiên này để giăng bẫy cọc bọc sắt tiêu diệt đạo thuyền chiến giặc.',
      funFact: '💡 Cọc gỗ vót nhọn được bọc sắt ở đầu cắm ngập dưới lòng sông khi nước triều dâng.',
    ),

    // Dạng 2: Đúng / Sai (True / False)
    const QuizItem(
      id: 'q_2',
      type: QuizType.trueFalse,
      question:
          'Chiến thắng Bạch Đằng năm 938 do Đinh Bộ Lĩnh trực tiếp chỉ huy đánh bại quân xâm lược Nam Hán.',
      subtitle: 'Nhận định lịch sử: Đúng hay Sai?',
      correctBool: false,
      explanation:
          'Nhận định này SAI! Người trực tiếp chỉ huy chiến thắng Bạch Đằng năm 938 là Ngô Quyền. Đinh Bộ Lĩnh là vị anh hùng có công dẹp loạn 12 sứ quân và lập nên nhà nước Đại Cồ Việt sau đó (năm 968).',
      funFact: '👑 Ngô Quyền lên ngôi xưng vương, đóng đô tại Cổ Loa.',
    ),

    // Dạng 3: Sắp xếp thứ tự thời gian (Timeline Ordering)
    const QuizItem(
      id: 'q_3',
      type: QuizType.timelineOrdering,
      question: 'Hãy sắp xếp các mốc lịch sử quan trọng của Thế kỷ 10 theo đúng trình tự thời gian từ trước đến sau:',
      subtitle: 'Kéo thả các thẻ sự kiện để xếp theo thứ tự thời gian tăng dần',
      timelineItems: [
        TimelineItem(
          id: 'tl_968',
          title: 'Đinh Bộ Lĩnh dẹp loạn 12 sứ quân, xưng Hoàng đế',
          year: 968,
          description: 'Lập nên nhà nước Đại Cồ Việt',
        ),
        TimelineItem(
          id: 'tl_905',
          title: 'Khúc Thừa Dụ xưng Tiết độ sứ giành quyền tự chủ',
          year: 905,
          description: 'Mở đầu kỷ nguyên tự chủ của người Việt',
        ),
        TimelineItem(
          id: 'tl_981',
          title: 'Lê Hoàn kháng Tống đại thắng trên sông Bạch Đằng',
          year: 981,
          description: 'Bảo vệ nền độc lập non trẻ trước nhà Tống',
        ),
        TimelineItem(
          id: 'tl_938',
          title: 'Ngô Quyền đại phá quân Nam Hán trên sông Bạch Đằng',
          year: 938,
          description: 'Chấm dứt hoàn toàn hơn 1000 năm Bắc thuộc',
        ),
      ],
      correctOrderIds: ['tl_905', 'tl_938', 'tl_968', 'tl_981'],
      explanation:
          'Trình tự thời gian đúng là: Năm 905 (Khúc Thừa Dụ) ➔ Năm 938 (Ngô Quyền Bạch Đằng) ➔ Năm 968 (Đinh Bộ Lĩnh lập nước) ➔ Năm 981 (Lê Hoàn phá Tống).',
      funFact: '📜 Thế kỷ 10 là thế kỷ bản lề vĩ đại nhất của sự nghiệp giành và giữ độc lập tự chủ.',
    ),
  ];
}
