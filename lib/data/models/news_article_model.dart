/// Mô hình dữ liệu Bài viết Tin tức / Kiến thức Lịch sử
class NewsArticleModel {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String category;
  final int readTimeMinutes;
  final String publishedDate;
  final String authorName;
  final String? historicalQuote;
  final String? quoteAuthor;
  final List<String> tags;
  final int initialLikes;
  final int commentsCount;
  final bool isFeatured;

  const NewsArticleModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.readTimeMinutes,
    required this.publishedDate,
    required this.authorName,
    this.historicalQuote,
    this.quoteAuthor,
    this.tags = const [],
    this.initialLikes = 0,
    this.commentsCount = 0,
    this.isFeatured = false,
  });
}

/// Mô hình Sự kiện Tuần nổi bật
class WeeklyEventModel {
  final String id;
  final String title;
  final String subtitle;
  final String badgeText;
  final String expiresText;
  final int rewardXp;
  final int rewardCoins;
  final String actionText;
  final String questGoal;
  final double progressPercent;

  const WeeklyEventModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.expiresText,
    required this.rewardXp,
    required this.rewardCoins,
    required this.actionText,
    required this.questGoal,
    this.progressPercent = 0.65,
  });
}
