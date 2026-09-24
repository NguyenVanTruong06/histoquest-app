import 'models/user_model.dart';
import 'models/era_model.dart';
import 'models/hero_card_model.dart';
import 'models/country_model.dart';
import 'models/news_article_model.dart';
import 'mock/mock_countries.dart';
import 'mock/mock_eras.dart';
import 'mock/mock_heroes.dart';
import 'mock/mock_users.dart';
import 'mock/mock_news.dart';

// Re-export để các module khác có thể import linh hoạt
export 'mock/mock_countries.dart';
export 'mock/mock_eras.dart';
export 'mock/mock_heroes.dart';
export 'mock/mock_users.dart';
export 'mock/mock_news.dart';

/// Lớp điều phối dữ liệu giả lập tập trung (Facade Pattern).
///
/// Dữ liệu đã được module hóa sang thư mục `lib/data/mock/` theo từng domain:
/// - [mock_countries.dart]: Quốc gia & logic điều kiện mở khóa.
/// - [mock_eras.dart]: 6 thời kỳ lịch sử Việt Nam, mốc sự kiện & câu đố.
/// - [mock_heroes.dart]: Danh sách thẻ danh tướng.
/// - [mock_users.dart]: Hồ sơ người chơi hiện tại & bảng xếp hạng.
/// - [mock_news.dart]: Sự kiện tuần & bài viết tin tức lịch sử.
class MockData {
  MockData._();

  /// Quốc gia / nền văn minh mà người chơi đang chọn để khám phá.
  static String selectedCountryId = 'vn';

  /// Danh sách các quốc gia / nền văn minh
  static final List<CountryModel> countries = kMockCountries;

  /// Danh sách thẻ danh tướng thu thập được
  static final List<HeroCardModel> heroCards = kMockHeroCards;

  /// Danh sách các thời kỳ lịch sử & sự kiện chi tiết
  static final List<EraModel> eras = kMockEras;

  /// Thông tin người dùng hiện tại
  static UserModel currentUser = kInitialCurrentUser;

  /// Danh sách bảng vàng (Leaderboard Mock)
  static final List<Map<String, dynamic>> leaderboard = kMockLeaderboard;

  /// Danh sách thời kỳ theo quốc gia đang được chọn
  static List<EraModel> get erasForSelectedCountry =>
      eras.where((e) => e.countryId == selectedCountryId).toList();

  /// Tổng số mốc lịch sử (sự kiện) đã hoàn thành ở một nền văn minh
  static int completedMilestonesForCountry(String countryId) {
    return calculateCompletedMilestones(eras, countryId);
  }

  /// Nền văn minh [country] đã được mở khóa hay chưa
  static bool isCountryUnlocked(CountryModel country) {
    return checkCountryUnlocked(eras, country);
  }
}

/// Dữ liệu giả lập cho Tab Tin tức & Sự kiện tuần
class MockNewsData {
  MockNewsData._();

  static const WeeklyEventModel weeklyEvent = kMockWeeklyEvent;
  static const List<String> categories = kMockNewsCategories;
  static const List<NewsArticleModel> articles = kMockNewsArticles;
}
