import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/mock_data.dart';
import '../../../data/models/user_model.dart';
import '../../profile/presentation/widgets/histo_profile_header.dart';
import '../../profile/presentation/widgets/profile_customization_shop_sheet.dart';

/// Màn hình Hồ Sơ & Cài Đặt (Profile & Settings Hub) chuẩn phong cách iOS / Clean UI:
/// - Nửa trên: Hero Profile Header sống động, hiển thị Avatar với Khung trang bị lộng lẫy,
///   Ảnh bìa thời đại, Tên sử gia, Level/XP, Ví xu, Chuỗi Streak và 2 nút hành động trực tiếp:
///   [🛒 Cửa Hàng Sử Quán] (dùng Coin mua đồ) & [🎨 Tủ Đồ Trang Phục] (thay đổi diện mạo).
/// - Cụm Quick Action Hub: Nhấn vào Ví Xu, Ngày Streak, Thẻ Tướng đều mở popup chi tiết!
/// - Nửa dưới: Hệ thống Cài Đặt dạng Grouped List bo tròn chuẩn iOS:
///   Nhóm 1: Trải nghiệm học sử (Ngôn ngữ, Âm thanh toggle, Nhắc nhở)
///   Nhóm 2: Dữ liệu & Bộ nhớ (Dọn cache thực tế, Đồng bộ đám mây)
///   Nhóm 3: Đánh giá & Lan tỏa (Interactive 5-Star Rating, Chia sẻ iOS ActionSheet)
///   Nhóm 4: Pháp lý & Phản hồi (Điều khoản, Bảo mật, Form đóng góp sử liệu)
///   Nhóm 5: Hành động tài khoản (Đăng xuất xác nhận 2 bước)
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late UserModel _user;
  bool _isSoundEnabled = true;
  String _selectedLanguage = 'Tiếng Việt';
  String _reminderTime = '20:00';
  double _cacheSizeMb = 24.5;

  @override
  void initState() {
    super.initState();
    _user = MockData.currentUser;
  }

  void _updateUser(UserModel updatedUser) {
    setState(() {
      _user = updatedUser;
      MockData.currentUser = updatedUser;
    });
  }

  void _openShop() {
    ProfileCustomizationShopSheet.show(
      context,
      user: _user,
      onUpdateUser: _updateUser,
    );
  }

  void _openCustomize() {
    ProfileCustomizationShopSheet.show(
      context,
      user: _user,
      onUpdateUser: _updateUser,
    );
  }

  /// Thông báo pop-up nổi bật dùng rootNavigator để không bị che khuất
  void _showSuccessAlert(String message) {
    showCupertinoDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Thông Báo Sử Quán'),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
            child: const Text('Đồng Ý'),
          ),
        ],
      ),
    );
  }

  /// 1. Chọn ngôn ngữ hiển thị
  void _showLanguageDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Chọn ngôn ngữ hiển thị'),
        message: const Text('Thay đổi ngôn ngữ bài học, câu hỏi quiz và giao diện'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _selectedLanguage = 'Tiếng Việt');
              Navigator.of(ctx, rootNavigator: true).pop();
              _showSuccessAlert('Đã thiết lập ngôn ngữ hiển thị: Tiếng Việt (Mặc định).');
            },
            child: const Text('Tiếng Việt (Mặc định)'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _selectedLanguage = 'English');
              Navigator.of(ctx, rootNavigator: true).pop();
              _showSuccessAlert('Language updated: English.');
            },
            child: const Text('English (Tiếng Anh)'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
          child: const Text('Hủy'),
        ),
      ),
    );
  }

  /// 2. Chọn giờ nhắc nhở học sử
  void _showReminderDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Giờ nhắc nhở học sử hàng ngày'),
        message: const Text('Nhận thông báo giữ vững chuỗi Streak lửa thiêng'),
        actions: [
          ('07:30', 'Sáng sớm (Khởi đầu ngày mới)'),
          ('12:15', 'Trưa (Nghỉ ngơi và thư giãn)'),
          ('20:00', 'Tối (Giờ học vàng - Khuyên dùng)'),
          ('21:30', 'Đêm muộn (Trước khi đi ngủ)'),
        ].map((item) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _reminderTime = item.$1);
              Navigator.of(ctx, rootNavigator: true).pop();
              _showSuccessAlert('Đã đặt lịch nhắc nhở học sử lúc ${item.$1} hằng ngày!');
            },
            child: Text('${item.$1} - ${item.$2}'),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
          child: const Text('Đóng'),
        ),
      ),
    );
  }

  /// 3. Dọn dẹp cache
  void _showClearCacheDialog() {
    showCupertinoDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Dọn Dẹp Bộ Nhớ Đệm'),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            _cacheSizeMb > 0
                ? 'Bạn có muốn giải phóng ${_cacheSizeMb.toStringAsFixed(1)} MB ảnh tư liệu và âm thanh tạm thời không? Tiến trình và vật phẩm của bạn không bị ảnh hưởng.'
                : 'Bộ nhớ đệm của ứng dụng hiện tại đã được dọn sạch hoàn toàn (0.0 MB).',
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
            child: const Text('Đóng'),
          ),
          if (_cacheSizeMb > 0)
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(ctx, rootNavigator: true).pop();
                setState(() => _cacheSizeMb = 0.0);
                _showSuccessAlert('Đã dọn dẹp sạch sẽ 24.5 MB bộ nhớ đệm!');
              },
              child: const Text('Dọn Dẹp Ngay'),
            ),
        ],
      ),
    );
  }

  /// 4. Đồng bộ đám mây
  void _showSyncDialog() {
    showCupertinoDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Đồng Bộ Tiến Trình'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Icon(Icons.cloud_done_rounded, color: Color(0xFF1976D2), size: 48),
            SizedBox(height: 12),
            Text(
              'Tiến trình học sử, điểm XP, số xu và vật phẩm của bạn đã được đồng bộ an toàn trên máy chủ HistoQuest!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
            child: const Text('Tuyệt Vời'),
          ),
        ],
      ),
    );
  }

  /// 5. Đánh giá HistoQuest 5 sao tương tác thực tế
  void _showRatingDialog() {
    int selectedStars = 5;

    showCupertinoDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => CupertinoAlertDialog(
          title: const Text('Đánh Giá HistoQuest'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const Text('Bạn đánh giá trải nghiệm khám phá lịch sử thế nào?'),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final star = index + 1;
                  return GestureDetector(
                    onTap: () => setDialogState(() => selectedStars = star),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Icon(
                        star <= selectedStars ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: const Color(0xFFFFA000),
                        size: 34,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              Text(
                selectedStars == 5
                    ? '🌟 Tuyệt vời! Rất yêu lịch sử Việt Nam!'
                    : (selectedStars >= 4 ? '👍 Bài học hay và bổ ích!' : '💡 Cần hoàn thiện thêm'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1976D2)),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
              child: const Text('Để Sau'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(ctx, rootNavigator: true).pop();
                setState(() {
                  _user = _user.copyWith(coins: _user.coins + 20);
                  MockData.currentUser = _user;
                });
                _showSuccessAlert('Cảm ơn bạn đã đánh giá $selectedStars sao! Bạn nhận được +20 Xu thưởng! 🪙');
              },
              child: const Text('Gửi Đánh Giá'),
            ),
          ],
        ),
      ),
    );
  }

  /// 6. Chia sẻ HistoQuest qua ActionSheet
  void _showShareSheet() {
    showCupertinoModalPopup<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Chia Sẻ HistoQuest'),
        message: const Text('Mã giới thiệu của bạn: HQ-VIETNAM (Tặng 50 xu cho bạn bè)'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              _showSuccessAlert('Đã sao chép liên kết tải HistoQuest & Mã mời HQ-VIETNAM vào khay nhớ tạm!');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.copy_rounded, size: 20, color: Color(0xFF1976D2)),
                SizedBox(width: 8),
                Text('Sao Chép Liên Kết & Mã Mời'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              _showSuccessAlert('Đã tạo liên kết chia sẻ lên Facebook thành công!');
            },
            child: const Text('Chia Sẻ Qua Facebook'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              _showSuccessAlert('Đã tạo tin nhắn gửi qua Zalo thành công!');
            },
            child: const Text('Chia Sẻ Qua Zalo'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
          child: const Text('Hủy'),
        ),
      ),
    );
  }

  /// 7. Form gửi phản hồi & đóng góp sử liệu tương tác
  void _showFeedbackDialog() {
    String selectedCategory = 'Góp ý tính năng';
    final textController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Đóng Góp Sử Liệu & Phản Hồi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E242B)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Mọi góp ý của bạn đều giúp HistoQuest chính xác và hấp dẫn hơn mỗi ngày.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                children: ['Báo lỗi kiến thức', 'Góp ý tính năng', 'Đóng góp sử liệu'].map((cat) {
                  final isSelected = selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: const Color(0xFFE8F1FD),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF1976D2) : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      if (val) setModalState(() => selectedCategory = cat);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: textController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Nhập nội dung đóng góp của bạn ở đây...',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
                  filled: true,
                  fillColor: const Color(0xFFF5F7FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    _showSuccessAlert('Cảm ơn bạn! Đóng góp [$selectedCategory] đã được gửi tới Ban Biên Tập Sử Quán.');
                  },
                  child: const Text('Gửi Đóng Góp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 8. Chi tiết Điều khoản & Bảo mật
  void _showInfoSheet(String title, String content) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E242B),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF555E6D),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
                  child: const Text('Đã Hiểu & Đồng Ý', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 9. Đăng xuất
  void _showLogoutDialog() {
    showCupertinoDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Đăng Xuất Tài Khoản'),
        content: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi HistoQuest không? Tiến trình học sử và kho vật phẩm của bạn đã được sao lưu đám mây an toàn.',
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
            child: const Text('Hủy'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              _showSuccessAlert('Đã đăng xuất tài khoản thành công!');
            },
            child: const Text('Đăng Xuất'),
          ),
        ],
      ),
    );
  }

  /// 10. Popup chi tiết Chuỗi Streak
  void _showStreakDialog() {
    showCupertinoDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Chuỗi Streak Lửa Thiêng'),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department_rounded, color: Colors.deepOrange, size: 52),
              const SizedBox(height: 8),
              Text(
                'Bạn đang giữ chuỗi ${_user.streakDays} ngày liên tục!\n\nMỗi ngày hoàn thành ít nhất 1 bài quiz để duy trì ngọn lửa nhiệt huyết và nhận thưởng Xu Sử Quán hấp dẫn.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
            child: const Text('Quyết Tâm Giữ Chuỗi!'),
          ),
        ],
      ),
    );
  }

  /// 11. Popup xem nhanh Bộ Sưu Tập Thẻ Tướng
  void _showHeroCardsDialog() {
    final heroNames = ['Hai Bà Trưng (Khởi Nghĩa)', 'Ngô Quyền (Bạch Đằng)', 'Đinh Bộ Lĩnh (Hoa Lư)', 'Lý Thường Kiệt (Như Nguyệt)', 'Trần Hưng Đạo (Vạn Kiếp)'];

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.style_rounded, color: Color(0xFF1976D2)),
                  SizedBox(width: 8),
                  Text(
                    'Bộ Sưu Tập Thẻ Tướng (5/12)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E242B)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Các danh tướng lịch sử đã mở khóa qua các vòng quiz xuất sắc:',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 14),
              ...heroNames.map((name) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 18),
                    const SizedBox(width: 10),
                    Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E242B))),
                  ],
                ),
              )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
                  child: const Text('Đóng', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF5F7FB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Hồ Sơ & Cài Đặt',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E242B),
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          // ===================================================================
          // 1. HERO PROFILE HEADER (Trang cá nhân, Cửa Hàng & Tùy biến)
          // ===================================================================
          HistoProfileHeader(
            user: _user,
            onOpenShop: _openShop,
            onCustomize: _openCustomize,
          ),

          const SizedBox(height: 16),

          // ===================================================================
          // 2. PHÍM TẮT THÀNH TỰU & TIỀN TỆ NHANH (Quick Action Hub)
          // ===================================================================
          _buildQuickStatHub(),

          const SizedBox(height: 22),

          // TIÊU ĐỀ PHÂN NHÓM
          const Padding(
            padding: EdgeInsets.only(left: 6, bottom: 8),
            child: Text(
              'CÀI ĐẶT HỆ THỐNG',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8B95A5),
                letterSpacing: 0.8,
              ),
            ),
          ),

          // ===================================================================
          // NHÓM 1: TRẢI NGHIỆM HỌC SỬ
          // ===================================================================
          _buildGroupCard(
            children: [
              _buildSettingRow(
                icon: Icons.language_rounded,
                title: 'Ngôn ngữ',
                value: _selectedLanguage,
                onTap: _showLanguageDialog,
              ),
              _buildDivider(),
              _buildSettingRow(
                icon: Icons.volume_up_rounded,
                title: 'Hiệu Ứng Âm Thanh',
                onTap: () {
                  setState(() => _isSoundEnabled = !_isSoundEnabled);
                },
                trailing: CupertinoSwitch(
                  value: _isSoundEnabled,
                  activeTrackColor: const Color(0xFF1976D2),
                  onChanged: (val) {
                    setState(() => _isSoundEnabled = val);
                  },
                ),
              ),
              _buildDivider(),
              _buildSettingRow(
                icon: Icons.notifications_none_rounded,
                title: 'Nhắc nhở hàng ngày',
                value: _reminderTime,
                onTap: _showReminderDialog,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===================================================================
          // NHÓM 2: DỮ LIỆU & BỘ NHỚ
          // ===================================================================
          _buildGroupCard(
            children: [
              _buildSettingRow(
                icon: Icons.cleaning_services_rounded,
                title: 'Dọn dẹp bộ nhớ đệm (Cache)',
                value: _cacheSizeMb > 0 ? '${_cacheSizeMb.toStringAsFixed(1)} MB' : 'Đã sạch',
                onTap: _showClearCacheDialog,
              ),
              _buildDivider(),
              _buildSettingRow(
                icon: Icons.cloud_done_rounded,
                title: 'Đồng bộ tiến trình đám mây',
                value: 'Tự động',
                onTap: _showSyncDialog,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===================================================================
          // NHÓM 3: ĐÁNH GIÁ & CHIA SẺ
          // ===================================================================
          _buildGroupCard(
            children: [
              _buildSettingRow(
                icon: Icons.star_rounded,
                title: 'Đánh giá HistoQuest trên App Store',
                onTap: _showRatingDialog,
              ),
              _buildDivider(),
              _buildSettingRow(
                icon: Icons.ios_share_rounded,
                title: 'Chia sẻ HistoQuest',
                onTap: _showShareSheet,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===================================================================
          // NHÓM 4: PHÁP LÝ & PHẢN HỒI
          // ===================================================================
          _buildGroupCard(
            children: [
              _buildSettingRow(
                icon: Icons.description_outlined,
                title: 'Điều khoản Dịch vụ Sử Quán',
                onTap: () => _showInfoSheet(
                  'Điều khoản Dịch vụ Sử Quán',
                  'Chào mừng bạn đến với HistoQuest! Khi tham gia học tập và trải nghiệm, bạn cam kết tuân thủ quy tắc cộng đồng, tôn trọng bản quyền tư liệu lịch sử và chia sẻ văn minh.',
                ),
              ),
              _buildDivider(),
              _buildSettingRow(
                icon: Icons.shield_outlined,
                title: 'Chính sách Bảo mật',
                onTap: () => _showInfoSheet(
                  'Chính sách Bảo mật',
                  'Dữ liệu điểm kinh nghiệm, số xu và tiến độ học sử được mã hóa và lưu trữ an toàn trên thiết bị của bạn. HistoQuest cam kết bảo vệ thông tin người dùng.',
                ),
              ),
              _buildDivider(),
              _buildSettingRow(
                icon: Icons.mail_outline_rounded,
                title: 'Đóng góp sử liệu & Phản hồi',
                onTap: _showFeedbackDialog,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===================================================================
          // NHÓM 5: HÀNH ĐỘNG TÀI KHOẢN
          // ===================================================================
          _buildGroupCard(
            children: [
              _buildSettingRow(
                icon: Icons.logout_rounded,
                title: 'Đăng xuất',
                isDestructive: true,
                onTap: _showLogoutDialog,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ===================================================================
          // DÒNG THÔNG TIN PHIÊN BẢN CHỮ NHỎ CĂN GIỮA
          // ===================================================================
          const Center(
            child: Text(
              'HistoQuest 1.0.0 (168) ❤️ HistoQuest Team',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9EA5B3),
                letterSpacing: 0.1,
              ),
            ),
          ),

          // Khoảng trống đệm đáy để cuộn vượt lên trên thanh Dock nổi
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildQuickStatHub() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickStatItem(
            icon: Icons.monetization_on_rounded,
            iconColor: const Color(0xFFF9A825),
            value: '${_user.coins}',
            label: 'Xu Sử Quán',
            onTap: _openShop,
          ),
          Container(width: 1, height: 32, color: const Color(0xFFEFF2F7)),
          _buildQuickStatItem(
            icon: Icons.local_fire_department_rounded,
            iconColor: Colors.deepOrange,
            value: '${_user.streakDays}',
            label: 'Ngày Streak',
            onTap: _showStreakDialog,
          ),
          Container(width: 1, height: 32, color: const Color(0xFFEFF2F7)),
          _buildQuickStatItem(
            icon: Icons.style_rounded,
            iconColor: const Color(0xFF1976D2),
            value: '5/12',
            label: 'Thẻ Tướng',
            onTap: _showHeroCardsDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E242B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8B95A5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.7,
      indent: 58,
      color: Color(0xFFF1F3F7),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    String? value,
    Widget? trailing,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final iconBgColor = isDestructive ? const Color(0xFFFDEEE9) : const Color(0xFFE8F1FD);
    final iconColor = isDestructive ? const Color(0xFFE53935) : const Color(0xFF1976D2);
    final textColor = isDestructive ? const Color(0xFFE53935) : const Color(0xFF1E242B);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              // Icon tròn bo mềm
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 20,
                    color: iconColor,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Tiêu đề
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isDestructive ? FontWeight.w700 : FontWeight.w600,
                    color: textColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ),

              // Giá trị text bên phải nếu có
              if (value != null) ...[
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8B95A5),
                  ),
                ),
                const SizedBox(width: 4),
              ],

              // Trailing widget (Switch hoặc mũi tên >)
              if (trailing != null)
                trailing
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDestructive ? const Color(0xFFE53935) : const Color(0xFFB5BDC9),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
