/// Cấu hình quản lý cờ tính năng (Feature Flags) cho HistoQuest.
/// 
/// Dùng để bật / tắt nhanh các tính năng đang thử nghiệm hoặc dự kiến ra mắt
/// mà không làm ảnh hưởng đến mã nguồn và cấu trúc giao diện chính.
class FeatureFlags {
  FeatureFlags._();

  // ===========================================================================
  // 🌟 AI HISTORICAL COMPANION (CHATBOT BÉ SỬU / VĂN MIẾU THƯ SINH NGƯU)
  // ===========================================================================
  // 
  // 1. CỜ BẬT / TẮT HIỂN THỊ CHATBOT TRÊN APP:
  // - Khi `true`: Hiển thị icon chatbot tròn nổi ngay phía trên nút Cài đặt.
  //               Mở màn hình đàm thoại tương tác với Văn Miếu Thư Sinh Ngưu.
  // - Khi `false`: ẨN HOÀN TOÀN icon chatbot khỏi ứng dụng (thời gian đầu chưa
  //                phát hành hoặc khi chưa đủ kinh phí vận hành).
  //
  // 👉 Đổi thành `false` để ẩn, hoặc `true` để hiện:
  static const bool enableAiChatbot = true;

  // 2. KINH PHÍ & GOOGLE GEMINI API KEY:
  // - Mặc định để rỗng `""`: Hệ thống tự động kích hoạt "Offline Smart AI Engine"
  //   miễn phí 100%, không tốn xu nào mà vẫn trả lời câu hỏi lịch sử thông minh!
  // - Khi nào có kinh phí đăng ký API: Điền API key vào đây để mở rộng kết nối Cloud AI.
  static const String geminiApiKey = "";
}

