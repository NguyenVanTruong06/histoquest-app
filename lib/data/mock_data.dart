import 'package:flutter/material.dart';

import 'models/user_model.dart';
import 'models/era_model.dart';
import 'models/historical_event_model.dart';
import 'models/hero_card_model.dart';
import 'models/news_article_model.dart';
import 'models/country_model.dart';

class MockData {
  MockData._();

  /// Quốc gia / nền văn minh mà người chơi đang chọn để khám phá.
  /// Mặc định là Việt Nam vì đây là nội dung duy nhất có dữ liệu thật.
  static String selectedCountryId = 'vn';

  /// Danh sách các quốc gia / nền văn minh có thể chọn (mock — sẽ bổ sung
  /// dữ liệu thật cho Trung Quốc & Ai Cập sau).
  ///
  /// Cơ chế mở khóa: mỗi nền văn minh (trừ Việt Nam — nền văn minh khởi
  /// đầu) chỉ mở khóa sau khi người chơi đạt đủ số mốc lịch sử yêu cầu ở
  /// nền văn minh tiên quyết. Ví dụ: đạt mốc thứ 7 của Việt Nam sẽ mở khóa
  /// Trung Quốc.
  static final List<CountryModel> countries = [
    const CountryModel(
      id: 'vn',
      name: 'Việt Nam',
      subtitle: 'Rồng tiên · 4000 năm dựng nước và giữ nước',
      flagEmoji: '🇻🇳',
      icon: Icons.temple_buddhist_rounded,
      accentColor: Color(0xFFD95D39),
      hasContent: true,
    ),
    const CountryModel(
      id: 'cn',
      name: 'Trung Quốc',
      subtitle: 'Vạn Lý Trường Thành · Các triều đại phong kiến',
      flagEmoji: '🇨🇳',
      icon: Icons.account_balance_rounded,
      accentColor: Color(0xFFC94747),
      hasContent: false,
      requiresCountryId: 'vn',
      requiresMilestoneCount: 7,
      unlockHint:
          'Mở khóa khi bạn đạt mốc lịch sử thứ 7 của nền văn minh Việt Nam.',
    ),
    const CountryModel(
      id: 'eg',
      name: 'Ai Cập',
      subtitle: 'Kim tự tháp · Nền văn minh sông Nile cổ đại',
      flagEmoji: '🇪🇬',
      icon: Icons.change_history_rounded,
      accentColor: Color(0xFFE4A93A),
      hasContent: false,
      requiresCountryId: 'cn',
      requiresMilestoneCount: 5,
      unlockHint:
          'Mở khóa khi bạn đạt mốc lịch sử thứ 5 của nền văn minh Trung Quốc.',
    ),
  ];

  /// Danh sách thời kỳ theo quốc gia đang được chọn
  static List<EraModel> get erasForSelectedCountry =>
      eras.where((e) => e.countryId == selectedCountryId).toList();

  /// Tổng số mốc lịch sử (sự kiện) đã hoàn thành ở một nền văn minh — dùng
  /// làm điều kiện mở khóa nền văn minh kế tiếp.
  static int completedMilestonesForCountry(String countryId) {
    return eras
        .where((e) => e.countryId == countryId)
        .expand((e) => e.events)
        .where((ev) => ev.isCompleted)
        .length;
  }

  /// Nền văn minh [country] đã được mở khóa hay chưa. Nền văn minh không có
  /// điều kiện tiên quyết ([CountryModel.requiresCountryId] == null) luôn
  /// mở sẵn.
  static bool isCountryUnlocked(CountryModel country) {
    final requiredId = country.requiresCountryId;
    if (requiredId == null) return true;
    final required = country.requiresMilestoneCount ?? 0;
    return completedMilestonesForCountry(requiredId) >= required;
  }

  /// Thông tin người dùng hiện tại
  static final UserModel currentUser = UserModel(
    id: 'user_001',
    name: 'An',
    level: 7,
    title: 'Nhà thám hiểm',
    streakDays: 5,
    coins: 1250,
    xp: 350,
    totalQuestsCompleted: 14,
  );

