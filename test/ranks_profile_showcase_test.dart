import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_dau_tien/data/mock_data.dart';
import 'package:app_mobile_dau_tien/features/ranks/presentation/ranks_screen.dart';
import 'package:app_mobile_dau_tien/features/ranks/presentation/widgets/player_profile_showcase_sheet.dart';

void main() {
  setUp(() {
    MockData.currentUser = MockData.currentUser.copyWith(
      coins: 1250,
      streakDays: 5,
      currentFrameId: 'frame_dragon',
      currentBannerId: 'banner_thang_long',
    );
  });

  group('RanksScreen & Player Profile Showcase Tests', () {
    testWidgets('RanksScreen renders podium with equipped frames and titles',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: RanksScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Check header and tabs
      expect(find.text('Bảng Vàng'), findsOneWidget);
      expect(find.text('Đấu Hạng Tuần'), findsOneWidget);
      expect(find.text('Điểm Mùa'), findsOneWidget);
      expect(find.text('Bia Tiến Sĩ'), findsOneWidget);

      // Check top 1 winner Minh Quân and his title
      expect(find.text('Minh Quân'), findsOneWidget);
      expect(find.text('Bậc thầy sử học'), findsOneWidget);

      // Check top 2 Bảo Trâm and her title
      expect(find.text('Bảo Trâm'), findsOneWidget);
      expect(find.text('Hàn Lâm Viện Đại Sĩ'), findsOneWidget);

      // Check hint banner
      expect(
        find.text('Chạm vào người chơi để xem Khung, Danh hiệu & Thách đấu'),
        findsOneWidget,
      );
    });

    testWidgets('Tapping Top 1 player opens PlayerProfileShowcaseSheet with custom banner, frame, bio and duel',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: RanksScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on Top 1 player Minh Quân
      await tester.tap(find.text('Minh Quân'));
      await tester.pumpAndSettle();

      // Verify modal sheet is opened
      expect(find.byType(PlayerProfileShowcaseSheet), findsOneWidget);
      expect(find.text('Top 1'), findsOneWidget);
      expect(find.text('Đêm Huyền Ảo Cố Đô'), findsOneWidget); // Minh Quân's equipped banner (banner_hue)
      expect(find.text('Bậc thầy sử học'), findsWidgets); // Title
      expect(find.text('"Sử sách là gương sáng soi đường thiên thu 📖"'), findsOneWidget);
      expect(find.text('Trần Quốc Tuấn (Hưng Đạo Vương)'), findsOneWidget);
      expect(find.text('Đại Khoa Bảng'), findsOneWidget);
      expect(find.text('Bất Bại Sử Ký'), findsOneWidget);

      // Test Thả Tim interaction
      expect(find.text('189 Tim'), findsOneWidget);
      await tester.tap(find.text('189 Tim'));
      await tester.pumpAndSettle();
      expect(find.text('190 Tim'), findsOneWidget);

      // Test Thách Đấu 1v1 button
      expect(find.text('Thách Đấu 1v1'), findsOneWidget);
      await tester.tap(find.text('Thách Đấu 1v1'));
      await tester.pumpAndSettle();
      expect(find.text('Thách Đấu Sử Ký'), findsOneWidget);
      expect(find.text('Gửi Thách Đấu'), findsOneWidget);

      // Tap Gửi Thách Đấu to dismiss dialog
      await tester.tap(find.text('Gửi Thách Đấu'));
      await tester.pumpAndSettle();
    });

    testWidgets('Tapping current user An (Bạn) opens showcase with customization button',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: RanksScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll list if needed and find An
      final userTile = find.text('An');
      expect(userTile, findsOneWidget);
      await tester.tap(userTile);
      await tester.pumpAndSettle();

      // Verify modal sheet shows user's own profile options
      expect(find.byType(PlayerProfileShowcaseSheet), findsOneWidget);
      expect(find.text('Hồ sơ của bạn'), findsOneWidget);
      expect(find.text('Tùy Chỉnh Khung & Ảnh Bìa (Cửa Hàng)'), findsOneWidget);
    });
  });
}
