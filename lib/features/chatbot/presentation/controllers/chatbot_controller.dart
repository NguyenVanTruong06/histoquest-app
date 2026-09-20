import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat_message_model.dart';
import '../../data/historical_ai_service.dart';

class ChatbotState {
  final List<ChatMessage> messages;
  final bool isThinking;

  const ChatbotState({
    required this.messages,
    this.isThinking = false,
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isThinking,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isThinking: isThinking ?? this.isThinking,
    );
  }
}

class ChatbotNotifier extends Notifier<ChatbotState> {
  @override
  ChatbotState build() {
    return ChatbotState(
      messages: [
        ChatMessage(
          id: 'welcome',
          text: 'Chào bạn hiền! Ta là Văn Miếu Thư Sinh Ngưu. Câu hỏi của bạn về thi cử xưa và những trang sử hào hùng của nước ta là gì?',
          isUser: false,
          timestamp: DateTime.now(),
          followUps: const [
            '📜 Kỳ thi Đình thời Lê diễn ra thế nào?',
            '⭐ Vị Trạng nguyên trẻ nhất nước Nam là ai?',
            '🏛️ Ý nghĩa biểu tượng của Khuê Văn Các?',
            '🚩 Sự tích cờ lau tập trận Đinh Bộ Lĩnh?',
          ],
        ),
      ],
    );
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isThinking: true,
    );

    final aiService = ref.read(historicalAiServiceProvider);
    try {
      final response = await aiService.askQuestion(trimmed);
      state = state.copyWith(
        messages: [...state.messages, response],
        isThinking: false,
      );
    } catch (_) {
      final errorMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Thứ lỗi cho ta, nghiên mực vừa khô. Bạn hiền hỏi lại một câu khác nhé!',
        isUser: false,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, errorMsg],
        isThinking: false,
      );
    }
  }

  void clearHistory() {
    state = build();
  }
}

final historicalAiServiceProvider = Provider<HistoricalAiService>((ref) {
  return const HistoricalAiService();
});

final chatbotProvider =
    NotifierProvider<ChatbotNotifier, ChatbotState>(ChatbotNotifier.new);
