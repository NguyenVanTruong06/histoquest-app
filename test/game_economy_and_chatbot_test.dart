import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_dau_tien/data/mock_data.dart';
import 'package:app_mobile_dau_tien/features/games/data/game_economy_service.dart';
import 'package:app_mobile_dau_tien/features/chatbot/data/historical_ai_service.dart';
import 'package:app_mobile_dau_tien/features/chatbot/presentation/controllers/chatbot_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameEconomyService Tests', () {
    test('awardGameRewards updates coins, xp and quests count', () {
      final initialCoins = MockData.currentUser.coins;
      final initialXp = MockData.currentUser.xp;
      final initialQuests = MockData.currentUser.totalQuestsCompleted;

      final updated = GameEconomyService.awardGameRewards(
        coins: 50,
        xp: 150,
        gameTitle: 'Cờ Ô Ăn Quan',
      );

      expect(updated.coins, initialCoins + 50);
      expect(updated.xp, initialXp + 150);
      expect(updated.totalQuestsCompleted, initialQuests + 1);
      expect(MockData.currentUser.coins, updated.coins);
    });
  });

  group('HistoricalAiService & ChatbotNotifier Tests', () {
    const aiService = HistoricalAiService();

    test('HistoricalAiService answers questions about historical figures', () async {
      final response = await aiService.askQuestion('Kể cho tôi nghe về Ngô Quyền và chiến thắng Bạch Đằng');
      expect(response.isUser, isFalse);
      expect(response.text.isNotEmpty, isTrue);
      expect(response.text.toLowerCase().contains('bạch đằng') || response.text.toLowerCase().contains('ngô quyền'), isTrue);
    });

    test('HistoricalAiService handles unknown questions gracefully with suggestions', () async {
      final response = await aiService.askQuestion('Thời tiết ngày mai thế nào?');
      expect(response.isUser, isFalse);
      expect(response.text.isNotEmpty, isTrue);
      expect(response.followUps?.isNotEmpty, isTrue);
    });

    test('ChatbotNotifier manages message history properly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialMessages = container.read(chatbotProvider).messages;
      expect(initialMessages.length, 1);
      expect(initialMessages.first.id, 'welcome');

      // Send a user question
      await container.read(chatbotProvider.notifier).sendMessage('Hai Bà Trưng khởi nghĩa năm nào?');

      final updatedMessages = container.read(chatbotProvider).messages;
      expect(updatedMessages.length, 3); // welcome + user message + bot response
      expect(updatedMessages[1].isUser, isTrue);
      expect(updatedMessages[2].isUser, isFalse);
    });
  });
}
