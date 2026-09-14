# 🏛️ HistoQuest - Hành Trình Khám Phá Lịch Sử Việt Nam

Ứng dụng di động học tập và thám hiểm lịch sử Việt Nam phong cách Gamification (trò chơi hóa), lấy cảm hứng từ các nền tảng giáo dục tương tác hiện đại.

---

## 🚀 Công Nghệ Sử Dụng

- **Framework**: [Flutter](https://flutter.dev/) (Dart 3)
- **Routing**: `go_router`
- **Kiến trúc**: Feature-First & Clean Architecture
- **Design Language**: Phong cách HistoQuest cổ sử ấm áp (Đất nung `#D95D39`, Đáy 3D `#A53B20`, Giấy cổ `#F7F2E8`, Vàng Hoàng gia `#E4A93A`).

---

## 📦 Tiến Độ Thành Phẩm (Dev B - UI Kit & Data Layer)

### 1. 🎨 Hệ Thống Design Tokens & Theme
- [lib/core/theme/app_colors.dart](lib/core/theme/app_colors.dart): Bảng mã màu chuẩn trích xuất từ thiết kế HistoQuest.

### 2. 🧩 Bộ UI Kit / Reusable Components
Nằm tại thư mục `lib/shared/widgets/`:
- **`PrimaryButton`**: Nút bấm 3D phong cách game với hiệu ứng nén nhấn vật lý 3px, bo góc viên thuốc capsule (99px), viền đáy 5px, hỗ trợ icon và trạng thái Loading.
- **`SecondaryButton`**: Nút bấm viền Outline thanh lịch.
- **`AppCard`**: Thẻ đa năng bo góc 24px, viền đổi màu khi Active/Normal.
- **`StatBadge` & `UserStatsRow`**: Cụm huy hiệu chỉ số gamification (XP ⚡, Xu/Coin 🪙, Chuỗi ngày Streak 🔥, Thời gian ⏱️).
- **`BottomSheetWrapper`**: Khung trượt kéo từ đáy màn hình (Modal Sheet) có tay cầm, nút đóng và nút hành động cố định.
- **`AppModalDialog`**: Hộp thoại popup thông báo / nhận thưởng với icon nổi bật.

### 3. 📚 Tầng Dữ Liệu Giả Lập (Mock Data & Repository)
Nằm tại thư mục `lib/data/`:
- **Models**: `UserModel`, `EraModel`, `HistoricalEventModel`, `HeroCardModel`, `QuizQuestionModel`.
- **Mock Data**: Bộ dữ liệu chuẩn sử Việt Nam (Thời kỳ thế kỷ 10, Sự kiện 938 Bạch Đằng - Ngô Quyền, câu đố trắc nghiệm, thẻ danh tướng).
- **Repository Pattern**: `MockHistoryRepository` mô phỏng độ trễ mạng thực tế, sẵn sàng tích hợp Backend sau này mà không cần sửa code giao diện.

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

### 3. Chạy ứng dụng trên thiết bị / máy ảo
```bash
flutter run
```

---

## 👥 Phân Công Nhóm
- **Dev A**: Bottom Navigation Bar 5 tab, Cấu hình Router / Stack Navigation chính.
- **Dev B**: Design System, UI Kit Reusable Components, Khung Bottom Sheet & Modal Popup, Tầng Mock Data.
