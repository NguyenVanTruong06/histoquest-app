import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_dau_tien/features/games/presentation/games_screen.dart';
import 'package:app_mobile_dau_tien/features/games/presentation/widgets/game_mode_detail_sheet.dart';
import 'package:app_mobile_dau_tien/features/games/presentation/timeline_rush_screen.dart';

void main() {
  group('GamesScreen 4x4 App Grid & Mode Detail Sheet Tests', () {
    testWidgets('renders 4x4 app icons, categories and launches mode overview on tap',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: GamesScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Header & Banner
      expect(find.text('Trò Chơi Dân Gian'), findsOneWidget);
      expect(find.text('Sảnh Trò Chơi Lịch Sử'), findsOneWidget);

      // Verify 4-column game icons exist
      expect(find.text('Timeline'), findsOneWidget);
      expect(find.text('Ô Ăn Quan'), findsOneWidget);
      expect(find.text('Thẻ Tướng'), findsOneWidget);
      expect(find.text('Cổ Vật'), findsOneWidget);

      // Tap on 'Timeline' icon
      await tester.tap(find.text('Timeline'));
      await tester.pumpAndSettle();

      // Verify GameModeDetailSheet opens with rules & rewards
      expect(find.byType(GameModeDetailSheet), findsOneWidget);
      expect(find.text('Timeline Rush'), findsOneWidget);
      expect(find.textContaining('Kéo thả và sắp xếp'), findsOneWidget);
      expect(find.text('+15 xu'), findsOneWidget);
      expect(find.text('+200 XP'), findsOneWidget);
      expect(find.text('VÀO CHƠI NGAY'), findsOneWidget);

      // Tap 'VÀO CHƠI NGAY'
      await tester.tap(find.text('VÀO CHƠI NGAY'));
      await tester.pumpAndSettle();

      // Verify navigated to TimelineRushScreen
      expect(find.byType(TimelineRushScreen), findsOneWidget);
    });

    testWidgets('Filter by category works in GamesScreen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: GamesScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Filter by 'Trí tuệ'
      await tester.tap(find.text('Trí tuệ'));
      await tester.pumpAndSettle();

      // Timeline is in 'Trí tuệ', Mancala ('Dân gian') should not appear in this filtered list
      expect(find.text('Timeline'), findsOneWidget);
      expect(find.text('Ô Ăn Quan'), findsNothing);
    });
  });
}