  /// Danh sách thẻ danh tướng thu thập được
  static final List<HeroCardModel> heroCards = [
    const HeroCardModel(
      id: 'card_ngo_quyen',
      heroName: 'Ngô Quyền',
      stars: 3,
      era: 'Thế kỷ 10',
      title: 'Tiền Ngô Vương',
      quote: 'Tiền Ngô Vương có thể lấy quân mới nhóm họp của đất Việt ta mà phá được trăm vạn quân của Lưu Hoằng Tháo.',
      description: 'Anh hùng dân tộc chấm dứt hơn 1000 năm Bắc thuộc bằng trận đại thắng cọc ngầm trên sông Bạch Đằng năm 938.',
      isCollected: true,
    ),
    const HeroCardModel(
      id: 'card_dinh_bo_linh',
      heroName: 'Đinh Bộ Lĩnh',
      stars: 3,
      era: 'Thế kỷ 10',
      title: 'Vạn Thắng Vương · Đinh Tiên Hoàng',
      quote: 'Lấy cờ lau tập trận, bình định 12 sứ quân thu giang sơn về một mối.',
      description: 'Người dẹp loạn 12 sứ quân, lập nên nhà nước phong kiến tập quyền đầu tiên Đại Cồ Việt, xưng Hoàng đế năm 968.',
      isCollected: false,
    ),
    const HeroCardModel(
      id: 'card_ly_thuong_kiet',
      heroName: 'Lý Thường Kiệt',
      stars: 4,
      era: 'Thế kỷ 11',
      title: 'Thái úy Quốc công',
      quote: 'Nam quốc sơn hà Nam đế cư - Tuyệt nhiên định phận tại thiên thư!',
      description: 'Nhà quân sự kiệt xuất với chiến lược tiên phát chế nhân và bản Tuyên ngôn Độc lập đầu tiên bên bờ sông Như Nguyệt.',
      isCollected: false,
    ),
    const HeroCardModel(
      id: 'card_tran_hung_dao',
      heroName: 'Trần Quốc Tuấn',
      stars: 5,
      era: 'Thế kỷ 13',
      title: 'Hưng Đạo Đại Vương',
      quote: 'Nếu bệ hạ muốn hàng, trước hết hãy chém đầu thần rồi hãy hàng!',
      description: 'Thiên tài quân sự ba lần lãnh đạo quân dân Đại Việt đánh tan đế quốc Nguyên Mông hùng mạnh bậc nhất thế giới.',
      isCollected: true,
    ),
    const HeroCardModel(
      id: 'card_quang_trung',
      heroName: 'Quang Trung · Nguyễn Huệ',
      stars: 5,
      era: 'Thế kỷ 18',
      title: 'Bắc Bình Vương · Hoàng đế Tây Sơn',
      quote: 'Đánh cho để dài tóc, đánh cho để đen răng, đánh cho nó chích luân bất phản!',
      description: 'Thần tốc hành quân ra Bắc, đại phá 29 vạn quân Mãn Thanh mùa xuân Kỷ Dậu 1789.',
      isCollected: false,
    ),
  ];

