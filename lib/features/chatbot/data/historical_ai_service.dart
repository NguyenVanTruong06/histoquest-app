import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../domain/models/chat_message_model.dart';
import '../../../core/config/feature_flags.dart';

/// Mô hình một mục tri thức lịch sử trong file chatbot_knowledge.json
class KnowledgeItem {
  final String id;
  final String topic;
  final List<String> keywords;
  final String answer;
  final List<String> followUps;

  const KnowledgeItem({
    required this.id,
    required this.topic,
    required this.keywords,
    required this.answer,
    required this.followUps,
  });

  factory KnowledgeItem.fromJson(Map<String, dynamic> json) {
    return KnowledgeItem(
      id: json['id'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => e.toString().toLowerCase().trim())
              .toList() ??
          [],
      answer: json['answer'] as String? ?? '',
      followUps: (json['followUps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

/// Dịch vụ xử lý trí tuệ nhân tạo lịch sử cho Bé Sửu - Văn Miếu Thư Sinh Ngưu
/// 
/// Dữ liệu câu hỏi & câu trả lời được nạp tự động từ:
/// 👉 `assets/data/chatbot_knowledge.json`
class HistoricalAiService {
  static List<KnowledgeItem>? _cachedKnowledge;

  const HistoricalAiService();

  /// Tải dữ liệu từ file JSON (lưu cache trong bộ nhớ để truy xuất tức thì)
  Future<List<KnowledgeItem>> _loadKnowledge() async {
    if (_cachedKnowledge != null) return _cachedKnowledge!;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/chatbot_knowledge.json');
      final List<dynamic> list = json.decode(jsonString);
      _cachedKnowledge = list.map((e) => KnowledgeItem.fromJson(e)).toList();
      return _cachedKnowledge!;
    } catch (_) {
      return [];
    }
  }

  /// Gửi câu hỏi và nhận câu trả lời từ Thư Sinh Ngưu
  Future<ChatMessage> askQuestion(String userPrompt) async {
    // 1. Nếu có cấu hình API Key thực và cho phép dùng Cloud AI:
    if (FeatureFlags.geminiApiKey.isNotEmpty) {
      try {
        return await _callGeminiApi(userPrompt);
      } catch (_) {
        // Fallback tự động về Offline Engine nếu mạng/quota API lỗi
      }
    }

    // 2. Chế độ Mặc định: Trí tuệ cục bộ thông minh đọc từ chatbot_knowledge.json
    await Future.delayed(const Duration(milliseconds: 900)); // Hiệu ứng suy ngẫm mài mực
    return await _generateSmartHistoricalResponse(userPrompt);
  }

  /// Bộ xử lý ngôn ngữ lịch sử thông minh (Đọc từ file JSON)
  Future<ChatMessage> _generateSmartHistoricalResponse(String prompt) async {
    final query = prompt.toLowerCase().trim();
    final knowledgeList = await _loadKnowledge();

    KnowledgeItem? matchedItem;
    for (final item in knowledgeList) {
      for (final kw in item.keywords) {
        if (query.contains(kw)) {
          matchedItem = item;
          break;
        }
      }
      if (matchedItem != null) break;
    }

    String answer;
    List<String> followUps;

    if (matchedItem != null) {
      answer = matchedItem.answer;
      followUps = matchedItem.followUps;
    } else {
      answer = 'Câu hỏi của bạn hiền thật sâu sắc! Về vấn đề "$prompt", sử tích xưa ghi lại muôn vàn chiến công hiển hách và nét văn hoá độc đáo của tổ tiên ta.\n\n'
          'Bạn có muốn cùng ta khám phá chi tiết hơn về một trong các thời kỳ rực rỡ dưới đây không?';
      followUps = [
        'Chuyện thi cử khoa bảng Văn Miếu',
        'Vị Trạng nguyên trẻ nhất Nguyễn Hiền',
        'Khởi nghĩa Hai Bà Trưng năm 40',
        'Chiến thắng Bạch Đằng lừng lẫy',
        'Tích cờ lau tập trận Đinh Bộ Lĩnh'
      ];
    }

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: answer,
      isUser: false,
      timestamp: DateTime.now(),
      followUps: followUps,
    );
  }

  /// Khung kết nối Google Gemini API (Sẵn sàng kích hoạt khi có API Key)
  Future<ChatMessage> _callGeminiApi(String userPrompt) async {
    return _generateSmartHistoricalResponse(userPrompt);
  }
}
