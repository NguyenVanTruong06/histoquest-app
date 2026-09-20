import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../domain/models/chat_message_model.dart';
import 'controllers/chatbot_controller.dart';

/// Màn hình đàm thoại tương tác với Trợ lý Lịch Sử AI "Văn Miếu Thư Sinh Ngưu"
class MascotChatbotSheet extends ConsumerStatefulWidget {
  const MascotChatbotSheet({super.key});

  /// Hàm mở giao diện trò chuyện từ bất kỳ đâu trong app
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MascotChatbotSheet(),
    );
  }

  @override
  ConsumerState<MascotChatbotSheet> createState() => _MascotChatbotSheetState();
}

class _MascotChatbotSheetState extends ConsumerState<MascotChatbotSheet> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend([String? presetText]) {
    final text = presetText ?? _textController.text;
    if (text.trim().isEmpty) return;

    ref.read(chatbotProvider.notifier).sendMessage(text);
    if (presetText == null) {
      _textController.clear();
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatbotProvider);
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;

    // Tự động cuộn xuống khi có tin nhắn mới hoặc đang suy nghĩ
    ref.listen(chatbotProvider, (previous, next) {
      _scrollToBottom();
    });

    return Container(
      height: screenHeight * 0.92,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F0), // Nền giấy điệp cổ kính
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            width: 42,
            height: 4.5,
            decoration: BoxDecoration(
              color: Colors.brown.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // 2. Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                // Avatar Thư Sinh Ngưu viền vàng
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFC89B3C), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/mascot/thu_sinh_nguu_avatar.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.smart_toy_rounded,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Tiêu đề & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VĂN MIẾU THƯ SINH NGƯU',
                        style: GoogleFonts.philosopher(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3E2723),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Trợ lý Sử Ký AI • Sẵn sàng đàm đạo',
                            style: GoogleFonts.roboto(
                              fontSize: 11.5,
                              color: const Color(0xFF5D4037),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Nút xoá cuộc trò chuyện
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Colors.black45, size: 22),
                  onPressed: () => ref.read(chatbotProvider.notifier).clearHistory(),
                  tooltip: 'Bắt đầu cuộc trò chuyện mới',
                ),

                // Nút đóng
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.black54),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Đóng',
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFE6DEC9)),

          // 3. Khung trò chuyện cuộn được (Message Stream)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              itemCount: chatState.messages.length + 1 + (chatState.isThinking ? 1 : 0),
              itemBuilder: (context, index) {
                // Item 0: Ảnh minh họa trường thi xưa (như ảnh mockup của người dùng)
                if (index == 0) {
                  return _buildHeroDeskBanner();
                }

                // Item cuối: Indicator Bé Sửu đang suy nghĩ
                if (chatState.isThinking && index == chatState.messages.length + 1) {
                  return _buildThinkingBubble();
                }

                final message = chatState.messages[index - 1];
                return _buildMessageItem(message);
              },
            ),
          ),

          // 4. Thanh câu hỏi gợi ý nhanh (Quick Suggestions Bar)
          _buildQuickSuggestionsBar(),

          // 5. Khung nhập liệu thời gian thực (Input Bar)
          Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 10 + bottomInset),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(
                top: BorderSide(color: Color(0xFFECEFF1), width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Nút câu hỏi mẫu (+)
                IconButton(
                  icon: const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Color(0xFFC89B3C),
                    size: 24,
                  ),
                  tooltip: 'Gợi ý câu hỏi',
                  onPressed: () {
                    _handleSend('Kể cho ta nghe về truyền thống thi cử Văn Miếu xưa');
                  },
                ),

                // TextField nhập tin nhắn
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: TextField(
                      controller: _textController,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: const Color(0xFF263238),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Mời bạn hỏi Bé Sửu...',
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 13.5,
                          color: Colors.black38,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Nút Gửi (Mũi tên xanh tròn)
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _textController,
                  builder: (context, value, _) {
                    final hasText = value.text.trim().isNotEmpty;
                    return Material(
                      color: hasText ? const Color(0xFF1976D2) : const Color(0xFFB0BEC5),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: hasText ? () => _handleSend() : null,
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Banner Thư phòng trường thi xưa (khớp theo ảnh mockup người dùng cung cấp)
  Widget _buildHeroDeskBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD7CCC8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              'assets/images/mascot/thu_sinh_nguu_desk.jpg',
              fit: BoxFit.cover,
              height: 180,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 140,
                color: const Color(0xFFEFEBE9),
                child: const Center(
                  child: Icon(Icons.school_rounded, size: 50, color: Colors.brown),
                ),
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Thư Viện Sử Ký & Trường Thi Văn Miếu',
                style: GoogleFonts.philosopher(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(blurRadius: 4, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bong bóng hiển thị một tin nhắn
  Widget _buildMessageItem(ChatMessage message) {
    if (message.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: 48),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2), // Màu xanh trang nhã
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1976D2).withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: GoogleFonts.roboto(
                    fontSize: 13.5,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Tin nhắn từ Thư Sinh Ngưu
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar nhỏ
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFC89B3C), width: 1.5),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/mascot/thu_sinh_nguu_avatar.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Bong bóng thoại
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: const Color(0xFFE2D9C8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildRichFormattedText(
                    message.text,
                    baseStyle: GoogleFonts.roboto(
                      fontSize: 13.5,
                      color: const Color(0xFF2C3E50),
                      height: 1.45,
                    ),
                    boldColor: const Color(0xFF1B5E20), // Màu xanh đậm trang nhã cho chữ in đậm
                  ),
                ),
              ),
            ],
          ),

          // Các câu hỏi gợi ý tiếp theo (Follow-ups) nếu có
          if (message.followUps != null && message.followUps!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: message.followUps!.map((suggestion) {
                  return InkWell(
                    onTap: () => _handleSend(suggestion),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1EAD9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFD7CCC8), width: 0.8),
                      ),
                      child: Text(
                        suggestion,
                        style: GoogleFonts.roboto(
                          fontSize: 11.5,
                          color: const Color(0xFF4E342E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Indicator Bé Sửu đang suy nghĩ / mài mực
  Widget _buildThinkingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC89B3C), width: 1.5),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/mascot/thu_sinh_nguu_avatar.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2D9C8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 13,
                  height: 13,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFC89B3C),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Bé Sửu đang mài mực suy ngẫm...',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF6D4C41),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Thanh câu hỏi nhanh cuộn ngang trên bàn phím
  Widget _buildQuickSuggestionsBar() {
    const suggestions = [
      '📜 Kỳ thi Đình thời xưa',
      '⭐ Trạng nguyên trẻ nhất nước Nam',
      '🏛️ Ý nghĩa của Khuê Văn Các',
      '🚩 Sự tích cờ lau Đinh Bộ Lĩnh',
      '⚔️ Chiến thắng Bạch Đằng',
    ];

    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final text = suggestions[index];
          return ActionChip(
            label: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 11.5,
                color: const Color(0xFF3E2723),
              ),
            ),
            backgroundColor: const Color(0xFFF3EEDF),
            side: const BorderSide(color: Color(0xFFDCCFBA)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            onPressed: () => _handleSend(text),
          );
        },
      ),
    );
  }

  /// Bộ xử lý định dạng văn bản giàu (Rich Text / Markdown)
  /// - Hỗ trợ **in đậm** với màu nhấn
  /// - Hỗ trợ *in nghiêng*
  /// - Giữ nguyên các định dạng xuống dòng \n và khoảng trắng tự nhiên
  Widget _buildRichFormattedText(
    String text, {
    required TextStyle baseStyle,
    Color? boldColor,
  }) {
    final regex = RegExp(r'(\*\*.*?\*\*|\*.*?\*)');
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return Text(text, style: baseStyle);
    }

    final spans = <TextSpan>[];
    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }

      final matchedStr = match.group(0)!;
      if (matchedStr.startsWith('**') && matchedStr.endsWith('**') && matchedStr.length >= 4) {
        spans.add(TextSpan(
          text: matchedStr.substring(2, matchedStr.length - 2),
          style: baseStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: boldColor ?? baseStyle.color,
          ),
        ));
      } else if (matchedStr.startsWith('*') && matchedStr.endsWith('*') && matchedStr.length >= 2) {
        spans.add(TextSpan(
          text: matchedStr.substring(1, matchedStr.length - 1),
          style: baseStyle.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ));
      }

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: baseStyle,
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
    );
  }
}
