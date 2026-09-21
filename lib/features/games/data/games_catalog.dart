import 'package:flutter/material.dart';
import '../domain/models/game_item_model.dart';
import '../presentation/mancala_game_screen.dart';
import '../presentation/timeline_rush_screen.dart';
import '../presentation/pvp_duel_mock_screen.dart';
import '../presentation/card_match_mock_screen.dart';
import '../presentation/archery_mock_screen.dart';
import '../presentation/hidden_relic_game_screen.dart';
import '../presentation/word_scramble_game_screen.dart';
import '../presentation/trang_nguyen_game_screen.dart';
import '../presentation/den_keo_quan_game_screen.dart';
import '../presentation/co_lau_game_screen.dart';
import '../presentation/bach_dang_game_screen.dart';
import '../presentation/thanh_tri_game_screen.dart';
import '../presentation/co_tuong_game_screen.dart';
import '../presentation/tay_son_game_screen.dart';
import '../presentation/rong_ran_game_screen.dart';
import '../presentation/nem_con_game_screen.dart';
class GamesCatalog {
  GamesCatalog._();

  static final List<GameItemModel> allGames = [
    // 1. Timeline Rush (Đã có màn chơi)
    GameItemModel(
      id: 'timeline_rush',
      title: 'Timeline Rush',
      shortName: 'Timeline',
      category: 'Trí tuệ',
      icon: Icons.hourglass_top_rounded,
      gradientColors: const [Color(0xFFE65100), Color(0xFFFF9800)],
      badge: 'HOT',
      isPlayable: true,
      howToPlay: 'Kéo thả và sắp xếp các sự kiện lịch sử theo đúng dòng thời gian từ xưa đến nay trước khi hết giờ. Mỗi lượt đúng nhận điểm thưởng combo!',
      gameMode: 'Vượt ải tính giờ • 5 mốc thử thách',
      duration: '2 - 3 phút',
      difficulty: 'Trung bình',
      coinReward: 15,
      xpReward: 200,
      itemReward: 'Mảnh Bản Đồ Cổ',
      screenBuilder: (context) => const TimelineRushScreen(),
    ),

    // 2. Cờ Ô Ăn Quan (Đã có màn chơi)
    GameItemModel(
      id: 'mancala',
      title: 'Cờ Ô Ăn Quan',
      shortName: 'Ô Ăn Quan',
      category: 'Dân gian',
      icon: Icons.grid_view_rounded,
      gradientColors: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
      badge: 'DÂN GIAN',
      isPlayable: true,
      isLandscape: true, // Xoay ngang cho bàn cờ Ô Ăn Quan
      howToPlay: 'Trò chơi rải sỏi tính toán kinh điển của người Việt. Chọn một ô dân, rải sỏi thuận hoặc nghịch chiều kim đồng hồ. Khi ô kế tiếp trống, bạn ăn toàn bộ sỏi ở ô sau đó!',
      gameMode: 'Đấu trí 2 người / Luyện tập cùng AI',
      duration: '3 - 5 phút',
      difficulty: 'Chiến thuật',
      coinReward: 20,
      xpReward: 150,
      itemReward: 'Bàn Cờ 12 Ô',
      screenBuilder: (context) => const MancalaGameScreen(),
    ),

    // 3. Ghép Thẻ Tướng
    GameItemModel(
      id: 'card_match',
      title: 'Ghép Thẻ Tướng',
      shortName: 'Thẻ Tướng',
      category: 'Trí nhớ',
      icon: Icons.style_rounded,
      gradientColors: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
      badge: 'MỚI',
      isPlayable: true,
      howToPlay: 'Lật tìm các cặp thẻ danh tướng giống nhau (Hai Bà Trưng, Ngô Quyền, Trần Hưng Đạo, Quang Trung) ẩn giấu trong bàn cờ 16 ô với số lượt lật giới hạn.',
      gameMode: 'Luyện trí nhớ • Giới hạn 20 lượt',
      duration: '1 - 2 phút',
      difficulty: 'Dễ',
      coinReward: 5,
      xpReward: 120,
      itemReward: 'Thẻ Vàng Danh Tướng',
      screenBuilder: (context) => const CardMatchMockScreen(),
    ),

    // 4. Truy Tìm Cổ Vật
    GameItemModel(
      id: 'hidden_relic',
      title: 'Truy Tìm Cổ Vật',
      shortName: 'Cổ Vật',
      category: 'Khám phá',
      icon: Icons.search_rounded,
      gradientColors: const [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
      badge: 'SẮP CÓ',
      isPlayable: true,
      isLandscape: true,
      howToPlay: 'Giải các manh mối câu thơ và mật mã lịch sử để tìm ra vị trí chôn giấu cổ vật hoàng cung thất lạc trong các bức tranh đại nội cổ xưa.',
      gameMode: 'Giải đố mật mã • Thám hiểm cung đình',
      duration: '3 - 4 phút',
      difficulty: 'Hóc búa',
      coinReward: 15,
      xpReward: 180,
      itemReward: 'Bình Gốm Chu Đậu',
      screenBuilder: (context) => const HiddenRelicGameScreen(),
    ),

    // 5. Cờ Lau Tập Trận
    GameItemModel(
      id: 'co_lau_tactics',
      title: 'Cờ Lau Tập Trận',
      shortName: 'Cờ Lau',
      category: 'Chiến thuật',
      icon: Icons.flag_rounded,
      gradientColors: const [Color(0xFFC2185B), Color(0xFFEC407A)],
      badge: 'CHIẾN THUẬT',
      isPlayable: true,
      howToPlay: 'Hóa thân thành mục đồng Đinh Bộ Lĩnh, bày binh bố trận với cờ bông lau bên sông Hoàng Long, chiếm các gò đất cao để chiến thắng đối phương!',
      gameMode: 'Chiến thuật lượt đi • Chiếm cứ điểm',
      duration: '4 - 6 phút',
      difficulty: 'Khó',
      coinReward: 25,
      xpReward: 250,
      itemReward: 'Cờ Lệnh Hoàng Đế',
      screenBuilder: (context) => const CoLauGameScreen(),
    ),

    // 6. Bạch Đằng Cọc Ngầm
    GameItemModel(
      id: 'bach_dang_defense',
      title: 'Bạch Đằng Cọc Ngầm',
      shortName: 'Bạch Đằng',
      category: 'Chiến thuật',
      icon: Icons.waves_rounded,
      gradientColors: const [Color(0xFF00695C), Color(0xFF26A69A)],
      badge: 'CHIẾN TRẬN',
      isPlayable: true,
      howToPlay: 'Canh chuẩn xác thời điểm con nước thủy triều rút để dụ chiến thuyền giặc vào bãi cọc nhọn bịt sắt, nhấn chìm hạm đội xâm lược!',
      gameMode: 'Thủ thành chiến thuật • Canh giờ thủy triều',
      duration: '3 - 5 phút',
      difficulty: 'Chiến thuật',
      coinReward: 25,
      xpReward: 220,
      itemReward: 'Cọc Gỗ Bịt Sắt',
      screenBuilder: (context) => const BachDangGameScreen(),
    ),

    // 7. Đấu Trí 1v1
    GameItemModel(
      id: 'pvp_duel',
      title: 'Đấu Trí 1v1',
      shortName: 'Đấu 1v1',
      category: 'Đối kháng',
      icon: Icons.sports_kabaddi_rounded,
      gradientColors: const [Color(0xFFD84315), Color(0xFFFF7043)],
      badge: '1v1',
      isPlayable: true,
      isLandscape: true,
      howToPlay: 'Thách đấu thời gian thực cùng bạn bè trên Bảng Vàng! Trả lời 5 câu hỏi lịch sử siêu tốc, ai nhanh tay và chính xác hơn sẽ đoạt cúp vô địch.',
      gameMode: 'PvP trực tuyến • Đua điểm leo Rank',
      duration: '1 - 2 phút',
      difficulty: 'Kịch tính',
      coinReward: 40,
      xpReward: 300,
      itemReward: 'Cúp Đấu Trí Bảng Vàng',
      screenBuilder: (context) => const PvPDuelMockScreen(),
    ),

    // 8. Vua Chữ Sử Ký
    GameItemModel(
      id: 'word_scramble',
      title: 'Vua Chữ Sử Ký',
      shortName: 'Vua Chữ',
      category: 'Trí tuệ',
      icon: Icons.spellcheck_rounded,
      gradientColors: const [Color(0xFF37474F), Color(0xFF78909C)],
      badge: 'GIẢI ĐỐ',
      isPlayable: true,
      howToPlay: 'Sắp xếp lại các chữ cái bị xáo trộn để tạo thành tên đúng của các danh nhân, triều đại và địa danh lịch sử hào hùng của nước ta.',
      gameMode: 'Ghép chữ nhanh • 60 giây / câu',
      duration: '2 phút',
      difficulty: 'Dễ',
      coinReward: 8,
      xpReward: 100,
      itemReward: 'Bút Lông Trạng Nguyên',
      screenBuilder: (context) => const WordScrambleGameScreen(),
    ),

    // 9. Kỳ Đài Trạng Nguyên
    GameItemModel(
      id: 'trang_nguyen_arena',
      title: 'Kỳ Đài Trạng Nguyên',
      shortName: 'Khoa Bảng',
      category: 'Trí tuệ',
      icon: Icons.military_tech_rounded,
      gradientColors: const [Color(0xFFF57F17), Color(0xFFFFB300)],
      badge: 'TRẠNG NGUYÊN',
      isPlayable: true,
      howToPlay: 'Vượt qua 3 cửa ải Hương - Hội - Đình với bộ câu hỏi văn sách cổ điển để khắc tên lên bia đá Văn Miếu và vinh quy bái tổ!',
      gameMode: 'Thi cử Nho học • Vượt ải liên hoàn',
      duration: '5 phút',
      difficulty: 'Rất khó',
      coinReward: 35,
      xpReward: 350,
      itemReward: 'Mũ Áo Cánh Chuồn',
      screenBuilder: (context) => const TrangNguyenGameScreen(),
    ),

    // 10. Nỏ Thần Cổ Loa
    GameItemModel(
      id: 'co_loa_archery',
      title: 'Nỏ Thần Cổ Loa',
      shortName: 'Nỏ Thần',
      category: 'Hành động',
      icon: Icons.track_changes_rounded,
      gradientColors: const [Color(0xFF880E4F), Color(0xFFAD1457)],
      badge: 'BẮN NỎ',
      isPlayable: true,
      isLandscape: true, // Hành động xoay ngang
      howToPlay: 'Sử dụng nỏ thần Kim Quy ngắm bắn chính xác vào các toán thuyền và thang vây thành của quân xâm lược ngoài 9 vòng thành ốc.',
      gameMode: 'Ngắm bắn mục tiêu • Tính điểm chính xác',
      duration: '2 - 3 phút',
      difficulty: 'Phản xạ',
      coinReward: 15,
      xpReward: 160,
      itemReward: 'Mũi Tên Đồng Cổ Loa',
      screenBuilder: (context) => const ArcheryMockScreen(),
    ),

    // 11. Bảo Vệ Thành Cổ
    GameItemModel(
      id: 'thanh_tri_defense',
      title: 'Bảo Vệ Thành Cổ',
      shortName: 'Thủ Thành',
      category: 'Chiến thuật',
      icon: Icons.castle_rounded,
      gradientColors: const [Color(0xFF4A148C), Color(0xFF7B1FA2)],
      badge: 'THỦ THÀNH',
      isPlayable: true,
      howToPlay: 'Bố trí cung thủ, máy bắn đá và quân cảm tử trấn giữ 4 cửa ô thành Thăng Long trước các đợt công kích của ngoại bang.',
      gameMode: 'Thủ thành chiến thuật • 10 làn sóng địch',
      duration: '5 - 7 phút',
      difficulty: 'Chiến thuật',
      coinReward: 20,
      xpReward: 260,
      itemReward: 'Khiên Đồng Đông Sơn',
      screenBuilder: (context) => const ThanhTriGameScreen(),
    ),

    // 12. Thuyền Rồng Tây Sơn
    GameItemModel(
      id: 'tay_son_warship',
      title: 'Thuyền Rồng Tây Sơn',
      shortName: 'Thủy Chiến',
      category: 'Hành động',
      icon: Icons.sailing_rounded,
      gradientColors: const [Color(0xFF0D47A1), Color(0xFF1976D2)],
      badge: 'THỦY CHIẾN',
      isPlayable: true,
      howToPlay: 'Lèo lái chiến thuyền rồng vượt sóng Rạch Gầm - Xoài Mút, nã pháo hỏa hổ tiêu diệt hạm đội 3 vạn quân thủy Xiêm La!',
      gameMode: 'Thủy chiến hành động • Bắn pháo diệt địch',
      duration: '3 - 4 phút',
      difficulty: 'Nhanh nhẹn',
      coinReward: 15,
      xpReward: 190,
      itemReward: 'Hỏa Hổ Tây Sơn',
      screenBuilder: (context) => const TaySonGameScreen(),
    ),

    // 13. Đèn Kéo Quân
    GameItemModel(
      id: 'den_keo_quan',
      title: 'Đèn Kéo Quân',
      shortName: 'Đèn Kéo Quân',
      category: 'Dân gian',
      icon: Icons.light_mode_rounded,
      gradientColors: const [Color(0xFFBF360C), Color(0xFFFF5722)],
      badge: 'TRUYỀN THỐNG',
      isPlayable: true,
      howToPlay: 'Quan sát bóng các danh nhân diễu qua lòng đèn kéo quân và đoán chính xác tên nhân vật lịch sử trong bóng mờ.',
      gameMode: 'Đoán bóng danh nhân • 10 câu hỏi',
      duration: '2 - 3 phút',
      difficulty: 'Trung bình',
      coinReward: 10,
      xpReward: 130,
      itemReward: 'Đèn Lồng Lục Giác',
      screenBuilder: (context) => const DenKeoQuanGameScreen(),
    ),

    // 14. Cờ Tướng Cổ Truyền
    GameItemModel(
      id: 'co_tuong',
      title: 'Cờ Tướng Cổ Truyền',
      shortName: 'Cờ Tướng',
      category: 'Dân gian',
      icon: Icons.casino_rounded,
      gradientColors: const [Color(0xFF3E2723), Color(0xFF8D6E63)],
      badge: 'KỲ THỦ',
      isPlayable: true,
      howToPlay: 'Đấu cờ tướng cổ điển trên bàn cờ gỗ sông Sở hào Hán. So tài mưu lược chiếu tướng bắt xe cùng các danh kỳ hội làng.',
      gameMode: 'Đấu trí 1v1 • Đánh cờ thế',
      duration: '5 - 10 phút',
      difficulty: 'Cao thủ',
      coinReward: 30,
      xpReward: 320,
      itemReward: 'Quân Cờ Gỗ Mun',
      screenBuilder: (context) => const CoTuongGameScreen(),
    ),

    // 15. Rồng Rắn Lên Mây
    GameItemModel(
      id: 'rong_ran',
      title: 'Rồng Rắn Lên Mây',
      shortName: 'Rồng Rắn',
      category: 'Dân gian',
      icon: Icons.gesture_rounded,
      gradientColors: const [Color(0xFF004D40), Color(0xFF00897B)],
      badge: 'TUỔI THƠ',
      isPlayable: true,
      howToPlay: 'Dẫn dắt đoàn rồng rắn luồn lách né tránh ông thầy thuốc bắt khúc đuôi, thu thập hoa quả và ngọc quý trên đường chạy!',
      gameMode: 'Chạy né chướng ngại vật • Snake cổ phong',
      duration: '2 phút',
      difficulty: 'Dễ',
      coinReward: 5,
      xpReward: 110,
      itemReward: 'Trống Cơm Dân Gian',
      screenBuilder: (context) => const RongRanGameScreen(),
    ),

    // 16. Lễ Hội Ném Còn
    GameItemModel(
      id: 'nem_con',
      title: 'Lễ Hội Ném Còn',
      shortName: 'Ném Còn',
      category: 'Dân gian',
      icon: Icons.adjust_rounded,
      gradientColors: const [Color(0xFF827717), Color(0xFFC0CA33)],
      badge: 'LỄ HỘI',
      isPlayable: true,
      howToPlay: 'Căn chỉnh lực và hướng gió để ném quả còn ngũ sắc bay vút qua vòng tròn trên cây nêu cao giữa sân hội mùa xuân.',
      gameMode: 'Vật lý căn lực • Hội làng Tây Bắc',
      duration: '2 phút',
      difficulty: 'Khéo léo',
      coinReward: 5,
      xpReward: 140,
      itemReward: 'Quả Còn Ngũ Sắc',
      screenBuilder: (context) => const NemConGameScreen(),
    ),
  ];
}
