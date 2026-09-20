import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_dau_tien/shared/widgets/custom_floating_bottom_nav.dart';
import 'package:app_mobile_dau_tien/features/chatbot/presentation/mascot_chatbot_sheet.dart';
import 'package:app_mobile_dau_tien/core/config/feature_flags.dart';

void main() {
  group('Mascot & Chatbot Feature Tests', () {
    testWidgets('Chatbot button is rendered when FeatureFlags.enableAiChatbot is true', (tester) async {
      bool chatbotTapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CustomFloatingBottomNav(
                currentIndex: 0,
                onTap: (_) {},
                onSettingsTap: () {},
                onChatbotTap: () => chatbotTapped = true,
              ),
            ),
          ),
        ),
      );

      if (FeatureFlags.enableAiChatbot) {
        expect(find.text('AI'), findsOneWidget);
        final tooltipFinder = find.byTooltip('Trợ lý Sử Ký Bé Sửu (Đang phát triển)');
        expect(tooltipFinder, findsOneWidget);
        await tester.tap(tooltipFinder);
        expect(chatbotTapped, isTrue);
      }
    });

    testWidgets('MascotChatbotSheet displays interactive chat flow with Thu Sinh Nguu', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => MascotChatbotSheet.show(context),
                  child: const Text('Open Sheet'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open the sheet
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Check header title & online indicator
      expect(find.text('VĂN MIẾU THƯ SINH NGƯU'), findsOneWidget);
      expect(find.textContaining('Trợ lý Sử Ký AI'), findsOneWidget);

      // Check greeting bubble
      expect(find.textContaining('Câu hỏi của bạn về thi cử xưa'), findsOneWidget);

      // Test sending a question via input field
      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'Ai là vị Trạng nguyên trẻ nhất nước ta?');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Cuộn xuống để xem tin nhắn mới
      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pump();

      // Verify user message appeared
      expect(find.text('Ai là vị Trạng nguyên trẻ nhất nước ta?'), findsOneWidget);

      // Fast-forward simulated thinking delay
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pumpAndSettle();

      // Cuộn xuống để xem tin nhắn trả lời
      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pump();

      // Verify smart historical answer from Bé Sửu
      expect(find.textContaining('Nguyễn Hiền'), findsOneWidget);
    });
  });
}
