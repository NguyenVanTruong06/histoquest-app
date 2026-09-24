import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_dau_tien/shared/widgets/custom_floating_bottom_nav.dart';
import 'package:app_mobile_dau_tien/features/settings/presentation/settings_screen.dart';

void main() {
  group('CustomFloatingBottomNav Widget Tests', () {
    testWidgets('renders all 4 HistoQuest tabs, notification badge 3, and settings button', (tester) async {
      int tappedIndex = -1;
      bool settingsTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomFloatingBottomNav(
              currentIndex: 0,
              isSettingsSelected: false,
              onTap: (index) => tappedIndex = index,
              onSettingsTap: () => settingsTapped = true,
            ),
          ),
        ),
      );

      // Verify HistoQuest tabs
      expect(find.text('Bản đồ'), findsOneWidget);
      expect(find.text('Bảng vàng'), findsOneWidget);
      expect(find.text('Trò chơi'), findsOneWidget);
      expect(find.text('Bản tin'), findsOneWidget);

      // Verify badge
      expect(find.text('3'), findsOneWidget);

      // Verify settings icon
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);

      // Tap on 'Trò chơi' (tab index 2)
      await tester.tap(find.text('Trò chơi'));
      expect(tappedIndex, 2);

      // Tap on settings button
      await tester.tap(find.byIcon(Icons.settings_rounded));
      expect(settingsTapped, isTrue);
    });

    testWidgets('CustomFloatingBottomNav supports custom labels & badges', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomFloatingBottomNav(
              currentIndex: 0,
              items: const [
                FloatingNavItem(label: 'Test Tab', icon: Icons.star_rounded, badge: '99'),
              ],
              onTap: (_) {},
              onSettingsTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Tab'), findsOneWidget);
      expect(find.text('99'), findsOneWidget);
    });
  });

  group('SettingsScreen Widget Tests', () {
    testWidgets('renders all groups, titles, version info, and handles switches', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      // Check title
      expect(find.text('Hồ Sơ & Cài Đặt'), findsOneWidget);

      // Hero Profile Header & Quick Stats Hub
      expect(find.text('Cửa Hàng'), findsOneWidget);
      expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
      expect(find.text('Xu Sử Quán'), findsOneWidget);
      expect(find.text('Ngày Streak'), findsOneWidget);
      expect(find.text('Thẻ Tướng'), findsOneWidget);

      // Group 1: Trải nghiệm học sử
      expect(find.text('Ngôn ngữ'), findsOneWidget);
      expect(find.text('Hiệu Ứng Âm Thanh'), findsOneWidget);
      expect(find.text('Nhắc nhở hàng ngày'), findsOneWidget);

      // Scroll down to find items lower in the list
      await tester.scrollUntilVisible(find.text('Dọn dẹp bộ nhớ đệm (Cache)'), 200);
      expect(find.text('Dọn dẹp bộ nhớ đệm (Cache)'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Đánh giá HistoQuest trên App Store'), 200);
      expect(find.text('Đánh giá HistoQuest trên App Store'), findsOneWidget);
      expect(find.text('Chia sẻ HistoQuest'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Điều khoản Dịch vụ Sử Quán'), 200);
      expect(find.text('Điều khoản Dịch vụ Sử Quán'), findsOneWidget);
      expect(find.text('Chính sách Bảo mật'), findsOneWidget);
      expect(find.text('Đóng góp sử liệu & Phản hồi'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Đăng xuất'), 200);
      expect(find.text('Đăng xuất'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('HistoQuest 1.0.0 (168) ❤️ HistoQuest Team'), 200);
      expect(find.text('HistoQuest 1.0.0 (168) ❤️ HistoQuest Team'), findsOneWidget);
    });

    testWidgets('Tapping SettingsScreen items triggers popups and actions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      // Tap on Streak in Quick Stats Hub
      await tester.tap(find.text('Ngày Streak'));
      await tester.pumpAndSettle();
      expect(find.text('Chuỗi Streak Lửa Thiêng'), findsOneWidget);
      await tester.tap(find.text('Quyết Tâm Giữ Chuỗi!'));
      await tester.pumpAndSettle();

      // Test sound toggle
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      final switchFinder = find.byType(CupertinoSwitch);
      expect(switchFinder, findsOneWidget);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
    });
  });
}
