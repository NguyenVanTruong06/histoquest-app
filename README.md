# 🏛️ HistoQuest - Hành Trình Khám Phá Lịch Sử Việt Nam

Ứng dụng di động học tập và thám hiểm lịch sử Việt Nam phong cách **Gamification** (trò chơi hóa), kết hợp giữa học sử tương tác, mini-games dân gian, trợ lý AI Thư Sinh Ngưu và bản đồ phiêu lưu theo phong cách cổ phong.

---

## 🚀 Công Nghệ & Kiến Trúc Dự Án

- **Framework**: [Flutter](https://flutter.dev/) (Dart 3, null-safety)
- **State Management**: `flutter_riverpod` (Notifier, AsyncNotifier, FutureProviders)
- **Routing**: `go_router` với StatefulShellRoute đa tab
- **Kiến trúc**: Feature-First & Clean Architecture (Data ➔ Domain ➔ Presentation)
- **Design Language**: Phong cách HistoQuest cổ sử ấm áp (Đất nung `#D95D39`, Đáy 3D `#A53B20`, Giấy cổ `#F7F2E8`, Vàng Hoàng gia `#E4A93A`, Ngọc bích `#1F6656`).
- **CI/CD**: GitHub Actions tự động kiểm tra tĩnh (`flutter analyze`) và kiểm thử tự động (`flutter test`).

---

## 🏗️ Cấu Trúc Thư Mục (Feature-First)

```
lib/
├── core/                       # Cấu hình chung, Theme tokens, Utilities
│   ├── config/                 # Feature flags, constants
│   ├── theme/                  # Bảng màu app_colors.dart, Typography
│   └── utils/                  # year_format.dart, helpers
├── data/                       # Tầng Dữ liệu (Clean Architecture)
│   ├── mock/                   # Dữ liệu phân mảnh theo Domain (Mới)
│   │   ├── mock_countries.dart # Quốc gia & điều kiện mở khóa
│   │   ├── mock_eras.dart      # 6 thời kỳ lịch sử & mốc sự kiện
│   │   ├── mock_heroes.dart    # Danh sách thẻ danh tướng
│   │   ├── mock_users.dart     # Hồ sơ người chơi & bảng xếp hạng
│   │   └── mock_news.dart      # Tin tức & Sự kiện tuần
│   ├── mock_data.dart          # Facade điều phối dữ liệu (Tương thích 100%)
│   ├── models/                 # UserModel, EraModel, HistoricalEventModel...
│   └── repositories/           # HistoryRepository & Riverpod Providers
├── features/                   # Các tính năng độc lập (Feature Modules)
│   ├── eras/                   # Bản đồ thời kỳ & Cây đậu thần Beanstalk
│   ├── games/                  # 16 Mini-games & GameEconomyService
│   ├── chatbot/                # Trợ lý lịch sử AI Thư Sinh Ngưu (Bé Sửu)
│   ├── quiz/                   # Màn hình làm bài thi trắc nghiệm & ôn tập
│   ├── ranks/                  # Bảng vàng vinh danh & Hồ sơ sử gia
│   ├── profile/                # Cửa hàng sử quán, tủ đồ & tùy biến avatar
│   ├── social/                 # Bản tin & bài viết di sản lịch sử
│   └── settings/               # Cài đặt hệ thống, âm thanh & đồng bộ
├── router/                     # Cấu hình app_router.dart
└── shared/                     # UI Kit dùng chung (Buttons, Cards, Badges, Sheets)
```

---

## 🌟 Các Cải Tiến Đã Hoàn Thành (Roadmap 5 Giai Đoạn)

### 📍 Giai Đoạn 1: Sửa Lỗi Tức Thời & Chuẩn Hóa Điều Hướng
- ✅ **Dynamic Era Router**: Thay thế hardcode `era_1` bằng điều hướng động `/eras/:eraId` trong `eras_screen.dart`.
- ✅ **Đồng bộ dữ liệu thời kỳ**: Mở ra đầy đủ 6 thời kỳ lịch sử Việt Nam từ Tiền sử đến Đương đại trên Trục Cây Đậu Thần.
- ✅ **Clean Test Warnings**: Xóa bỏ cảnh báo tap trượt màn hình trong `custom_floating_nav_and_settings_test.dart`.

### 📍 Giai Đoạn 2: Tái Cấu Trúc Tầng Dữ Liệu & Riverpod State
- ✅ **Module hóa `mock_data.dart`**: Rút gọn file 113KB (2018 dòng) xuống còn 65 dòng theo mô hình Facade Pattern.
- ✅ **Riverpod Providers**: Tạo `HistoryRepositoryProvider` và `UserProfileNotifier` quản lý số dư Xu, điểm XP, Streak và vật phẩm ngoại trang.

### 📍 Giai Đoạn 3: Tối Ưu Canvas Map & Hiệu Ứng Cổ Phong
- ✅ **Canvas 60–120 FPS**: Bọc `RepaintBoundary` cho `BeanstalkPathwayPainter` và `MapWindingPathPainter`, cô lập layer vẽ giúp cuộn mượt mà.
- ✅ **Haptic Feedback**: Thêm rung xúc giác đa cấp độ (chạm node, cảnh báo mốc khóa, bấm vào trận).

### 📍 Giai Đoạn 4: Hoàn Thiện Game Engine & AI Chatbot Sử Gia
- ✅ **GameEconomyService**: Đồng bộ kinh tế xu/XP thực tế khi người chơi chiến thắng mini-games.
- ✅ **AI Chatbot Sử Gia**: Hoàn thiện luồng trò chuyện với Thư Sinh Ngưu (Bé Sửu) cùng tập tri thức từ `assets/data/chatbot_knowledge.json`.

### 📍 Giai Đoạn 5: CI/CD Pipeline & Bộ Test Suite Độ Phủ Cao
- ✅ **GitHub Actions CI**: Thiết lập workflow tự động kiểm tra code tại `.github/workflows/flutter_ci.yml`.
- ✅ **25/25 Tests Passed**: Đạt 100% test thành công cho Router, Canvas, Game Economy, Chatbot và Repository.

---

## 🛠️ Hướng Dẫn Cài Đặt & Khởi Chạy

### 1. Cài đặt dependencies
```bash
flutter pub get
```

### 2. Kiểm tra chất lượng mã nguồn
```bash
flutter analyze
```

### 3. Chạy toàn bộ 25 bài kiểm thử tự động
```bash
flutter test
```

### 4. Khởi chạy ứng dụng
```bash
flutter run
```

---

## 👥 Phân Công Nhóm
- **Dev A**: Bottom Navigation Bar 5 tab, Shell Navigation.
- **Dev B**: Design Tokens, UI Kit, Data Layer Facade, Riverpod State, Canvas Performance, Mini-Games Engine & AI Chatbot.
