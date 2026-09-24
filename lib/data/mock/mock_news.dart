import '../models/news_article_model.dart';

/// Sự kiện tuần nổi bật
const WeeklyEventModel kMockWeeklyEvent = WeeklyEventModel(
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
const List<String> kMockNewsCategories = [
  'Tất cả',
  'Sự kiện tuần',
  'Khảo cổ & Di sản',
  'Nhân vật lịch sử',
  'Bí ẩn kỳ thú',
];

/// Danh sách bài viết lịch sử
const List<NewsArticleModel> kMockNewsArticles = [
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
