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
      assetImagePath: 'assets/images/countries/vn.jpg',
    ),
    const CountryModel(
      id: 'cn',
      name: 'Trung Quốc',
      subtitle: 'Vạn Lý Trường Thành · Các triều đại phong kiến',
      flagEmoji: '🇨🇳',
      icon: Icons.account_balance_rounded,
      accentColor: Color(0xFFC94747),
      hasContent: false,
      assetImagePath: 'assets/images/countries/cn.jpg',
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
      assetImagePath: 'assets/images/countries/eg.jpg',
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
    // -----------------------------------------------------------------
    // Thời kỳ Tiền sử (Trước 2879 TCN)
    // -----------------------------------------------------------------
    const EraModel(
      id: 'era_1',
      name: 'Thời kỳ Tiền sử',
      centuryTitle: 'Nguồn cội',
      timelineSpan: 'Trước 2879 TCN',
      description: 'Giai đoạn bình minh của loài người, từ vượn người đến các nền văn hóa đồ đá, đồ đồng.',
      isUnlocked: true,
      events: [
        HistoricalEventModel(
          id: 'event_nuido',
          eraId: 'era_1',
          year: -500000,
          title: 'Người tối cổ ở núi Đọ',
          summary: 'Dấu tích công cụ đá ghè đẽo cổ xưa nhất được tìm thấy trên đất Việt Nam.',
          storyContent:
              'Tại núi Đọ và núi Quan Yên (Thanh Hóa), các nhà khảo cổ đã phát hiện hàng nghìn công cụ đá ghè đẽo thô sơ của người tối cổ — một trong những dấu tích sớm nhất của loài người trên lãnh thổ Việt Nam. '
              'Đây là thời kỳ đồ đá cũ, khi con người còn sống thành bầy đàn nhỏ bằng săn bắt và hái lượm.',
          estimatedMinutes: 4,
          xpReward: 70,
          coinReward: 20,
          isCompleted: true,
          questions: [
            QuizQuestionModel(
              id: 'q_nuido_1',
              question: 'Di chỉ khảo cổ nào lưu giữ dấu tích người tối cổ sớm nhất ở Việt Nam?',
              options: ['Núi Đọ', 'Hoa Lư', 'Cổ Loa', 'Đông Sơn'],
              correctAnswerIndex: 0,
              explanation: 'Núi Đọ (Thanh Hóa) là nơi phát hiện hàng nghìn công cụ đá ghè đẽo, minh chứng cho sự hiện diện của người tối cổ rất sớm trên đất Việt.',
            ),
            QuizQuestionModel(
              id: 'q_nuido_2',
              question: 'Công cụ lao động của người tối cổ ở núi Đọ được chế tác bằng cách nào?',
              options: ['Mài nhẵn tinh xảo', 'Ghè đẽo thô sơ', 'Đúc bằng đồng', 'Nung bằng đất sét'],
              correctAnswerIndex: 1,
              explanation: 'Ở thời kỳ đồ đá cũ, con người chỉ mới biết ghè đẽo đá thành hình thô sơ để làm công cụ, chưa có kỹ thuật mài.',
            ),
            QuizQuestionModel(
              id: 'q_nuido_3',
              question: 'Người tối cổ thời kỳ này chủ yếu sinh sống bằng hình thức nào?',
              options: ['Trồng lúa nước', 'Săn bắt và hái lượm', 'Buôn bán đường biển', 'Chăn nuôi gia súc lớn'],
              correctAnswerIndex: 1,
              explanation: 'Chưa biết trồng trọt hay chăn nuôi, người tối cổ sống du cư theo bầy đàn nhỏ, dựa vào săn bắt thú rừng và hái lượm quả, củ.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_sonvi',
          eraId: 'era_1',
          year: -20000,
          title: 'Văn hóa Sơn Vi',
          summary: 'Công cụ đá cuội ghè đẽo trải rộng khắp vùng trung du và miền núi phía Bắc.',
          storyContent:
              'Văn hóa Sơn Vi (đặt tên theo di chỉ ở Phú Thọ) là nền văn hóa hậu kỳ đá cũ, đặc trưng bởi các công cụ ghè đẽo từ đá cuội. '
              'Cư dân Sơn Vi sống thành từng nhóm nhỏ, di chuyển theo mùa để săn bắt và hái lượm dọc các thềm sông cổ trải rộng khắp trung du Bắc Bộ.',
          estimatedMinutes: 4,
          xpReward: 75,
          coinReward: 20,
          isCompleted: true,
          questions: [
            QuizQuestionModel(
              id: 'q_sonvi_1',
              question: 'Văn hóa Sơn Vi được đặt tên theo di chỉ khảo cổ ở tỉnh nào?',
              options: ['Phú Thọ', 'Hòa Bình', 'Lạng Sơn', 'Ninh Bình'],
              correctAnswerIndex: 0,
              explanation: 'Di chỉ Sơn Vi thuộc tỉnh Phú Thọ là nơi đặt tên cho nền văn hóa hậu kỳ đá cũ này.',
            ),
            QuizQuestionModel(
              id: 'q_sonvi_2',
              question: 'Công cụ đặc trưng của văn hóa Sơn Vi được chế tác từ chất liệu gì?',
              options: ['Đá cuội', 'Xương động vật', 'Đồng thau', 'Vỏ sò'],
              correctAnswerIndex: 0,
              explanation: 'Cư dân Sơn Vi ghè đẽo các viên đá cuội lấy từ lòng sông để tạo ra công cụ lao động.',
            ),
            QuizQuestionModel(
              id: 'q_sonvi_3',
              question: 'Vì sao cư dân Sơn Vi thường di chuyển chỗ ở theo mùa?',
              options: [
                'Để tránh chiến tranh với bộ lạc khác',
                'Để tìm nguồn thức ăn từ săn bắt, hái lượm',
                'Để buôn bán với vùng khác',
                'Để tránh lũ lụt sông Hồng',
              ],
              correctAnswerIndex: 1,
              explanation: 'Kinh tế săn bắt - hái lượm phụ thuộc vào tự nhiên nên cư dân thời kỳ này phải di chuyển theo mùa để tìm nguồn thức ăn.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_hoabinh',
          eraId: 'era_1',
          year: -10000,
          title: 'Văn hóa Hòa Bình',
          summary: 'Nền văn hóa đá giữa nổi tiếng thế giới với dấu vết nông nghiệp sơ khai.',
          storyContent:
              'Văn hóa Hòa Bình là một trong những nền văn hóa thời đại đá giữa nổi tiếng nhất Đông Nam Á, được đặt theo tên tỉnh Hòa Bình nơi phát hiện đầu tiên. '
              'Cư dân Hòa Bình đã biết mài công cụ đá, và nhiều nhà khoa học cho rằng đây là một trong những nơi con người bắt đầu thuần hóa cây trồng sớm nhất khu vực.',
          estimatedMinutes: 5,
          xpReward: 100,
          coinReward: 30,
          isCompleted: false,
          isCurrentActive: true,
          questions: [
            QuizQuestionModel(
              id: 'q_hoabinh_1',
              question: 'Văn hóa Hòa Bình thuộc thời đại khảo cổ nào?',
              options: ['Đồ đá cũ', 'Đồ đá giữa', 'Đồ đồng', 'Đồ sắt'],
              correctAnswerIndex: 1,
              explanation: 'Văn hóa Hòa Bình là đại diện tiêu biểu của thời đại đá giữa (Trung kỳ đồ đá) ở Đông Nam Á.',
            ),
            QuizQuestionModel(
              id: 'q_hoabinh_2',
              question: 'Điều gì khiến văn hóa Hòa Bình được giới khoa học quốc tế đặc biệt chú ý?',
              options: [
                'Dấu vết luyện kim đầu tiên',
                'Dấu vết nông nghiệp sơ khai',
                'Chữ viết cổ nhất Đông Nam Á',
                'Thành lũy phòng thủ kiên cố',
              ],
              correctAnswerIndex: 1,
              explanation: 'Nhiều nhà khảo cổ cho rằng cư dân Hòa Bình đã bắt đầu thuần hóa một số loại cây trồng, là dấu hiệu nông nghiệp sơ khai hiếm thấy ở thời kỳ này.',
            ),
            QuizQuestionModel(
              id: 'q_hoabinh_3',
              question: 'So với công cụ Sơn Vi, công cụ đá của văn hóa Hòa Bình có điểm gì tiến bộ hơn?',
              options: [
                'Được đúc bằng khuôn kim loại',
                'Bắt đầu có kỹ thuật mài lưỡi',
                'Làm hoàn toàn từ tre nứa',
                'Có khắc chữ tượng hình',
              ],
              correctAnswerIndex: 1,
              explanation: 'Công cụ Hòa Bình bắt đầu xuất hiện kỹ thuật mài ở phần lưỡi, tinh xảo hơn so với công cụ ghè đẽo hoàn toàn của văn hóa Sơn Vi trước đó.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_bacson',
          eraId: 'era_1',
          year: -6000,
          title: 'Văn hóa Bắc Sơn',
          summary: 'Kỹ thuật mài đá và làm gốm bắt đầu xuất hiện, đánh dấu bước tiến của thời đại đá mới.',
          storyContent:
              'Văn hóa Bắc Sơn (Lạng Sơn) kế thừa và phát triển từ văn hóa Hòa Bình, nổi bật với kỹ thuật mài lưỡi rìu đá thành thạo hơn và những mảnh gốm thô sơ đầu tiên — '
              'bước tiến quan trọng đưa con người bước vào thời đại đồ đá mới.',
          estimatedMinutes: 4,
          xpReward: 90,
          coinReward: 25,
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_bacson_1',
              question: 'Văn hóa Bắc Sơn được đặt tên theo địa danh thuộc tỉnh nào?',
              options: ['Lạng Sơn', 'Hòa Bình', 'Phú Thọ', 'Thanh Hóa'],
              correctAnswerIndex: 0,
              explanation: 'Văn hóa Bắc Sơn được đặt tên theo dãy núi Bắc Sơn thuộc tỉnh Lạng Sơn ngày nay.',
            ),
            QuizQuestionModel(
              id: 'q_bacson_2',
              question: 'Kỹ thuật mới nào lần đầu xuất hiện rõ nét ở văn hóa Bắc Sơn?',
              options: ['Mài lưỡi rìu đá', 'Đúc trống đồng', 'Dệt vải tơ tằm', 'Xây thành lũy đá'],
              correctAnswerIndex: 0,
              explanation: 'Cư dân Bắc Sơn đã thành thạo kỹ thuật mài lưỡi công cụ đá — dấu hiệu đặc trưng gọi tên "kỹ thuật Bắc Sơn" trong khảo cổ học.',
            ),
            QuizQuestionModel(
              id: 'q_bacson_3',
              question: 'Văn hóa Bắc Sơn đánh dấu bước chuyển sang thời đại khảo cổ nào?',
              options: ['Đồ đá cũ', 'Đồ đá giữa', 'Đồ đá mới', 'Đồ sắt'],
              correctAnswerIndex: 2,
              explanation: 'Với kỹ thuật mài đá và làm gốm sơ khai, văn hóa Bắc Sơn đánh dấu bước chuyển từ đá giữa sang thời đại đồ đá mới.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_halong',
          eraId: 'era_1',
          year: -4000,
          title: 'Văn hóa Hạ Long & Quỳnh Văn',
          summary: 'Cư dân ven biển chế tác đồ trang sức vỏ ốc và công cụ đá tinh xảo.',
          storyContent:
              'Ở vùng ven biển Đông Bắc và Bắc Trung Bộ, các văn hóa Hạ Long và Quỳnh Văn cho thấy cư dân thời đá mới đã biết khai thác nguồn lợi biển, '
              'chế tác đồ trang sức từ vỏ ốc và những công cụ đá được mài nhẵn tinh xảo hơn hẳn các giai đoạn trước.',
          estimatedMinutes: 4,
          xpReward: 95,
          coinReward: 28,
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_halong_1',
              question: 'Văn hóa Hạ Long và Quỳnh Văn phân bố chủ yếu ở khu vực nào?',
              options: ['Vùng núi cao Tây Bắc', 'Vùng ven biển', 'Cao nguyên Trung phần', 'Đồng bằng sông Cửu Long'],
              correctAnswerIndex: 1,
              explanation: 'Đây là các văn hóa ven biển, cư dân sinh sống dựa nhiều vào nguồn lợi từ biển.',
            ),
            QuizQuestionModel(
              id: 'q_halong_2',
              question: 'Cư dân Hạ Long chế tác đồ trang sức chủ yếu từ nguyên liệu nào?',
              options: ['Vỏ ốc, vỏ sò', 'Đồng thau', 'Ngọc bích', 'Xương voi'],
              correctAnswerIndex: 0,
              explanation: 'Vỏ ốc và vỏ sò là nguyên liệu phổ biến, dễ khai thác ven biển, được cư dân Hạ Long dùng làm đồ trang sức.',
            ),
            QuizQuestionModel(
              id: 'q_halong_3',
              question: 'So với công cụ Bắc Sơn, công cụ đá của văn hóa Hạ Long có đặc điểm gì?',
              options: [
                'Thô sơ, chưa mài',
                'Được mài nhẵn tinh xảo hơn',
                'Chỉ làm từ tre nứa',
                'Chưa từng được tìm thấy',
              ],
              correctAnswerIndex: 1,
              explanation: 'Công cụ đá của văn hóa Hạ Long được mài nhẵn tinh xảo hơn, thể hiện kỹ thuật chế tác đá phát triển thêm một bước.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_phungnguyen',
          eraId: 'era_1',
          year: -2900,
          title: 'Văn hóa Phùng Nguyên',
          summary: 'Nền văn hóa mở đầu thời đại kim khí, đặt nền móng cho sự ra đời của nhà nước Văn Lang.',
          storyContent:
              'Văn hóa Phùng Nguyên (Phú Thọ) đánh dấu buổi bình minh của thời đại kim khí ở Việt Nam, với những dấu vết luyện đồng sơ khai đầu tiên. '
              'Đây chính là nền tảng vật chất và xã hội để các bộ lạc Lạc Việt dần hợp nhất, tiến tới lập nên nhà nước Văn Lang của các Vua Hùng ngay sau đó.',
          estimatedMinutes: 5,
          xpReward: 140,
          coinReward: 45,
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_phungnguyen_1',
              question: 'Văn hóa Phùng Nguyên đánh dấu bước mở đầu của thời đại nào?',
              options: ['Đồ đá cũ', 'Đồ đá giữa', 'Đồ đá mới', 'Đồ kim khí (đồng)'],
              correctAnswerIndex: 3,
              explanation: 'Phùng Nguyên là nền văn hóa mở đầu thời đại kim khí, với dấu vết luyện đồng sơ khai đầu tiên trên đất Việt.',
            ),
            QuizQuestionModel(
              id: 'q_phungnguyen_2',
              question: 'Văn hóa Phùng Nguyên được phát hiện ở tỉnh nào?',
              options: ['Phú Thọ', 'Lạng Sơn', 'Hòa Bình', 'Quảng Ninh'],
              correctAnswerIndex: 0,
              explanation: 'Di chỉ Phùng Nguyên thuộc tỉnh Phú Thọ — cũng chính là vùng đất gắn liền với truyền thuyết các Vua Hùng dựng nước sau này.',
            ),
            QuizQuestionModel(
              id: 'q_phungnguyen_3',
              question: 'Văn hóa Phùng Nguyên có ý nghĩa gì đối với lịch sử dân tộc?',
              options: [
                'Đặt nền móng cho sự ra đời nhà nước Văn Lang',
                'Chấm dứt hơn 1000 năm Bắc thuộc',
                'Mở đầu triều đại nhà Lý',
                'Đánh bại quân Nguyên Mông',
              ],
              correctAnswerIndex: 0,
              explanation: 'Những tiến bộ kỹ thuật và xã hội của văn hóa Phùng Nguyên đã tạo tiền đề để các bộ lạc Lạc Việt hợp nhất, hình thành nhà nước Văn Lang.',
            ),
          ],
        ),
      ],
    ),

    // -----------------------------------------------------------------
    // Thời kỳ Cổ đại (2879 TCN → 905 SCN)
    // -----------------------------------------------------------------
    const EraModel(
      id: 'era_2',
      name: 'Thời kỳ Cổ đại',
      centuryTitle: 'Thế kỷ 3 TCN - Đầu SCN',
      timelineSpan: '2879 TCN → 905 SCN',
      description: 'Thời kỳ Hùng Vương dựng nước Văn Lang, Âu Lạc và hơn ngàn năm đấu tranh chống Bắc thuộc.',
      isUnlocked: true,
      events: [
        HistoricalEventModel(
          id: 'event_vanlang',
          eraId: 'era_2',
          year: -2879,
          title: 'Hùng Vương dựng nước Văn Lang',
          summary: 'Nhà nước đầu tiên của người Việt ra đời, mở đầu truyền thống dựng nước và giữ nước.',
          storyContent:
              'Theo truyền thuyết, năm 2879 TCN, Vua Hùng thứ nhất đã hợp nhất các bộ lạc Lạc Việt, lập nên nhà nước Văn Lang — nhà nước đầu tiên trong lịch sử dân tộc, đóng đô ở Phong Châu (Phú Thọ ngày nay). '
              'Đây là cột mốc thiêng liêng mở đầu 4000 năm dựng nước và giữ nước của người Việt.',
          estimatedMinutes: 5,
          xpReward: 100,
          coinReward: 30,
          rewardCardName: 'Thẻ Vua Hùng 3⭐',
          isCompleted: true,
          questions: [
            QuizQuestionModel(
              id: 'q_vanlang_1',
              question: 'Nhà nước đầu tiên của người Việt mang tên gì?',
              options: ['Âu Lạc', 'Văn Lang', 'Đại Cồ Việt', 'Đại Việt'],
              correctAnswerIndex: 1,
              explanation: 'Văn Lang là nhà nước đầu tiên trong lịch sử Việt Nam, do các Vua Hùng lập nên.',
            ),
            QuizQuestionModel(
              id: 'q_vanlang_2',
              question: 'Kinh đô của nhà nước Văn Lang đặt ở đâu?',
              options: ['Phong Châu (Phú Thọ)', 'Cổ Loa (Hà Nội)', 'Hoa Lư (Ninh Bình)', 'Thăng Long'],
              correctAnswerIndex: 0,
              explanation: 'Phong Châu, thuộc Phú Thọ ngày nay, là kinh đô của nhà nước Văn Lang thời các Vua Hùng.',
            ),
            QuizQuestionModel(
              id: 'q_vanlang_3',
              question: 'Ai là người lập ra nhà nước Văn Lang theo truyền thuyết?',
              options: ['An Dương Vương', 'Vua Hùng', 'Triệu Đà', 'Hai Bà Trưng'],
              correctAnswerIndex: 1,
              explanation: 'Theo truyền thuyết, Vua Hùng thứ nhất đã hợp nhất các bộ lạc Lạc Việt, lập nên nhà nước Văn Lang.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_audialac',
          eraId: 'era_2',
          year: -258,
          title: 'An Dương Vương lập nước Âu Lạc',
          summary: 'Thục Phán thống nhất Âu Việt - Lạc Việt, xây thành Cổ Loa với nỏ thần huyền thoại.',
          storyContent:
              'Năm 258 TCN, Thục Phán đánh bại Vua Hùng thứ 18, hợp nhất bộ tộc Âu Việt và Lạc Việt, lập nên nước Âu Lạc, tự xưng An Dương Vương. '
              'Ông cho xây thành Cổ Loa hình xoáy trôn ốc kiên cố và chế tạo nỏ thần Kim Quy — biểu tượng cho trí tuệ quân sự của người Việt cổ.',
          estimatedMinutes: 5,
          xpReward: 105,
          coinReward: 32,
          isCompleted: true,
          questions: [
            QuizQuestionModel(
              id: 'q_audialac_1',
              question: 'Ai là người lập ra nước Âu Lạc?',
              options: ['Vua Hùng', 'Thục Phán (An Dương Vương)', 'Triệu Đà', 'Lý Bí'],
              correctAnswerIndex: 1,
              explanation: 'Thục Phán hợp nhất Âu Việt và Lạc Việt, lập nước Âu Lạc và tự xưng An Dương Vương.',
            ),
            QuizQuestionModel(
              id: 'q_audialac_2',
              question: 'Kinh đô của nước Âu Lạc là thành nào?',
              options: ['Thành Cổ Loa', 'Thành Hoa Lư', 'Thành Thăng Long', 'Thành Đại La'],
              correctAnswerIndex: 0,
              explanation: 'An Dương Vương cho xây thành Cổ Loa hình xoáy trôn ốc làm kinh đô của Âu Lạc.',
            ),
            QuizQuestionModel(
              id: 'q_audialac_3',
              question: 'Vũ khí huyền thoại nào gắn liền với An Dương Vương?',
              options: ['Gươm thần', 'Nỏ thần Kim Quy', 'Cung tên bạc', 'Giáo thần'],
              correctAnswerIndex: 1,
              explanation: 'Truyền thuyết kể rằng An Dương Vương có nỏ thần Kim Quy, một phát bắn ra hàng trăm mũi tên, giúp bảo vệ Âu Lạc.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_trieuda',
          eraId: 'era_2',
          year: -179,
          title: 'Triệu Đà xâm lược Âu Lạc',
          summary: 'Mỵ Châu - Trọng Thủy và bài học cảnh giác mất nước, mở đầu hơn 1000 năm Bắc thuộc.',
          storyContent:
              'Năm 179 TCN, Triệu Đà đem quân xâm lược Âu Lạc. Do mất cảnh giác trước mưu kế Trọng Thủy - Mỵ Châu, An Dương Vương để lộ bí mật nỏ thần và thất bại. '
              'Âu Lạc rơi vào tay Triệu Đà, mở đầu hơn một nghìn năm Bắc thuộc đầy gian khổ của dân tộc.',
          estimatedMinutes: 6,
          xpReward: 130,
          coinReward: 40,
          isCompleted: false,
          isCurrentActive: true,
          questions: [
            QuizQuestionModel(
              id: 'q_trieuda_1',
              question: 'Ai là người đem quân xâm lược và đánh bại Âu Lạc năm 179 TCN?',
              options: ['Triệu Đà', 'Mã Viện', 'Tô Định', 'Lưu Hoằng Tháo'],
              correctAnswerIndex: 0,
              explanation: 'Triệu Đà, vua nước Nam Việt, đã đem quân xâm lược và thôn tính Âu Lạc năm 179 TCN.',
            ),
            QuizQuestionModel(
              id: 'q_trieuda_2',
              question: 'Câu chuyện nào gắn liền với sự thất bại của An Dương Vương?',
              options: [
                'Mỵ Châu - Trọng Thủy',
                'Sơn Tinh - Thủy Tinh',
                'Thánh Gióng',
                'Chử Đồng Tử - Tiên Dung',
              ],
              correctAnswerIndex: 0,
              explanation: 'Truyền thuyết Mỵ Châu - Trọng Thủy kể về việc bí mật nỏ thần bị lộ, dẫn đến thất bại của An Dương Vương.',
            ),
            QuizQuestionModel(
              id: 'q_trieuda_3',
              question: 'Sự kiện Âu Lạc thất bại năm 179 TCN mở đầu giai đoạn nào trong lịch sử Việt Nam?',
              options: [
                'Thời kỳ Bắc thuộc',
                'Thời kỳ độc lập tự chủ',
                'Thời kỳ Pháp thuộc',
                'Thời kỳ phong kiến tập quyền',
              ],
              correctAnswerIndex: 0,
              explanation: 'Đây là cột mốc mở đầu hơn 1000 năm Bắc thuộc, giai đoạn đầy gian khổ trước khi Ngô Quyền giành lại độc lập năm 938.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_hbatrung',
          eraId: 'era_2',
          year: 40,
          title: 'Khởi nghĩa Hai Bà Trưng',
          summary: 'Trưng Trắc, Trưng Nhị phất cờ khởi nghĩa, giành lại độc lập trong 3 năm ngắn ngủi.',
          storyContent:
              'Năm 40, Hai Bà Trưng (Trưng Trắc, Trưng Nhị) phất cờ khởi nghĩa ở Mê Linh, được các nữ tướng và nhân dân khắp nơi hưởng ứng. '
              'Cuộc khởi nghĩa nhanh chóng đánh đuổi Thái thú Tô Định, giành lại độc lập cho đất nước — đây là cuộc khởi nghĩa lớn đầu tiên của phụ nữ Việt Nam chống ngoại xâm.',
          estimatedMinutes: 5,
          xpReward: 115,
          coinReward: 35,
          rewardCardName: 'Thẻ Hai Bà Trưng 4⭐',
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_hbatrung_1',
              question: 'Hai Bà Trưng phất cờ khởi nghĩa ở đâu?',
              options: ['Mê Linh', 'Hoa Lư', 'Cổ Loa', 'Lam Sơn'],
              correctAnswerIndex: 0,
              explanation: 'Mê Linh (Hà Nội ngày nay) là nơi Hai Bà Trưng phất cờ khởi nghĩa năm 40.',
            ),
            QuizQuestionModel(
              id: 'q_hbatrung_2',
              question: 'Viên Thái thú nhà Hán bị Hai Bà Trưng đánh đuổi là ai?',
              options: ['Tô Định', 'Mã Viện', 'Sĩ Nhiếp', 'Cao Biền'],
              correctAnswerIndex: 0,
              explanation: 'Thái thú Tô Định cai trị hà khắc đã bị nghĩa quân Hai Bà Trưng đánh đuổi, buộc phải chạy trốn về nước.',
            ),
            QuizQuestionModel(
              id: 'q_hbatrung_3',
              question: 'Ý nghĩa nổi bật của khởi nghĩa Hai Bà Trưng là gì?',
              options: [
                'Cuộc khởi nghĩa lớn đầu tiên do phụ nữ lãnh đạo',
                'Chấm dứt hoàn toàn Bắc thuộc',
                'Lập nên nhà nước Đại Cồ Việt',
                'Mở đầu triều đại nhà Lý',
              ],
              correctAnswerIndex: 0,
              explanation: 'Đây là cuộc khởi nghĩa lớn đầu tiên trong lịch sử do phụ nữ lãnh đạo, thể hiện tinh thần bất khuất của dân tộc.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_batrieu',
          eraId: 'era_2',
          year: 248,
          title: 'Khởi nghĩa Bà Triệu',
          summary: '"Tôi muốn cưỡi cơn gió mạnh..." — lời hịch bất hủ của nữ tướng Triệu Thị Trinh.',
          storyContent:
              'Năm 248, Bà Triệu (Triệu Thị Trinh) dấy binh khởi nghĩa ở vùng Thanh Hóa, quyết tâm đánh đuổi quân Ngô đô hộ. '
              'Câu nói bất hủ "Tôi muốn cưỡi cơn gió mạnh, đạp luồng sóng dữ, chém cá kình ở biển khơi..." đã trở thành biểu tượng cho ý chí quật cường của phụ nữ Việt Nam.',
          estimatedMinutes: 5,
          xpReward: 110,
          coinReward: 35,
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_batrieu_1',
              question: 'Bà Triệu khởi nghĩa chống lại thế lực đô hộ nào?',
              options: ['Nhà Hán', 'Nhà Ngô', 'Nhà Đường', 'Nhà Tống'],
              correctAnswerIndex: 1,
              explanation: 'Năm 248, Bà Triệu khởi nghĩa chống lại ách đô hộ của nhà Ngô (Trung Quốc thời Tam Quốc).',
            ),
            QuizQuestionModel(
              id: 'q_batrieu_2',
              question: 'Bà Triệu dấy binh khởi nghĩa chủ yếu ở vùng đất nào?',
              options: ['Thanh Hóa', 'Mê Linh', 'Nghệ An', 'Ninh Bình'],
              correctAnswerIndex: 0,
              explanation: 'Bà Triệu quê ở vùng núi Nưa (Thanh Hóa) và dấy binh khởi nghĩa từ chính vùng đất này.',
            ),
            QuizQuestionModel(
              id: 'q_batrieu_3',
              question: 'Câu nói bất hủ nào gắn liền với Bà Triệu?',
              options: [
                '"Tôi muốn cưỡi cơn gió mạnh, đạp luồng sóng dữ..."',
                '"Nam quốc sơn hà Nam đế cư"',
                '"Đánh cho để dài tóc..."',
                '"Thà làm quỷ nước Nam..."',
              ],
              correctAnswerIndex: 0,
              explanation: 'Câu nói thể hiện khí phách quật cường của Bà Triệu, trở thành biểu tượng bất khuất của phụ nữ Việt Nam.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_lybi',
          eraId: 'era_2',
          year: 542,
          title: 'Lý Bí khởi nghĩa, lập nước Vạn Xuân',
          summary: 'Lý Nam Đế xưng đế, đặt quốc hiệu Vạn Xuân — nhà nước độc lập đầu tiên sau Bắc thuộc.',
          storyContent:
              'Năm 542, Lý Bí lãnh đạo nhân dân khởi nghĩa đánh đuổi quân Lương, giành lại quyền tự chủ. Năm 544, ông lên ngôi hoàng đế, xưng là Lý Nam Đế, đặt quốc hiệu Vạn Xuân với ước vọng đất nước trường tồn mãi mãi như vạn mùa xuân. '
              'Đây là lần đầu tiên kể từ thời An Dương Vương, người Việt lập lại một nhà nước độc lập, tự chủ hoàn chỉnh, khép lại thời kỳ Cổ đại và mở đường cho hành trình giành độc lập lâu dài về sau.',
          estimatedMinutes: 6,
          xpReward: 150,
          coinReward: 50,
          rewardCardName: 'Thẻ Lý Nam Đế 4⭐',
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_lybi_1',
              question: 'Lý Bí khởi nghĩa đánh đuổi quân đô hộ của triều đại nào?',
              options: ['Nhà Lương', 'Nhà Hán', 'Nhà Đường', 'Nhà Tống'],
              correctAnswerIndex: 0,
              explanation: 'Năm 542, Lý Bí lãnh đạo khởi nghĩa đánh đuổi ách đô hộ của nhà Lương (Trung Quốc).',
            ),
            QuizQuestionModel(
              id: 'q_lybi_2',
              question: 'Sau khi giành thắng lợi, Lý Bí đặt quốc hiệu là gì?',
              options: ['Vạn Xuân', 'Đại Cồ Việt', 'Đại Việt', 'Âu Lạc'],
              correctAnswerIndex: 0,
              explanation: 'Lý Bí lên ngôi xưng Lý Nam Đế, đặt quốc hiệu Vạn Xuân, thể hiện ước vọng đất nước trường tồn.',
            ),
            QuizQuestionModel(
              id: 'q_lybi_3',
              question: 'Sự kiện Lý Bí lập nước Vạn Xuân có ý nghĩa lịch sử gì?',
              options: [
                'Lần đầu người Việt lập lại nhà nước độc lập sau An Dương Vương',
                'Chấm dứt vĩnh viễn hơn 1000 năm Bắc thuộc',
                'Mở đầu triều đại nhà Lý ở Thăng Long',
                'Đánh bại quân Nguyên Mông lần thứ nhất',
              ],
              correctAnswerIndex: 0,
              explanation: 'Vạn Xuân là nhà nước độc lập, tự chủ hoàn chỉnh đầu tiên của người Việt kể từ thời An Dương Vương, dù sau đó còn trải qua nhiều biến động trước khi Ngô Quyền chấm dứt hẳn Bắc thuộc năm 938.',
            ),
          ],
        ),
      ],
    ),

    // -----------------------------------------------------------------
    // Thời kỳ Trung đại (905 → 1858) — dữ liệu đầy đủ nhất, giữ nguyên.
    // -----------------------------------------------------------------
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
          questions: [
            QuizQuestionModel(
              id: 'q_905_1',
              question: 'Khúc Thừa Dụ tự xưng chức gì để nắm quyền tự chủ Giao Châu?',
              options: [
                'Hoàng đế',
                'Tiết độ sứ',
                'Thái thú',
                'Đô hộ sứ',
              ],
              correctAnswerIndex: 1,
              explanation: 'Khúc Thừa Dụ tự xưng Tiết độ sứ — chức quan đầu triều do nhà Đường phong ở An Nam — nhưng thực chất là để nắm trọn quyền tự chủ cho người Việt.',
            ),
            QuizQuestionModel(
              id: 'q_905_2',
              question: 'Khúc Thừa Dụ giành quyền tự chủ trong bối cảnh nào?',
              options: [
                'Nhà Đường đang cực thịnh',
                'Nhà Đường suy yếu',
                'Nhà Hán mới lập quốc',
                'Nhà Tống vừa thống nhất Trung Hoa',
              ],
              correctAnswerIndex: 1,
              explanation: 'Cuối thế kỷ 9, nhà Đường suy yếu nghiêm trọng, tạo thời cơ để Khúc Thừa Dụ nổi dậy giành quyền tự chủ cho Giao Châu.',
            ),
            QuizQuestionModel(
              id: 'q_905_3',
              question: 'Sự kiện năm 905 có ý nghĩa lịch sử gì?',
              options: [
                'Mở đầu thời kỳ tự chủ của người Việt',
                'Chấm dứt hoàn toàn hơn 1000 năm Bắc thuộc',
                'Thống nhất 12 sứ quân',
                'Dời đô về Thăng Long',
              ],
              correctAnswerIndex: 0,
              explanation: 'Đây là bước đệm quan trọng, mở đầu kỷ nguyên tự chủ, tạo tiền đề để Ngô Quyền hoàn tất việc chấm dứt Bắc thuộc năm 938.',
            ),
          ],
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
          questions: [
            QuizQuestionModel(
              id: 'q_968_1',
              question: 'Sau khi dẹp loạn 12 sứ quân, Đinh Bộ Lĩnh đặt quốc hiệu là gì?',
              options: [
                'Đại Việt',
                'Đại Cồ Việt',
                'Văn Lang',
                'Âu Lạc',
              ],
              correctAnswerIndex: 1,
              explanation: 'Đinh Bộ Lĩnh lên ngôi Hoàng đế, đặt quốc hiệu Đại Cồ Việt — nhà nước phong kiến tập quyền đầu tiên của người Việt.',
            ),
            QuizQuestionModel(
              id: 'q_968_2',
              question: 'Đinh Tiên Hoàng chọn nơi nào làm kinh đô?',
              options: [
                'Thăng Long',
                'Hoa Lư',
                'Cổ Loa',
                'Phú Xuân',
              ],
              correctAnswerIndex: 1,
              explanation: 'Hoa Lư (Ninh Bình ngày nay) với địa thế núi non hiểm trở được chọn làm kinh đô để phòng thủ trước các thế lực bên ngoài.',
            ),
            QuizQuestionModel(
              id: 'q_968_3',
              question: 'Niên hiệu của Đinh Tiên Hoàng sau khi lên ngôi là gì?',
              options: [
                'Thái Bình',
                'Thiên Phúc',
                'Ứng Thiên',
                'Hưng Thống',
              ],
              correctAnswerIndex: 0,
              explanation: 'Đinh Tiên Hoàng lấy niên hiệu Thái Bình, thể hiện khát vọng chấm dứt loạn lạc, mang lại thái bình cho đất nước.',
            ),
          ],
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
          questions: [
            QuizQuestionModel(
              id: 'q_981_1',
              question: 'Ai là người đã trao áo long bào, tôn Lê Hoàn lên ngôi để kháng Tống?',
              options: [
                'Dương Vân Nga',
                'Ỷ Lan Nguyên phi',
                'Huyền Trân Công chúa',
                'Nguyên phi Ỷ Lan',
              ],
              correctAnswerIndex: 0,
              explanation: 'Thái hậu Dương Vân Nga đã khoác áo long bào lên vai Lê Hoàn trước ba quân, tôn ông lên ngôi để kịp thời chống giặc Tống.',
            ),
            QuizQuestionModel(
              id: 'q_981_2',
              question: 'Lê Hoàn đánh tan quân Tống chủ yếu trên dòng sông nào?',
              options: [
                'Sông Như Nguyệt',
                'Sông Bạch Đằng',
                'Sông Hồng',
                'Sông Mã',
              ],
              correctAnswerIndex: 1,
              explanation: 'Lê Hoàn tiếp tục phát huy thế trận sông Bạch Đằng — nơi Ngô Quyền từng đại thắng — để đánh bại quân xâm lược Tống.',
            ),
            QuizQuestionModel(
              id: 'q_981_3',
              question: 'Chiến thắng năm 981 có ý nghĩa gì với Đại Cồ Việt?',
              options: [
                'Bảo vệ nền độc lập non trẻ trước nhà Tống',
                'Chấm dứt hơn 1000 năm Bắc thuộc',
                'Mở đầu triều đại nhà Lý',
                'Thống nhất 12 sứ quân',
              ],
              correctAnswerIndex: 0,
              explanation: 'Chiến thắng khẳng định sức mạnh và bảo vệ vững chắc nền độc lập còn non trẻ của Đại Cồ Việt trước một đế chế phương Bắc hùng mạnh.',
            ),
          ],
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
          questions: [
            QuizQuestionModel(
              id: 'q_1010_1',
              question: 'Lý Thái Tổ dời đô từ đâu về Thăng Long?',
              options: [
                'Cổ Loa',
                'Hoa Lư',
                'Phú Xuân',
                'Đông Đô',
              ],
              correctAnswerIndex: 1,
              explanation: 'Kinh đô được dời từ Hoa Lư (Ninh Bình) — vùng núi non hiểm trở — về vùng đất bằng phẳng, thuận lợi phát triển lâu dài.',
            ),
            QuizQuestionModel(
              id: 'q_1010_2',
              question: 'Vì sao vùng đất Đại La được đổi tên thành Thăng Long?',
              options: [
                'Vì vua thấy hình ảnh rồng vàng bay lên',
                'Vì có sông lớn bao quanh',
                'Vì đất đai bằng phẳng',
                'Vì gần biển Đông',
              ],
              correctAnswerIndex: 0,
              explanation: 'Tương truyền khi thuyền vua cập bến Đại La, có điềm rồng vàng bay lên nên vua đặt tên kinh đô mới là Thăng Long (rồng bay lên).',
            ),
            QuizQuestionModel(
              id: 'q_1010_3',
              question: 'Văn kiện nào ghi lại quyết định dời đô năm 1010?',
              options: [
                'Bình Ngô đại cáo',
                'Chiếu dời đô',
                'Hịch tướng sĩ',
                'Nam quốc sơn hà',
              ],
              correctAnswerIndex: 1,
              explanation: 'Chiếu dời đô (Thiên đô chiếu) do vua Lý Thái Tổ ban hành, nêu rõ lý do chọn Đại La — Thăng Long làm kinh đô muôn đời.',
            ),
          ],
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
          questions: [
            QuizQuestionModel(
              id: 'q_1077_1',
              question: 'Ai là người chỉ huy phòng tuyến sông Như Nguyệt năm 1077?',
              options: [
                'Trần Hưng Đạo',
                'Lý Thường Kiệt',
                'Lê Hoàn',
                'Ngô Quyền',
              ],
              correctAnswerIndex: 1,
              explanation: 'Lý Thường Kiệt trực tiếp xây dựng và chỉ huy phòng tuyến sông Như Nguyệt, chặn đứng quân Tống xâm lược.',
            ),
            QuizQuestionModel(
              id: 'q_1077_2',
              question: 'Bài thơ thần vang lên ban đêm để cổ vũ quân sĩ có tên gì?',
              options: [
                'Bình Ngô đại cáo',
                'Nam quốc sơn hà',
                'Hịch tướng sĩ',
                'Cáo bình Ngô',
              ],
              correctAnswerIndex: 1,
              explanation: '"Nam quốc sơn hà" được xem là bản Tuyên ngôn Độc lập đầu tiên của dân tộc, vang lên trong đêm khiến quân Tống hoang mang.',
            ),
            QuizQuestionModel(
              id: 'q_1077_3',
              question: 'Tướng nhà Tống chỉ huy 10 vạn quân xâm lược năm 1077 là ai?',
              options: [
                'Ô Mã Nhi',
                'Thoát Hoan',
                'Quách Quỳ',
                'Liễu Thăng',
              ],
              correctAnswerIndex: 2,
              explanation: 'Quách Quỳ được nhà Tống cử làm chủ tướng thống lĩnh đại quân sang xâm lược Đại Việt năm 1077 nhưng đã thất bại.',
            ),
          ],
        ),
      ],
    ),

    // -----------------------------------------------------------------
    // Thời kỳ Cận đại (1858 → 1945)
    // -----------------------------------------------------------------
    const EraModel(
      id: 'era_4',
      name: 'Thời kỳ Cận đại',
      centuryTitle: 'Thế kỷ 19 → Nửa đầu 20',
      timelineSpan: '1858 → 1945',
      description: 'Thời kỳ thực dân Pháp xâm lược và cuộc đấu tranh giải phóng dân tộc dẫn đến Cách mạng tháng Tám.',
      isUnlocked: true,
      events: [
        HistoricalEventModel(
          id: 'event_1858',
          eraId: 'era_4',
          year: 1858,
          title: 'Pháp nổ súng xâm lược Đà Nẵng',
          summary: 'Liên quân Pháp - Tây Ban Nha nổ phát súng đầu tiên, mở đầu thời kỳ Pháp thuộc.',
          storyContent:
              'Ngày 1/9/1858, liên quân Pháp - Tây Ban Nha nổ súng tấn công bán đảo Sơn Trà (Đà Nẵng), mở đầu quá trình xâm lược Việt Nam của thực dân Pháp. '
              'Quân dân ta dưới sự chỉ huy của Nguyễn Tri Phương đã anh dũng chống trả, khiến kế hoạch đánh nhanh thắng nhanh của Pháp thất bại ngay từ đầu.',
          estimatedMinutes: 5,
          xpReward: 100,
          coinReward: 30,
          isCompleted: true,
          questions: [
            QuizQuestionModel(
              id: 'q_1858_1',
              question: 'Thực dân Pháp nổ súng xâm lược Việt Nam đầu tiên tại đâu?',
              options: ['Đà Nẵng', 'Sài Gòn', 'Hà Nội', 'Huế'],
              correctAnswerIndex: 0,
              explanation: 'Ngày 1/9/1858, liên quân Pháp - Tây Ban Nha nổ súng tấn công bán đảo Sơn Trà, Đà Nẵng.',
            ),
            QuizQuestionModel(
              id: 'q_1858_2',
              question: 'Ai là vị tướng chỉ huy quân dân ta chống Pháp tại Đà Nẵng năm 1858?',
              options: ['Nguyễn Tri Phương', 'Hoàng Diệu', 'Phan Đình Phùng', 'Tôn Thất Thuyết'],
              correctAnswerIndex: 0,
              explanation: 'Nguyễn Tri Phương chỉ huy quân dân xây dựng phòng tuyến, chặn đứng bước tiến của liên quân Pháp - Tây Ban Nha.',
            ),
            QuizQuestionModel(
              id: 'q_1858_3',
              question: 'Kế hoạch ban đầu của Pháp khi tấn công Đà Nẵng là gì?',
              options: [
                'Đánh nhanh thắng nhanh',
                'Bao vây kinh tế lâu dài',
                'Đàm phán hòa bình',
                'Chỉ chiếm đảo Sơn Trà làm căn cứ',
              ],
              correctAnswerIndex: 0,
              explanation: 'Pháp dự định đánh nhanh thắng nhanh để buộc triều đình Huế đầu hàng, nhưng thất bại trước sự kháng cự quyết liệt của quân dân ta.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_1885',
          eraId: 'era_4',
          year: 1885,
          title: 'Phong trào Cần Vương',
          summary: 'Vua Hàm Nghi hạ chiếu Cần Vương, khơi dậy phong trào kháng Pháp trên cả nước.',
          storyContent:
              'Sau khi kinh thành Huế thất thủ, vua Hàm Nghi cùng Tôn Thất Thuyết ra chiếu Cần Vương năm 1885, kêu gọi văn thân sĩ phu và nhân dân đứng lên giúp vua cứu nước. '
              'Phong trào lan rộng khắp Bắc và Trung Kỳ với nhiều cuộc khởi nghĩa tiêu biểu như Ba Đình, Bãi Sậy, Hương Khê.',
          estimatedMinutes: 5,
          xpReward: 105,
          coinReward: 32,
          isCompleted: true,
          questions: [
            QuizQuestionModel(
              id: 'q_1885_1',
              question: 'Ai là vị vua hạ chiếu Cần Vương năm 1885?',
              options: ['Vua Hàm Nghi', 'Vua Duy Tân', 'Vua Thành Thái', 'Vua Bảo Đại'],
              correctAnswerIndex: 0,
              explanation: 'Vua Hàm Nghi cùng Tôn Thất Thuyết hạ chiếu Cần Vương, kêu gọi nhân dân cả nước đứng lên kháng Pháp.',
            ),
            QuizQuestionModel(
              id: 'q_1885_2',
              question: '"Cần Vương" có nghĩa là gì?',
              options: ['Giúp vua cứu nước', 'Xây dựng kinh đô mới', 'Cải cách triều chính', 'Mở cửa giao thương'],
              correctAnswerIndex: 0,
              explanation: '"Cần Vương" nghĩa là hết lòng giúp vua, kêu gọi nhân dân đứng lên chống thực dân Pháp bảo vệ đất nước.',
            ),
            QuizQuestionModel(
              id: 'q_1885_3',
              question: 'Cuộc khởi nghĩa nào sau đây KHÔNG thuộc phong trào Cần Vương?',
              options: ['Khởi nghĩa Hương Khê', 'Khởi nghĩa Ba Đình', 'Khởi nghĩa Bãi Sậy', 'Khởi nghĩa Yên Thế'],
              correctAnswerIndex: 3,
              explanation: 'Khởi nghĩa Yên Thế do Hoàng Hoa Thám lãnh đạo là phong trào nông dân tự phát, không nằm trong hệ thống chiếu Cần Vương.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_1930',
          eraId: 'era_4',
          year: 1930,
          title: 'Đảng Cộng sản Việt Nam thành lập',
          summary: 'Nguyễn Ái Quốc chủ trì hội nghị hợp nhất, mở ra bước ngoặt cho cách mạng Việt Nam.',
          storyContent:
              'Ngày 3/2/1930, tại Hương Cảng (Trung Quốc), Nguyễn Ái Quốc chủ trì hội nghị hợp nhất ba tổ chức cộng sản, thành lập Đảng Cộng sản Việt Nam. '
              'Sự kiện này đánh dấu bước ngoặt vĩ đại, chấm dứt thời kỳ khủng hoảng về đường lối cứu nước, mở ra giai đoạn đấu tranh có tổ chức, có lãnh đạo thống nhất.',
          estimatedMinutes: 6,
          xpReward: 140,
          coinReward: 45,
          rewardCardName: 'Thẻ Nguyễn Ái Quốc 4⭐',
          isCompleted: false,
          isCurrentActive: true,
          questions: [
            QuizQuestionModel(
              id: 'q_1930_1',
              question: 'Ai là người chủ trì hội nghị thành lập Đảng Cộng sản Việt Nam?',
              options: ['Nguyễn Ái Quốc', 'Trần Phú', 'Lê Hồng Phong', 'Phạm Văn Đồng'],
              correctAnswerIndex: 0,
              explanation: 'Nguyễn Ái Quốc (sau này là Chủ tịch Hồ Chí Minh) chủ trì hội nghị hợp nhất, thành lập Đảng Cộng sản Việt Nam.',
            ),
            QuizQuestionModel(
              id: 'q_1930_2',
              question: 'Đảng Cộng sản Việt Nam được thành lập vào ngày tháng năm nào?',
              options: ['3/2/1930', '2/9/1945', '19/8/1945', '30/4/1975'],
              correctAnswerIndex: 0,
              explanation: 'Ngày 3/2/1930 là ngày thành lập Đảng Cộng sản Việt Nam, được chọn làm ngày kỷ niệm thành lập Đảng.',
            ),
            QuizQuestionModel(
              id: 'q_1930_3',
              question: 'Đảng Cộng sản Việt Nam ra đời từ việc hợp nhất bao nhiêu tổ chức cộng sản?',
              options: ['Hai', 'Ba', 'Bốn', 'Năm'],
              correctAnswerIndex: 1,
              explanation: 'Ba tổ chức cộng sản trong nước đã hợp nhất thành một chính đảng thống nhất — Đảng Cộng sản Việt Nam.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_1940',
          eraId: 'era_4',
          year: 1940,
          title: 'Khởi nghĩa Nam Kỳ',
          summary: 'Lá cờ đỏ sao vàng lần đầu xuất hiện trong cuộc khởi nghĩa vũ trang ở Nam Bộ.',
          storyContent:
              'Tháng 11/1940, dưới sự lãnh đạo của Xứ ủy Nam Kỳ, nhân dân nhiều tỉnh Nam Bộ đồng loạt nổi dậy khởi nghĩa vũ trang chống thực dân Pháp và phát xít Nhật. '
              'Đây là một trong những nơi lá cờ đỏ sao vàng — sau này trở thành quốc kỳ Việt Nam — lần đầu xuất hiện, dù cuộc khởi nghĩa cuối cùng bị đàn áp.',
          estimatedMinutes: 5,
          xpReward: 115,
          coinReward: 35,
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_1940_1',
              question: 'Khởi nghĩa Nam Kỳ nổ ra vào năm nào?',
              options: ['1940', '1930', '1945', '1936'],
              correctAnswerIndex: 0,
              explanation: 'Khởi nghĩa Nam Kỳ nổ ra vào tháng 11 năm 1940 tại nhiều tỉnh Nam Bộ.',
            ),
            QuizQuestionModel(
              id: 'q_1940_2',
              question: 'Trong khởi nghĩa Nam Kỳ, hình ảnh nào lần đầu xuất hiện và sau này trở thành quốc kỳ?',
              options: ['Cờ đỏ sao vàng', 'Cờ vàng ba sọc đỏ', 'Cờ búa liềm', 'Cờ ngũ sắc'],
              correctAnswerIndex: 0,
              explanation: 'Lá cờ đỏ sao vàng lần đầu xuất hiện trong khởi nghĩa Nam Kỳ, sau này được chọn làm quốc kỳ nước Việt Nam.',
            ),
            QuizQuestionModel(
              id: 'q_1940_3',
              question: 'Khởi nghĩa Nam Kỳ diễn ra chủ yếu ở khu vực nào?',
              options: ['Nam Bộ', 'Bắc Bộ', 'Trung Bộ', 'Tây Nguyên'],
              correctAnswerIndex: 0,
              explanation: 'Cuộc khởi nghĩa nổ ra đồng loạt ở nhiều tỉnh thuộc Nam Bộ dưới sự lãnh đạo của Xứ ủy Nam Kỳ.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_1945_3',
          eraId: 'era_4',
          year: 1945,
          title: 'Nhật đảo chính Pháp',
          summary: 'Ngày 9/3/1945, Nhật lật đổ chính quyền Pháp, tạo thời cơ cho cách mạng bùng nổ.',
          storyContent:
              'Đêm 9/3/1945, phát xít Nhật bất ngờ đảo chính, lật đổ chính quyền thực dân Pháp trên toàn Đông Dương để độc chiếm thuộc địa. '
              'Sự kiện này làm suy yếu nghiêm trọng bộ máy cai trị cũ, tạo ra thời cơ thuận lợi mà Đảng ta nhanh chóng nắm bắt để chuẩn bị cho Tổng khởi nghĩa.',
          estimatedMinutes: 4,
          xpReward: 100,
          coinReward: 30,
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_1945_3_1',
              question: 'Nhật đảo chính Pháp trên toàn Đông Dương vào ngày nào?',
              options: ['9/3/1945', '2/9/1945', '19/8/1945', '6/1/1946'],
              correctAnswerIndex: 0,
              explanation: 'Đêm 9/3/1945, phát xít Nhật đảo chính, lật đổ chính quyền thực dân Pháp để độc chiếm Đông Dương.',
            ),
            QuizQuestionModel(
              id: 'q_1945_3_2',
              question: 'Mục đích của Nhật khi đảo chính Pháp là gì?',
              options: [
                'Độc chiếm Đông Dương làm thuộc địa riêng',
                'Trao trả độc lập cho Việt Nam',
                'Rút quân khỏi Đông Dương',
                'Liên minh với Việt Minh',
              ],
              correctAnswerIndex: 0,
              explanation: 'Nhật muốn loại bỏ hoàn toàn ảnh hưởng của Pháp để một mình khai thác và kiểm soát Đông Dương.',
            ),
            QuizQuestionModel(
              id: 'q_1945_3_3',
              question: 'Sự kiện Nhật đảo chính Pháp có ý nghĩa gì với cách mạng Việt Nam?',
              options: [
                'Tạo thời cơ thuận lợi để chuẩn bị Tổng khởi nghĩa',
                'Chấm dứt hoàn toàn ách đô hộ ngoại bang',
                'Mở đầu cuộc kháng chiến chống Pháp lần hai',
                'Dẫn đến chiến thắng Điện Biên Phủ',
              ],
              correctAnswerIndex: 0,
              explanation: 'Bộ máy cai trị cũ suy yếu tạo thời cơ để Đảng phát động cao trào kháng Nhật cứu nước, chuẩn bị cho Cách mạng tháng Tám.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_1945_8',
          eraId: 'era_4',
          year: 1945,
          title: 'Cách mạng tháng Tám thành công',
          summary: 'Nhân dân cả nước vùng lên giành chính quyền, khai sinh nước Việt Nam Dân chủ Cộng hòa.',
          storyContent:
              'Trong khí thế "Tổng khởi nghĩa" sục sôi tháng 8/1945, nhân dân cả nước từ Hà Nội, Huế đến Sài Gòn đồng loạt vùng lên giành chính quyền chỉ trong khoảng hai tuần. '
              'Ngày 19/8/1945, khởi nghĩa giành chính quyền thắng lợi ở Hà Nội, mở đường cho sự ra đời của nước Việt Nam Dân chủ Cộng hòa — nhà nước công nông đầu tiên ở Đông Nam Á.',
          estimatedMinutes: 6,
          xpReward: 160,
          coinReward: 55,
          rewardCardName: 'Thẻ Cách Mạng Tháng Tám 5⭐',
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_1945_8_1',
              question: 'Khởi nghĩa giành chính quyền thắng lợi ở Hà Nội vào ngày nào?',
              options: ['19/8/1945', '2/9/1945', '9/3/1945', '30/4/1945'],
              correctAnswerIndex: 0,
              explanation: 'Ngày 19/8/1945, cuộc khởi nghĩa giành chính quyền ở Hà Nội thắng lợi, trở thành ngày kỷ niệm Cách mạng tháng Tám.',
            ),
            QuizQuestionModel(
              id: 'q_1945_8_2',
              question: 'Cách mạng tháng Tám 1945 đã lật đổ những thế lực nào?',
              options: [
                'Phong kiến và phát xít Nhật',
                'Chỉ thực dân Pháp',
                'Chỉ triều đình nhà Nguyễn',
                'Đế quốc Mỹ',
              ],
              correctAnswerIndex: 0,
              explanation: 'Cách mạng tháng Tám lật đổ chế độ phong kiến tồn tại hàng nghìn năm và ách thống trị của phát xít Nhật.',
            ),
            QuizQuestionModel(
              id: 'q_1945_8_3',
              question: 'Thành công của Cách mạng tháng Tám dẫn đến sự ra đời của nhà nước nào?',
              options: [
                'Việt Nam Dân chủ Cộng hòa',
                'Đại Cồ Việt',
                'Cộng hòa Xã hội Chủ nghĩa Việt Nam',
                'Liên bang Đông Dương',
              ],
              correctAnswerIndex: 0,
              explanation: 'Nước Việt Nam Dân chủ Cộng hòa ra đời, được Chủ tịch Hồ Chí Minh tuyên bố thành lập ngày 2/9/1945.',
            ),
          ],
        ),
      ],
    ),

    // -----------------------------------------------------------------
    // Thời kỳ Hiện đại (1945 → 1975)
    // -----------------------------------------------------------------
    const EraModel(
      id: 'era_5',
      name: 'Thời kỳ Hiện đại',
      centuryTitle: 'Nửa sau Thế kỷ 20',
      timelineSpan: '1945 → 1975',
      description: 'Ba mươi năm kháng chiến trường kỳ bảo vệ nền độc lập và thống nhất đất nước.',
      isUnlocked: true,
      events: [
        HistoricalEventModel(
          id: 'event_tuyenngon',
          eraId: 'era_5',
          year: 1945,
          title: 'Tuyên ngôn Độc lập',
          summary: 'Chủ tịch Hồ Chí Minh đọc Tuyên ngôn Độc lập tại quảng trường Ba Đình lịch sử.',
          storyContent:
              'Ngày 2/9/1945, tại quảng trường Ba Đình (Hà Nội), Chủ tịch Hồ Chí Minh thay mặt Chính phủ lâm thời đọc bản Tuyên ngôn Độc lập, khai sinh nước Việt Nam Dân chủ Cộng hòa. '
              'Bản tuyên ngôn khẳng định quyền tự do, độc lập thiêng liêng của dân tộc Việt Nam trước toàn thế giới.',
          estimatedMinutes: 5,
          xpReward: 150,
          coinReward: 50,
          rewardCardName: 'Thẻ Hồ Chí Minh 5⭐',
          isCompleted: true,
          questions: [
            QuizQuestionModel(
              id: 'q_tuyenngon_1',
              question: 'Chủ tịch Hồ Chí Minh đọc Tuyên ngôn Độc lập ở đâu?',
              options: ['Quảng trường Ba Đình', 'Điện Kính Thiên', 'Dinh Độc Lập', 'Thành Cổ Loa'],
              correctAnswerIndex: 0,
              explanation: 'Ngày 2/9/1945, tại quảng trường Ba Đình, Hà Nội, Chủ tịch Hồ Chí Minh đọc bản Tuyên ngôn Độc lập lịch sử.',
            ),
            QuizQuestionModel(
              id: 'q_tuyenngon_2',
              question: 'Tuyên ngôn Độc lập khai sinh ra nhà nước nào?',
              options: [
                'Việt Nam Dân chủ Cộng hòa',
                'Cộng hòa Xã hội Chủ nghĩa Việt Nam',
                'Đại Nam',
                'Liên bang Đông Dương',
              ],
              correctAnswerIndex: 0,
              explanation: 'Nước Việt Nam Dân chủ Cộng hòa chính thức ra đời từ sự kiện này, mở ra kỷ nguyên độc lập, tự do.',
            ),
            QuizQuestionModel(
              id: 'q_tuyenngon_3',
              question: 'Tuyên ngôn Độc lập được đọc vào ngày, tháng, năm nào?',
              options: ['2/9/1945', '19/8/1945', '9/3/1945', '30/4/1945'],
              correctAnswerIndex: 0,
              explanation: 'Ngày 2/9/1945 trở thành ngày Quốc khánh nước Cộng hòa Xã hội Chủ nghĩa Việt Nam.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_toanquockc',
          eraId: 'era_5',
          year: 1946,
          title: 'Toàn quốc kháng chiến',
          summary: '"Chúng ta thà hy sinh tất cả..." — lời kêu gọi bất hủ mở đầu 9 năm kháng chiến chống Pháp.',
          storyContent:
              'Đêm 19/12/1946, trước dã tâm quay lại xâm lược của thực dân Pháp, Chủ tịch Hồ Chí Minh ra Lời kêu gọi toàn quốc kháng chiến, khẳng định quyết tâm "thà hy sinh tất cả, chứ nhất định không chịu mất nước, nhất định không chịu làm nô lệ". '
              'Cuộc kháng chiến trường kỳ chống thực dân Pháp chính thức bắt đầu trên phạm vi cả nước.',
          estimatedMinutes: 5,
          xpReward: 120,
          coinReward: 38,
          isCompleted: false,
          isCurrentActive: true,
          questions: [
            QuizQuestionModel(
              id: 'q_toanquockc_1',
              question: 'Lời kêu gọi Toàn quốc kháng chiến được Bác Hồ ra vào đêm nào?',
              options: ['19/12/1946', '2/9/1945', '7/5/1954', '30/4/1975'],
              correctAnswerIndex: 0,
              explanation: 'Đêm 19/12/1946, Chủ tịch Hồ Chí Minh ra Lời kêu gọi toàn quốc kháng chiến chống thực dân Pháp.',
            ),
            QuizQuestionModel(
              id: 'q_toanquockc_2',
              question: 'Câu nói nào gắn liền với Lời kêu gọi toàn quốc kháng chiến?',
              options: [
                '"Thà hy sinh tất cả, chứ nhất định không chịu mất nước"',
                '"Không có gì quý hơn độc lập, tự do"',
                '"Nam quốc sơn hà Nam đế cư"',
                '"Đánh cho để dài tóc..."',
              ],
              correctAnswerIndex: 0,
              explanation: 'Câu nói thể hiện quyết tâm sắt đá của toàn dân tộc trong cuộc kháng chiến chống thực dân Pháp.',
            ),
            QuizQuestionModel(
              id: 'q_toanquockc_3',
              question: 'Sự kiện này mở đầu cuộc kháng chiến chống thực dân nào?',
              options: ['Pháp', 'Mỹ', 'Nhật', 'Trung Quốc'],
              correctAnswerIndex: 0,
              explanation: 'Đây là mốc mở đầu cuộc kháng chiến trường kỳ 9 năm chống thực dân Pháp, kết thúc bằng chiến thắng Điện Biên Phủ năm 1954.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_dienbienphu',
          eraId: 'era_5',
          year: 1954,
          title: 'Chiến thắng Điện Biên Phủ',
          summary: '"Lừng lẫy năm châu, chấn động địa cầu" — trận quyết chiến chiến lược chấm dứt Pháp thuộc.',
          storyContent:
              'Sau 56 ngày đêm "khoét núi, ngủ hầm, mưa dầm, cơm vắt", quân và dân ta dưới sự chỉ huy của Đại tướng Võ Nguyên Giáp đã đập tan tập đoàn cứ điểm Điện Biên Phủ ngày 7/5/1954. '
              'Chiến thắng này buộc Pháp phải ký Hiệp định Genève, chấm dứt hoàn toàn ách đô hộ gần 100 năm của thực dân Pháp tại Đông Dương.',
          estimatedMinutes: 6,
          xpReward: 160,
          coinReward: 55,
          rewardCardName: 'Thẻ Võ Nguyên Giáp 5⭐',
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_dienbienphu_1',
              question: 'Ai là Tổng chỉ huy chiến dịch Điện Biên Phủ năm 1954?',
              options: ['Đại tướng Võ Nguyên Giáp', 'Chủ tịch Hồ Chí Minh', 'Đại tướng Văn Tiến Dũng', 'Trường Chinh'],
              correctAnswerIndex: 0,
              explanation: 'Đại tướng Võ Nguyên Giáp trực tiếp chỉ huy chiến dịch Điện Biên Phủ, làm nên chiến thắng lịch sử.',
            ),
            QuizQuestionModel(
              id: 'q_dienbienphu_2',
              question: 'Chiến thắng Điện Biên Phủ diễn ra vào ngày nào?',
              options: ['7/5/1954', '2/9/1945', '19/12/1946', '30/4/1975'],
              correctAnswerIndex: 0,
              explanation: 'Ngày 7/5/1954, quân ta toàn thắng, bắt sống tướng De Castries cùng toàn bộ tập đoàn cứ điểm Điện Biên Phủ.',
            ),
            QuizQuestionModel(
              id: 'q_dienbienphu_3',
              question: 'Chiến thắng Điện Biên Phủ dẫn đến việc ký kết hiệp định nào?',
              options: ['Hiệp định Genève', 'Hiệp định Paris', 'Hiệp định Sơ bộ', 'Hòa ước Giáp Thân'],
              correctAnswerIndex: 0,
              explanation: 'Hiệp định Genève năm 1954 được ký kết, chấm dứt chiến tranh và công nhận độc lập, chủ quyền của Việt Nam.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_maudan',
          eraId: 'era_5',
          year: 1968,
          title: 'Tổng tiến công Tết Mậu Thân',
          summary: 'Cuộc tổng tiến công đồng loạt gây chấn động, làm lung lay ý chí xâm lược của Mỹ.',
          storyContent:
              'Đêm giao thừa Tết Mậu Thân 1968, quân giải phóng bất ngờ đồng loạt tiến công vào hầu hết các đô thị lớn ở miền Nam, kể cả Sài Gòn và Tòa đại sứ Mỹ. '
              'Dù về mặt quân sự có tổn thất, cuộc tổng tiến công đã gây chấn động dư luận Mỹ, làm lung lay ý chí xâm lược và buộc Mỹ phải xuống thang chiến tranh, ngồi vào bàn đàm phán Paris.',
          estimatedMinutes: 6,
          xpReward: 145,
          coinReward: 48,
          isCompleted: false,
          isMajorMilestone: true,
          questions: [
            QuizQuestionModel(
              id: 'q_maudan_1',
              question: 'Cuộc Tổng tiến công Tết Mậu Thân diễn ra vào năm nào?',
              options: ['1968', '1954', '1972', '1975'],
              correctAnswerIndex: 0,
              explanation: 'Cuộc Tổng tiến công và nổi dậy Tết Mậu Thân diễn ra vào dịp Tết Nguyên đán năm 1968.',
            ),
            QuizQuestionModel(
              id: 'q_maudan_2',
              question: 'Mục tiêu nổi bật nào ở Sài Gòn bị tấn công trong sự kiện Mậu Thân?',
              options: ['Tòa đại sứ Mỹ', 'Dinh Norodom', 'Chợ Bến Thành', 'Nhà thờ Đức Bà'],
              correctAnswerIndex: 0,
              explanation: 'Cuộc tấn công vào Tòa đại sứ Mỹ tại Sài Gòn là một trong những sự kiện gây chấn động dư luận quốc tế nhất.',
            ),
            QuizQuestionModel(
              id: 'q_maudan_3',
              question: 'Tác động lớn nhất của cuộc Tổng tiến công Tết Mậu Thân là gì?',
              options: [
                'Làm lung lay ý chí xâm lược của Mỹ, buộc ngồi vào bàn đàm phán',
                'Giải phóng hoàn toàn miền Nam',
                'Chấm dứt chiến tranh ngay lập tức',
                'Mỹ tăng cường viện trợ quân sự',
              ],
              correctAnswerIndex: 0,
              explanation: 'Sự kiện này tác động mạnh đến chính trường và dư luận Mỹ, mở đường cho việc Mỹ phải đàm phán tại Hội nghị Paris.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_dbptrenkhong',
          eraId: 'era_5',
          year: 1972,
          title: 'Điện Biên Phủ trên không',
          summary: '12 ngày đêm Hà Nội rực lửa, bắn rơi hàng chục pháo đài bay B-52 của Mỹ.',
          storyContent:
              'Cuối tháng 12/1972, đế quốc Mỹ mở chiến dịch Linebacker II, huy động máy bay B-52 ném bom rải thảm Hà Nội, Hải Phòng hòng buộc ta khuất phục trên bàn đàm phán. '
              'Quân dân Thủ đô đã lập nên chiến thắng "Điện Biên Phủ trên không", bắn rơi nhiều pháo đài bay B-52, buộc Mỹ phải ký Hiệp định Paris.',
          estimatedMinutes: 6,
          xpReward: 150,
          coinReward: 50,
          rewardCardName: 'Thẻ Hà Nội - Điện Biên Phủ Trên Không 5⭐',
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_dbptrenkhong_1',
              question: 'Chiến thắng "Điện Biên Phủ trên không" diễn ra ở thành phố nào?',
              options: ['Hà Nội', 'Sài Gòn', 'Huế', 'Hải Phòng'],
              correctAnswerIndex: 0,
              explanation: 'Hà Nội là chiến trường chính của trận "Điện Biên Phủ trên không" cuối tháng 12/1972.',
            ),
            QuizQuestionModel(
              id: 'q_dbptrenkhong_2',
              question: 'Loại máy bay nào của Mỹ bị bắn rơi nhiều trong chiến dịch này?',
              options: ['B-52', 'F-16', 'A-10', 'Máy bay trực thăng Chinook'],
              correctAnswerIndex: 0,
              explanation: 'Máy bay ném bom chiến lược B-52 — được mệnh danh "pháo đài bay bất khả xâm phạm" — đã bị quân dân ta bắn rơi hàng loạt.',
            ),
            QuizQuestionModel(
              id: 'q_dbptrenkhong_3',
              question: 'Chiến thắng này buộc Mỹ phải làm gì?',
              options: [
                'Ký Hiệp định Paris',
                'Rút toàn bộ quân khỏi miền Nam ngay lập tức',
                'Tăng viện trợ cho chính quyền Sài Gòn',
                'Mở rộng chiến tranh ra miền Bắc',
              ],
              correctAnswerIndex: 0,
              explanation: 'Thất bại nặng nề buộc Mỹ phải quay lại bàn đàm phán và ký Hiệp định Paris năm 1973 về chấm dứt chiến tranh.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_1975',
          eraId: 'era_5',
          year: 1975,
          title: 'Chiến dịch Hồ Chí Minh',
          summary: 'Đại thắng mùa Xuân 1975, giải phóng hoàn toàn miền Nam, thống nhất đất nước.',
          storyContent:
              'Với khí thế "một ngày bằng hai mươi năm", Chiến dịch Hồ Chí Minh lịch sử diễn ra thần tốc, đỉnh cao là thời khắc xe tăng quân giải phóng húc đổ cổng Dinh Độc Lập trưa ngày 30/4/1975. '
              'Chiến thắng này kết thúc 30 năm chiến tranh giải phóng dân tộc, giang sơn thu về một mối, mở ra kỷ nguyên độc lập, thống nhất, xây dựng đất nước.',
          estimatedMinutes: 6,
          xpReward: 180,
          coinReward: 60,
          rewardCardName: 'Thẻ Đại Thắng Mùa Xuân 5⭐',
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_1975_1',
              question: 'Chiến dịch Hồ Chí Minh kết thúc thắng lợi vào ngày nào?',
              options: ['30/4/1975', '7/5/1954', '2/9/1945', '19/12/1946'],
              correctAnswerIndex: 0,
              explanation: 'Trưa ngày 30/4/1975, xe tăng quân giải phóng húc đổ cổng Dinh Độc Lập, đánh dấu ngày miền Nam hoàn toàn giải phóng.',
            ),
            QuizQuestionModel(
              id: 'q_1975_2',
              question: 'Sự kiện nào biểu tượng cho thời khắc kết thúc chiến dịch Hồ Chí Minh?',
              options: [
                'Xe tăng húc đổ cổng Dinh Độc Lập',
                'Ký Hiệp định Genève',
                'Ký Hiệp định Paris',
                'Chiến thắng Điện Biên Phủ',
              ],
              correctAnswerIndex: 0,
              explanation: 'Hình ảnh xe tăng quân giải phóng húc đổ cổng Dinh Độc Lập trở thành biểu tượng bất hủ của ngày toàn thắng.',
            ),
            QuizQuestionModel(
              id: 'q_1975_3',
              question: 'Chiến thắng năm 1975 có ý nghĩa lịch sử gì?',
              options: [
                'Giải phóng hoàn toàn miền Nam, thống nhất đất nước',
                'Chấm dứt hơn 1000 năm Bắc thuộc',
                'Mở đầu công cuộc Đổi mới',
                'Việt Nam gia nhập Liên Hợp Quốc',
              ],
              correctAnswerIndex: 0,
              explanation: 'Đây là mốc son chói lọi kết thúc 30 năm chiến tranh giải phóng dân tộc, non sông thu về một mối.',
            ),
          ],
        ),
      ],
    ),

    // -----------------------------------------------------------------
    // Thời kỳ Đương đại (1975 → nay)
    // -----------------------------------------------------------------
    const EraModel(
      id: 'era_6',
      name: 'Thời kỳ Đương đại',
      centuryTitle: 'Từ 1975 đến nay',
      timelineSpan: '1975 → Hiện tại',
      description: 'Khắc phục hậu quả chiến tranh, đổi mới và hội nhập quốc tế.',
      isUnlocked: true,
      events: [
        HistoricalEventModel(
          id: 'event_thongnhat',
          eraId: 'era_6',
          year: 1976,
          title: 'Thống nhất đất nước',
          summary: 'Quốc hội thống nhất đặt tên nước Cộng hòa Xã hội Chủ nghĩa Việt Nam.',
          storyContent:
              'Tháng 7/1976, Quốc hội khóa VI họp kỳ đầu tiên, chính thức thống nhất hai miền Nam - Bắc về mặt nhà nước, đặt tên nước là Cộng hòa Xã hội Chủ nghĩa Việt Nam, chọn Hà Nội làm thủ đô. '
              'Đây là mốc hoàn tất quá trình thống nhất đất nước sau đại thắng mùa Xuân 1975.',
          estimatedMinutes: 4,
          xpReward: 110,
          coinReward: 35,
          isCompleted: true,
          questions: [
            QuizQuestionModel(
              id: 'q_thongnhat_1',
              question: 'Quốc hội thống nhất đặt tên nước ta là gì từ năm 1976?',
              options: [
                'Cộng hòa Xã hội Chủ nghĩa Việt Nam',
                'Việt Nam Dân chủ Cộng hòa',
                'Đại Cồ Việt',
                'Cộng hòa Miền Nam Việt Nam',
              ],
              correctAnswerIndex: 0,
              explanation: 'Từ tháng 7/1976, quốc hiệu chính thức là Cộng hòa Xã hội Chủ nghĩa Việt Nam, được giữ nguyên đến ngày nay.',
            ),
            QuizQuestionModel(
              id: 'q_thongnhat_2',
              question: 'Thủ đô của nước Việt Nam thống nhất được chọn là thành phố nào?',
              options: ['Hà Nội', 'Huế', 'Thành phố Hồ Chí Minh', 'Đà Nẵng'],
              correctAnswerIndex: 0,
              explanation: 'Hà Nội được chọn làm thủ đô của nước Việt Nam thống nhất.',
            ),
            QuizQuestionModel(
              id: 'q_thongnhat_3',
              question: 'Sự kiện thống nhất đất nước về mặt nhà nước diễn ra vào năm nào?',
              options: ['1976', '1975', '1986', '1954'],
              correctAnswerIndex: 0,
              explanation: 'Năm 1976, Quốc hội khóa VI hoàn tất việc thống nhất đất nước về mặt nhà nước sau chiến thắng năm 1975.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_1979',
          eraId: 'era_6',
          year: 1979,
          title: 'Chiến tranh bảo vệ biên giới phía Bắc',
          summary: 'Quân dân các tỉnh biên giới phía Bắc anh dũng chiến đấu bảo vệ chủ quyền Tổ quốc.',
          storyContent:
              'Đầu năm 1979, chiến sự nổ ra dọc biên giới phía Bắc, quân và dân các tỉnh biên giới đã anh dũng chiến đấu bảo vệ từng tấc đất thiêng liêng của Tổ quốc. '
              'Đây là một chương lịch sử gian khổ, khẳng định ý chí kiên cường bảo vệ độc lập, chủ quyền và toàn vẹn lãnh thổ của dân tộc Việt Nam.',
          estimatedMinutes: 5,
          xpReward: 115,
          coinReward: 38,
          isCompleted: false,
          isCurrentActive: true,
          questions: [
            QuizQuestionModel(
              id: 'q_1979_1',
              question: 'Chiến tranh bảo vệ biên giới phía Bắc diễn ra vào năm nào?',
              options: ['1979', '1975', '1986', '1954'],
              correctAnswerIndex: 0,
              explanation: 'Chiến sự nổ ra dọc biên giới phía Bắc vào đầu năm 1979.',
            ),
            QuizQuestionModel(
              id: 'q_1979_2',
              question: 'Cuộc chiến này mang mục đích gì đối với Việt Nam?',
              options: [
                'Bảo vệ chủ quyền và toàn vẹn lãnh thổ',
                'Mở rộng lãnh thổ ra nước ngoài',
                'Thiết lập quan hệ ngoại giao mới',
                'Chuẩn bị cho công cuộc Đổi mới',
              ],
              correctAnswerIndex: 0,
              explanation: 'Đây là cuộc chiến đấu bảo vệ chủ quyền, toàn vẹn lãnh thổ ở các tỉnh biên giới phía Bắc.',
            ),
            QuizQuestionModel(
              id: 'q_1979_3',
              question: 'Sự kiện này thể hiện điều gì về tinh thần dân tộc Việt Nam?',
              options: [
                'Ý chí kiên cường bảo vệ độc lập, chủ quyền',
                'Mong muốn mở rộng chiến tranh',
                'Sự phụ thuộc vào viện trợ nước ngoài',
                'Từ bỏ con đường thống nhất',
              ],
              correctAnswerIndex: 0,
              explanation: 'Cuộc chiến đấu bảo vệ biên giới khẳng định ý chí không khuất phục trước mọi thế lực xâm phạm chủ quyền quốc gia.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_doimoi',
          eraId: 'era_6',
          year: 1986,
          title: 'Đại hội Đảng VI - Khởi xướng Đổi mới',
          summary: 'Bước ngoặt lịch sử chuyển đổi từ kinh tế kế hoạch hóa sang kinh tế thị trường.',
          storyContent:
              'Tháng 12/1986, Đại hội đại biểu toàn quốc lần thứ VI của Đảng đề ra đường lối Đổi mới toàn diện đất nước, trọng tâm là đổi mới tư duy kinh tế, chuyển từ nền kinh tế kế hoạch hóa tập trung sang kinh tế thị trường định hướng xã hội chủ nghĩa. '
              'Đây được xem là bước ngoặt lịch sử, mở đường cho ba thập kỷ phát triển vượt bậc của Việt Nam.',
          estimatedMinutes: 6,
          xpReward: 145,
          coinReward: 48,
          isCompleted: false,
          isMajorMilestone: true,
          questions: [
            QuizQuestionModel(
              id: 'q_doimoi_1',
              question: 'Đường lối Đổi mới được đề ra tại đại hội Đảng lần thứ mấy?',
              options: ['Đại hội VI', 'Đại hội IV', 'Đại hội VIII', 'Đại hội X'],
              correctAnswerIndex: 0,
              explanation: 'Đại hội Đảng lần thứ VI (tháng 12/1986) đã đề ra đường lối Đổi mới toàn diện đất nước.',
            ),
            QuizQuestionModel(
              id: 'q_doimoi_2',
              question: 'Trọng tâm của công cuộc Đổi mới năm 1986 là gì?',
              options: [
                'Đổi mới tư duy kinh tế, chuyển sang kinh tế thị trường',
                'Cải cách hệ thống giáo dục',
                'Mở rộng lãnh thổ quốc gia',
                'Thay đổi quốc kỳ, quốc ca',
              ],
              correctAnswerIndex: 0,
              explanation: 'Đổi mới tập trung chuyển từ kinh tế kế hoạch hóa tập trung sang kinh tế thị trường định hướng xã hội chủ nghĩa.',
            ),
            QuizQuestionModel(
              id: 'q_doimoi_3',
              question: 'Công cuộc Đổi mới năm 1986 được đánh giá như thế nào trong lịch sử Việt Nam?',
              options: [
                'Bước ngoặt lịch sử, mở đường phát triển vượt bậc',
                'Một cải cách nhỏ, ít tác động',
                'Chỉ áp dụng trong lĩnh vực quân sự',
                'Bị thất bại hoàn toàn',
              ],
              correctAnswerIndex: 0,
              explanation: 'Đổi mới được xem là bước ngoặt lịch sử, đưa Việt Nam từ một nước nghèo, khủng hoảng kinh tế trở thành nền kinh tế năng động, hội nhập quốc tế.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_1995',
          eraId: 'era_6',
          year: 1995,
          title: 'Gia nhập ASEAN',
          summary: 'Việt Nam chính thức trở thành thành viên thứ 7 của Hiệp hội các quốc gia Đông Nam Á.',
          storyContent:
              'Ngày 28/7/1995, Việt Nam chính thức gia nhập ASEAN (Hiệp hội các quốc gia Đông Nam Á), đánh dấu bước hội nhập khu vực quan trọng đầu tiên sau thời kỳ Đổi mới. '
              'Cùng năm, Việt Nam và Hoa Kỳ cũng chính thức bình thường hóa quan hệ ngoại giao, mở ra giai đoạn hội nhập quốc tế sâu rộng.',
          estimatedMinutes: 5,
          xpReward: 120,
          coinReward: 40,
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_1995_1',
              question: 'Việt Nam chính thức gia nhập ASEAN vào năm nào?',
              options: ['1995', '1986', '2007', '1975'],
              correctAnswerIndex: 0,
              explanation: 'Ngày 28/7/1995, Việt Nam chính thức trở thành thành viên của ASEAN.',
            ),
            QuizQuestionModel(
              id: 'q_1995_2',
              question: 'Việt Nam là thành viên thứ mấy của ASEAN?',
              options: ['Thứ 7', 'Thứ 5', 'Thứ 10', 'Thứ 3'],
              correctAnswerIndex: 0,
              explanation: 'Việt Nam gia nhập và trở thành thành viên thứ 7 của Hiệp hội các quốc gia Đông Nam Á.',
            ),
            QuizQuestionModel(
              id: 'q_1995_3',
              question: 'Sự kiện ngoại giao quan trọng nào khác cũng diễn ra trong năm 1995?',
              options: [
                'Bình thường hóa quan hệ ngoại giao Việt Nam - Hoa Kỳ',
                'Việt Nam gia nhập Liên Hợp Quốc',
                'Việt Nam gia nhập WTO',
                'Ký Hiệp định Paris',
              ],
              correctAnswerIndex: 0,
              explanation: 'Năm 1995, Việt Nam và Hoa Kỳ chính thức bình thường hóa quan hệ ngoại giao sau nhiều năm gián đoạn.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_wto',
          eraId: 'era_6',
          year: 2007,
          title: 'Gia nhập WTO',
          summary: 'Việt Nam trở thành thành viên thứ 150 của Tổ chức Thương mại Thế giới.',
          storyContent:
              'Ngày 11/1/2007, Việt Nam chính thức trở thành thành viên thứ 150 của Tổ chức Thương mại Thế giới (WTO), đánh dấu bước hội nhập kinh tế toàn cầu sâu rộng nhất từ trước đến thời điểm đó. '
              'Sự kiện này mở ra nhiều cơ hội thương mại, đầu tư quốc tế cho nền kinh tế Việt Nam.',
          estimatedMinutes: 5,
          xpReward: 125,
          coinReward: 42,
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_wto_1',
              question: 'Việt Nam chính thức gia nhập WTO vào năm nào?',
              options: ['2007', '1995', '1986', '2015'],
              correctAnswerIndex: 0,
              explanation: 'Ngày 11/1/2007, Việt Nam chính thức trở thành thành viên của Tổ chức Thương mại Thế giới.',
            ),
            QuizQuestionModel(
              id: 'q_wto_2',
              question: 'Việt Nam là thành viên thứ bao nhiêu của WTO?',
              options: ['150', '100', '200', '50'],
              correctAnswerIndex: 0,
              explanation: 'Việt Nam gia nhập và trở thành thành viên thứ 150 của Tổ chức Thương mại Thế giới (WTO).',
            ),
            QuizQuestionModel(
              id: 'q_wto_3',
              question: 'Việc gia nhập WTO mang lại lợi ích chủ yếu nào cho Việt Nam?',
              options: [
                'Mở rộng cơ hội thương mại, đầu tư quốc tế',
                'Mở rộng lãnh thổ',
                'Thay đổi quốc hiệu',
                'Chấm dứt quan hệ với ASEAN',
              ],
              correctAnswerIndex: 0,
              explanation: 'Gia nhập WTO giúp Việt Nam mở rộng thị trường xuất khẩu và thu hút đầu tư nước ngoài mạnh mẽ hơn.',
            ),
          ],
        ),
        HistoricalEventModel(
          id: 'event_1000nam',
          eraId: 'era_6',
          year: 2010,
          title: 'Đại lễ 1000 năm Thăng Long - Hà Nội',
          summary: 'Tròn một thiên niên kỷ kể từ Chiếu dời đô của Lý Thái Tổ, khép lại một hành trình dựng nước.',
          storyContent:
              'Tháng 10/2010, cả nước long trọng tổ chức Đại lễ kỷ niệm 1000 năm Thăng Long - Hà Nội, tròn một thiên niên kỷ kể từ khi vua Lý Thái Tổ ban Chiếu dời đô, chọn Thăng Long làm kinh đô muôn đời. '
              'Sự kiện khép lại một hành trình dài dựng nước và giữ nước đầy tự hào, đồng thời mở ra chặng đường phát triển mới của thủ đô nghìn năm văn hiến.',
          estimatedMinutes: 6,
          xpReward: 170,
          coinReward: 58,
          rewardCardName: 'Thẻ Thăng Long Nghìn Năm 5⭐',
          isCompleted: false,
          questions: [
            QuizQuestionModel(
              id: 'q_1000nam_1',
              question: 'Đại lễ 1000 năm Thăng Long - Hà Nội được tổ chức vào năm nào?',
              options: ['2010', '2000', '1990', '2020'],
              correctAnswerIndex: 0,
              explanation: 'Tháng 10/2010, Đại lễ kỷ niệm 1000 năm Thăng Long - Hà Nội được tổ chức long trọng trên cả nước.',
            ),
            QuizQuestionModel(
              id: 'q_1000nam_2',
              question: 'Đại lễ này kỷ niệm tròn 1000 năm kể từ sự kiện lịch sử nào?',
              options: [
                'Lý Thái Tổ ban Chiếu dời đô về Thăng Long',
                'Chiến thắng Bạch Đằng',
                'Cách mạng tháng Tám',
                'Chiến thắng Điện Biên Phủ',
              ],
              correctAnswerIndex: 0,
              explanation: 'Năm 1010, Lý Thái Tổ ban Chiếu dời đô, chọn Thăng Long làm kinh đô — tròn 1000 năm vào năm 2010.',
            ),
            QuizQuestionModel(
              id: 'q_1000nam_3',
              question: 'Đại lễ 1000 năm Thăng Long - Hà Nội mang ý nghĩa gì?',
              options: [
                'Khép lại một hành trình dựng nước tự hào, mở chặng đường phát triển mới',
                'Kỷ niệm chiến thắng quân Nguyên Mông',
                'Đánh dấu Việt Nam gia nhập WTO',
                'Kỷ niệm ngày thống nhất đất nước',
              ],
              correctAnswerIndex: 0,
              explanation: 'Sự kiện tôn vinh chiều dài lịch sử nghìn năm văn hiến của Thăng Long - Hà Nội, đồng thời hướng tới tương lai phát triển của thủ đô.',
            ),
          ],
        ),
      ],
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