  /// Danh sách các thời kỳ lịch sử & sự kiện chi tiết
  static final List<EraModel> eras = [
    const EraModel(
      id: 'era_1',
      name: 'Thời kỳ Tiền sử',
      centuryTitle: 'Nguồn cội',
      timelineSpan: 'Trước 2879 TCN',
      description: 'Giai đoạn bình minh của loài người, từ vượn người đến các nền văn hóa đồ đá, đồ đồng.',
      isUnlocked: true,
      events: [],
    ),
    const EraModel(
      id: 'era_2',
      name: 'Thời kỳ Cổ đại',
      centuryTitle: 'Thế kỷ 3 TCN - Đầu SCN',
      timelineSpan: '2879 TCN → 905 SCN',
      description: 'Thời kỳ Hùng Vương dựng nước Văn Lang, Âu Lạc và hơn ngàn năm đấu tranh chống Bắc thuộc.',
      isUnlocked: true,
      events: [],
    ),
    const EraModel(
      id: 'era_3',
      name: 'Thời kỳ Trung đại',
      centuryTitle: 'Thế kỷ 10 → 18',
      timelineSpan: '905 → 1858',
      description: 'Kỷ nguyên độc lập tự chủ rực rỡ với các triều đại Ngô, Đinh, Tiền Lê, Lý, Trần, Hậu Lê, Tây Sơn.',
      isUnlocked: true,
      events: [
        HistoricalEventModel(
          id: 'event_905',
          eraId: 'era_3',
          year: 905,
          title: 'Khúc Thừa Dụ xưng Tiết độ sứ',
          summary: 'Mở đầu thời kỳ độc lập tự chủ của người Việt sau ngàn năm lệ thuộc phương Bắc.',
          storyContent:
              'Năm 905, nhân lúc nhà Đường suy yếu, hào trưởng Khúc Thừa Dụ ở Hồng Châu đã lãnh đạo nhân dân đứng lên giành quyền cai quản Giao Châu, tự xưng Tiết độ sứ, đặt nền móng độc lập tự chủ.',
          estimatedMinutes: 4,
          xpReward: 80,
          coinReward: 25,
          isCompleted: true,
        ),
        HistoricalEventModel(
          id: 'event_938',
          eraId: 'era_3',
          year: 938,
          title: 'Chiến thắng Bạch Đằng',
          summary: 'Đọc 3 điều thú vị, rồi thử 4 câu hỏi vui về kế sách cắm cọc sông Bạch Đằng của Ngô Quyền.',
          storyContent:
              'Mùa đông năm 938, đoàn thuyền chiến của giặc Nam Hán do Lưu Hoằng Tháo chỉ huy ồ ạt kéo vào cửa sông Bạch Đằng. '
              'Ngô Quyền đã cho quân đẵn gỗ lim, vót nhọn, bịt sắt rồi đóng cọc ngầm dưới lòng sông. '
              'Khi triều dâng che khuất bãi cọc, thuyền nhẹ của ta vờ khiêu chiến rồi giả thua rút lui. Hoàng Tháo trúng kế đốc thuyền đuổi theo. '
              'Đúng lúc nước thủy triều rút cực nhanh, Ngô Quyền dốc toàn lực phản công. Thuyền giặc đâm vào bãi cọc ngầm thủng vỡ la liệt, Hoằng Tháo đền tội tại trận. '
              'Chiến thắng Bạch Đằng năm 938 đã vĩnh viễn khép lại thời kỳ Bắc thuộc đen tối.',
          estimatedMinutes: 5,
          xpReward: 120,
          coinReward: 40,
          rewardCardName: 'Thẻ Ngô Quyền 3⭐',
          isCompleted: false,
          isCurrentActive: true,
          isMajorMilestone: true,
          questions: [
            QuizQuestionModel(
              id: 'q_938_1',
              question: 'Ngô Quyền đã chọn dòng sông nào để bày trận địa cọc ngầm?',
              options: [
                'Sông Hồng',
                'Sông Bạch Đằng',
                'Sông Như Nguyệt',
                'Sông Đáy',
              ],
              correctAnswerIndex: 1,
              explanation: 'Sông Bạch Đằng có địa hình hiểm yếu, nước triều lên xuống với độ chênh lệch rất lớn, cực kỳ thuận lợi cho trận địa cọc ngầm.',
            ),
            QuizQuestionModel(
              id: 'q_938_2',
              question: 'Tướng giặc Nam Hán bị tử trận trong trận Bạch Đằng năm 938 là ai?',
              options: [
                'Thoát Hoan',
                'Sầm Nghi Đống',
                'Lưu Hoằng Tháo',
                'Ô Mã Nhi',
              ],
              correctAnswerIndex: 2,
              explanation: 'Lưu Hoằng Tháo là con trai vua Nam Hán, chỉ huy quân xâm lược và đã bị tiêu diệt cùng nửa số quân sĩ trên sông Bạch Đằng.',
            ),
            QuizQuestionModel(
              id: 'q_938_3',
              question: 'Ý nghĩa lịch sử vĩ đại nhất của Chiến thắng Bạch Đằng 938 là gì?',
              options: [
                'Chấm dứt hơn 1000 năm Bắc thuộc',
                'Lập nên kinh đô Thăng Long',
                'Đánh bại đế quốc Nguyên Mông',
                'Mở rộng bờ cõi về phía Nam',
              ],
              correctAnswerIndex: 0,
              explanation: 'Chiến thắng này đã đặt dấu chấm hết vĩnh viễn cho hơn 1000 năm Bắc thuộc, khẳng định nền độc lập vững chắc của dân tộc.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_968',
          eraId: 'era_3',
          year: 968,
          title: 'Đinh Bộ Lĩnh dẹp loạn 12 sứ quân',
          summary: 'Thống nhất sơn hà, đặt quốc hiệu Đại Cồ Việt và định đô tại Hoa Lư hiểm trở.',
          storyContent:
              'Sau khi Ngô Quyền mất, đất nước rơi vào cảnh 12 sứ quân tranh giành cát cứ. Đinh Bộ Lĩnh tài thao lược đã lần lượt thu phục và dẹp yên các sứ quân, '
              'lên ngôi Hoàng đế (Đinh Tiên Hoàng), lấy niên hiệu Thái Bình, mở ra triều đại phong kiến tập quyền đầu tiên.',
          estimatedMinutes: 5,
          xpReward: 100,
          coinReward: 35,
          rewardCardName: 'Thẻ Đinh Bộ Lĩnh 3⭐',
          isCompleted: false,
        ),
        HistoricalEventModel(
          id: 'event_981',
          eraId: 'era_3',
          year: 981,
          title: 'Lê Hoàn kháng Tống lần thứ nhất',
          summary: 'Thái hậu Dương Vân Nga trao áo long bào, Lê Hoàn chỉ huy quân dân đánh tan quân Tống.',
          storyContent:
              'Trước nguy cơ xâm lược của nhà Tống, quân dân đồng lòng tôn Lê Hoàn lên ngôi. Bằng chiến lược linh hoạt trên bộ và trên sông Bạch Đằng, Lê Hoàn đã đập tan quân xâm lược Tống năm 981.',
          estimatedMinutes: 6,
          xpReward: 110,
          coinReward: 35,
          isCompleted: false,
          isMajorMilestone: true,
        ),
        HistoricalEventModel(
          id: 'event_1010',
          eraId: 'era_3',
          year: 1010,
          title: 'Lý Thái Tổ dời đô về Thăng Long',
          summary: 'Chiếu dời đô và rồng vàng bay lên, khai sinh mảnh đất kinh đô nghìn năm văn vật.',
          storyContent:
              'Năm Canh Tuất 1010, vua Lý Thái Tổ ban Chiếu dời đô từ Hoa Lư về thành Đại La, đổi tên thành Thăng Long khi thấy hình ảnh rồng vàng bay lên.',
          estimatedMinutes: 4,
          xpReward: 90,
          coinReward: 30,
          isCompleted: false,
        ),
        HistoricalEventModel(
          id: 'event_1077',
          eraId: 'era_3',
          year: 1077,
          title: 'Chiến tuyến sông Như Nguyệt',
          summary: 'Lý Thường Kiệt và bản tuyên ngôn "Nam quốc sơn hà" vang vọng lòng hào lũy.',
          storyContent:
              'Phòng tuyến sông Như Nguyệt được xây dựng kiên cố chặn đứng 10 vạn quân Tống do Quách Quỳ chỉ huy. Bài thơ thần vang lên ban đêm đã bẻ gãy hoàn toàn ý chí giặc.',
          estimatedMinutes: 6,
          xpReward: 130,
          coinReward: 45,
          rewardCardName: 'Thẻ Lý Thường Kiệt 4⭐',
          isCompleted: false,
        ),
      ],
    ),
    const EraModel(
      id: 'era_4',
      name: 'Thời kỳ Cận đại',
      centuryTitle: 'Thế kỷ 19 → Nửa đầu 20',
      timelineSpan: '1858 → 1945',
      description: 'Thời kỳ thực dân Pháp xâm lược và cuộc đấu tranh giải phóng dân tộc dẫn đến Cách mạng tháng Tám.',
      isUnlocked: false,
      events: [],
    ),
    const EraModel(
      id: 'era_5',
      name: 'Thời kỳ Hiện đại',
      centuryTitle: 'Nửa sau Thế kỷ 20',
      timelineSpan: '1945 → 1975',
      description: 'Ba mươi năm kháng chiến trường kỳ bảo vệ nền độc lập và thống nhất đất nước.',
      isUnlocked: false,
      events: [],
    ),
    const EraModel(
      id: 'era_6',
      name: 'Thời kỳ Đương đại',
      centuryTitle: 'Từ 1975 đến nay',
      timelineSpan: '1975 → Hiện tại',
      description: 'Khắc phục hậu quả chiến tranh, đổi mới và hội nhập quốc tế.',
      isUnlocked: false,
      events: [],
    ),
  ];

  /// Danh sách bảng vàng (Leaderboard Mock)
  static final List<Map<String, dynamic>> leaderboard = [
    {
      'rank': 1,
      'name': 'Minh Quân',
      'level': 12,
      'title': 'Bậc thầy sử học',
      'xp': 2850,
      'streak': 28,
    },
    {
      'rank': 2,
      'name': 'Bảo Trâm',
      'level': 10,
      'title': 'Nhà nghiên cứu',
      'xp': 2340,
      'streak': 19,
    },
    {
      'rank': 3,
      'name': 'Tuấn Khang',
      'level': 9,
      'title': 'Khai phá giả',
      'xp': 1980,
      'streak': 14,
    },
    {
      'rank': 4,
      'name': 'An (Bạn)',
      'level': 7,
      'title': 'Nhà thám hiểm',
      'xp': 1450,
      'streak': 5,
    },
    {
      'rank': 5,
      'name': 'Hải Đăng',
      'level': 6,
      'title': 'Tân thủ kỳ cựu',
      'xp': 1120,
      'streak': 8,
    },
  ];
}

/// Dữ liệu giả lập cho Tab Tin tức & Sự kiện tuần (Day 5)
class MockNewsData {
  MockNewsData._();

  /// Sự kiện tuần nổi bật
  static const WeeklyEventModel weeklyEvent = WeeklyEventModel(
    id: 'event_bach_dang_week',
    title: 'Tuần Lễ Khúc Khải Hoàn Bạch Đằng Giang',
    subtitle: 'Tham gia chuỗi thử thách tái hiện mưu kế cọc ngầm của Tiền Ngô Vương',
    badgeText: 'SỰ KIỆN TUẦN',
    expiresText: 'Còn 3 ngày 14 giờ',
    rewardXp: 300,
    rewardCoins: 120,
    actionText: 'Tham Gia Thử Thách',
    questGoal: 'Vượt qua 3 ải lịch sử và đạt điểm tuyệt đối minigame cờ Ô Ăn Quan.',
    progressPercent: 0.65,
  );

  /// Danh mục bài viết
  static const List<String> categories = [
    'Tất cả',
    'Sự kiện tuần',
    'Khảo cổ & Di sản',
    'Nhân vật lịch sử',
    'Bí ẩn kỳ thú',
  ];

  /// Danh sách bài viết lịch sử
  static const List<NewsArticleModel> articles = [
    NewsArticleModel(
      id: 'news_001',
      title: 'Phát hiện bãi cọc Cao Quỳ: Dấu ấn lẫy lừng của kỹ nghệ thủy chiến Đại Việt',
      summary: 'Các nhà khảo cổ học đã khai quật hàng chục thân cọc gỗ lim, sến cắm sâu dưới lòng đất, minh chứng cho nghệ thuật mai phục đỉnh cao.',
      content:
          'Khu di tích bãi cọc Cao Quỳ (Thủy Nguyên, Hải Phòng) được phát hiện vào cuối năm 2019, mở ra góc nhìn hoàn toàn mới về kỹ nghệ đóng cọc ngăn thuyền giặc.\n\n'
          'Theo các chuyên gia Viện Khảo cổ học Việt Nam, các thân cọc có đường kính từ 20 đến 40cm, được cắm theo thế chữ chi so le nhau để giữ chặt và đón đúng lúc thủy triều rút kiệt. Loại gỗ được sử dụng chủ yếu là gỗ sến đỏ và lim xanh có độ chịu nước ngâm mặn cực kỳ cao.\n\n'
          'Đây là minh chứng vật chất trực tiếp xác tín những trang sử hào hùng trong Đại Việt Sử Ký Toàn Thư về mưu lược tài tình của tổ tiên ta.',
      category: 'Khảo cổ & Di sản',
      readTimeMinutes: 4,
      publishedDate: 'Hôm nay · 10:30',
      authorName: 'TS. Lê Văn Khảo',
      historicalQuote: 'Quân Nam Hán hoảng sợ, tự vỡ tan, thuyền giặc đâm vào cọc ngầm đổ úp, quân sĩ chết đuối quá nửa.',
      quoteAuthor: 'Đại Việt Sử Ký Toàn Thư',
      tags: ['Bạch Đằng', 'Khảo cổ', 'Ngô Quyền', 'Hải Phòng'],
      initialLikes: 256,
      commentsCount: 38,
      isFeatured: true,
    ),
    NewsArticleModel(
      id: 'news_002',
      title: 'Nghệ thuật dụng thủy triều của Ngô Quyền: Bài học chiến lược ngàn năm',
      summary: 'Không chỉ cắm cọc, Tiền Ngô Vương đã nắm tường tận chu kỳ con nước sông Bạch Đằng để chọn đúng thời khắc phản công quyết định.',
      content:
          'Cửa sông Bạch Đằng có biên độ thủy triều lên tới 3.5 đến 4 mét mỗi ngày. Ngô Quyền đã cho quân dùng thuyền nhẹ ra khiêu chiến khi nước đang lên, nhử Lưu Hoằng Tháo vượt qua bãi cọc ngầm.\n\n'
          'Khi nước bắt đầu rút xuôi dòng, quân ta bất ngờ quay đầu tổng phản kích dữ dội từ ba mặt. Thuyền giặc to lớn, nặng nề tháo chạy thục mạng đúng lúc cọc nhọn nhô lên, gãy vỡ hàng loạt và bị chôn vùi dưới lòng sông sâu.',
      category: 'Nhân vật lịch sử',
      readTimeMinutes: 5,
      publishedDate: 'Hôm qua',
      authorName: 'Viện Lịch Sử Quân Sự',
      historicalQuote: 'Có thể lấy quân mới nhóm họp của đất Việt ta mà phá tan trăm vạn quân của Lưu Hoằng Tháo, mở ra muôn đời thái bình.',
      quoteAuthor: 'Lê Văn Hưu',
      tags: ['Chiến thuật', 'Thủy triều', 'Ngô Quyền'],
      initialLikes: 412,
      commentsCount: 65,
      isFeatured: false,
    ),
    NewsArticleModel(
      id: 'news_003',
      title: 'Cờ Ô Ăn Quan: Trò chơi dân gian rèn luyện toán học và mưu lược thời xưa',
      summary: 'Ít ai biết trò chơi rải sỏi từng là môn giải trí trí tuệ phổ biến nơi kinh kỳ, dạy trẻ em khả năng tính nhẩm và tư duy chu kỳ.',
      content:
          'Cờ Ô Ăn Quan gắn liền với tuổi thơ người Việt qua nhiều thế hệ. Bàn cờ tượng trưng cho xã hội nông nghiệp xưa: ô Quan trung tâm và các ô Dân trù phú.\n\n'
          'Để giành chiến thắng, người chơi phải dự đoán trước 2 đến 3 lượt đi, tính toán các điểm rơi của sỏi để thực hiện các cú "ăn kép" liên hoàn. Không ít vị quan văn ngày xưa đã dùng trò chơi này để dạy con cháu thuật điều binh khiển tướng.',
      category: 'Bí ẩn kỳ thú',
      readTimeMinutes: 3,
      publishedDate: '2 ngày trước',
      authorName: 'Ban Văn Hóa Dân Gian',
      historicalQuote: 'Bàn cờ vuông vức lòng nhân ái, mười ô dân thảo hai ô quan hiền.',
      quoteAuthor: 'Ca dao cổ truyền',
      tags: ['Trò chơi dân gian', 'Ô Ăn Quan', 'Trí tuệ Việt'],
      initialLikes: 189,
      commentsCount: 22,
      isFeatured: false,
    ),
    NewsArticleModel(
      id: 'news_004',
      title: 'Đinh Tiên Hoàng và bí mật xây dựng kinh đô Hoa Lư giữa thung lũng đá',
      summary: 'Tại sao Vạn Thắng Vương lại chọn dời kinh đô về Hoa Lư thay vì Cổ Loa? Địa thế non sông hiểm trở chính là lá chắn tự nhiên bất khả xâm phạm.',
      content:
          'Năm 968 sau khi dẹp tan 12 sứ quân, Đinh Bộ Lĩnh xưng Hoàng đế và đóng đô ở Hoa Lư (Ninh Bình). Nơi đây được bao bọc bởi hàng trăm ngọn núi đá vôi sừng sững, đan xen cùng hệ thống sông ngòi hào lũy kiên cố.\n\n'
          'Kinh đô Hoa Lư là biểu tượng cho tinh thần độc lập tự chủ và sự khẳng định vị thế quân vương ngang hàng với các triều đại phương Bắc lúc bấy giờ.',
      category: 'Nhân vật lịch sử',
      readTimeMinutes: 6,
      publishedDate: '3 ngày trước',
      authorName: 'Sử gia Nguyễn Khắc',
      historicalQuote: 'Mở mang bờ cõi, dựng nước xưng vương, định đô giữa chốn danh lam hùng vĩ.',
      quoteAuthor: 'Đại Việt Sử Ký',
      tags: ['Đinh Bộ Lĩnh', 'Hoa Lư', 'Thế kỷ 10'],
      initialLikes: 340,
      commentsCount: 47,
      isFeatured: false,
    ),
  ];
}

