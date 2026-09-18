import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';

enum SettingsRowType { navigation, toggle, action, destructive }

class SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final String? valueText;
  final SettingsRowType type;
  final bool toggleValue;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.valueText,
    this.type = SettingsRowType.navigation,
    this.toggleValue = false,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDestructive = type == SettingsRowType.destructive;
    final itemColor = isDestructive ? AppColors.danger : AppColors.textPrimary;

    return InkWell(
      onTap: type == SettingsRowType.toggle ? () => onToggle?.call(!toggleValue) : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (iconColor ?? itemColor).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor ?? itemColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: itemColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            if (valueText != null)
              Text(
                valueText!,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            if (type == SettingsRowType.navigation)
              const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondary),
            if (type == SettingsRowType.toggle)
              Switch.adaptive(
                value: toggleValue,
                activeTrackColor: AppColors.primary,
                onChanged: onToggle,
              ),
          ],
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String? title;
  final List<SettingsRow> children;

  const SettingsSection({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
            child: Text(
              title!.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: children.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              indent: 64,
              endIndent: 16,
              color: AppColors.cardBorder.withValues(alpha: 0.5),
            ),
            itemBuilder: (_, index) => children[index],
          ),
        ),
      ],
    );
  }
}

class SettingsModalSheet extends StatefulWidget {
  const SettingsModalSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SettingsModalSheet(),
    );
  }

  @override
  State<SettingsModalSheet> createState() => _SettingsModalSheetState();
}

class _SettingsModalSheetState extends State<SettingsModalSheet> {
  bool _streakReminder = true;
  bool _soundAndHaptics = true;
  bool _darkMode = false;
  double _cacheSizeMb = 24.5;

  void _clearCache() {
    setState(() {
      _cacheSizeMb = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🧹 Đã giải phóng 24.5 MB bộ nhớ đệm thành công!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogoutConfirm() {
    AppModalDialog.show(
      context,
      title: 'Đăng xuất tài khoản',
      message: 'Bạn có chắc chắn muốn đăng xuất khỏi phiên làm việc hiện tại không?',
      confirmText: 'Đăng xuất',
      type: DialogType.danger,
      onConfirm: () {
        Navigator.pop(context); // Close dialog
        Navigator.pop(context); // Close sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã đăng xuất tài khoản thành công.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  void _showAboutDialog() {
    AppModalDialog.show(
      context,
      title: 'HistoQuest v1.0.0',
      message: 'Ứng dụng học sử và giải đố lịch sử Việt Nam.\n\nSứ mệnh truyền tải tình yêu lịch sử hào hùng qua trải nghiệm trò chơi hóa (gamification) sống động và cuốn hút.',
      confirmText: 'Đóng',
      type: DialogType.info,
      onConfirm: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.settings_outlined, color: AppColors.textPrimary, size: 22),
                SizedBox(width: 8),
                Text(
                  'Cài Đặt Ứng Dụng',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.cardBorder),

          // Settings List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                // 1. TÀI KHOẢN & BẢO MẬT
                SettingsSection(
                  title: 'Tài Khoản & Bảo Mật',
                  children: [
                    SettingsRow(
                      icon: Icons.person_outline_rounded,
                      title: 'Thông tin cá nhân',
                      subtitle: 'Đổi họ tên, biệt hiệu trong game',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tính năng cập nhật thông tin đang hoàn thiện.')),
                        );
                      },
                    ),
                    SettingsRow(
                      icon: Icons.lock_outline_rounded,
                      title: 'Mật khẩu & Đăng nhập',
                      onTap: () {},
                    ),
                    SettingsRow(
                      icon: Icons.link_rounded,
                      title: 'Liên kết mạng xã hội',
                      valueText: 'Google, Apple',
                      onTap: () {},
                    ),
                  ],
                ),

                // 2. TRẢI NGHIỆM & THÔNG BÁO
                SettingsSection(
                  title: 'Trải Nghiệm & Tương Tác',
                  children: [
                    SettingsRow(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: Colors.deepOrange,
                      title: 'Nhắc giữ chuỗi Streak',
                      subtitle: 'Nhắc nhở lúc 20:00 hằng ngày nếu chưa học',
                      type: SettingsRowType.toggle,
                      toggleValue: _streakReminder,
                      onToggle: (val) => setState(() => _streakReminder = val),
                    ),
                    SettingsRow(
                      icon: Icons.volume_up_rounded,
                      iconColor: Colors.blueAccent,
                      title: 'Âm thanh & Rung phản hồi',
                      subtitle: 'Âm thanh quiz và phản hồi chạm haptic',
                      type: SettingsRowType.toggle,
                      toggleValue: _soundAndHaptics,
                      onToggle: (val) => setState(() => _soundAndHaptics = val),
                    ),
                    SettingsRow(
                      icon: Icons.dark_mode_outlined,
                      title: 'Giao diện đêm (Dark Mode)',
                      type: SettingsRowType.toggle,
                      toggleValue: _darkMode,
                      onToggle: (val) => setState(() => _darkMode = val),
                    ),
                  ],
                ),

                // 3. DỮ LIỆU & BỘ NHỚ
                SettingsSection(
                  title: 'Dữ Liệu & Bộ Nhớ',
                  children: [
                    SettingsRow(
                      icon: Icons.cleaning_services_rounded,
                      iconColor: AppColors.gold,
                      title: 'Dọn dẹp bộ nhớ đệm (Cache)',
                      valueText: _cacheSizeMb > 0 ? '${_cacheSizeMb.toStringAsFixed(1)} MB' : 'Đã dọn sạch',
                      onTap: _clearCache,
                    ),
                    SettingsRow(
                      icon: Icons.sync_rounded,
                      title: 'Đồng bộ tiến trình đám mây',
                      valueText: 'Vừa xong',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tiến trình đã được đồng bộ đầy đủ!')),
                        );
                      },
                    ),
                  ],
                ),

                // 4. HỖ TRỢ & THÔNG TIN
                SettingsSection(
                  title: 'Hỗ Trợ & Sử Liệu',
                  children: [
                    SettingsRow(
                      icon: Icons.info_outline_rounded,
                      title: 'Giới thiệu HistoQuest',
                      valueText: 'v1.0.0',
                      onTap: _showAboutDialog,
                    ),
                    SettingsRow(
                      icon: Icons.menu_book_rounded,
                      title: 'Nguồn tư liệu & Ban cố vấn sử học',
                      onTap: () {},
                    ),
                    SettingsRow(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Chính sách quyền riêng tư',
                      onTap: () {},
                    ),
                  ],
                ),

                // 5. VÙNG NGUY HIỂM
                SettingsSection(
                  title: 'Vùng Nguy Hiểm',
                  children: [
                    SettingsRow(
                      icon: Icons.logout_rounded,
                      title: 'Đăng xuất tài khoản',
                      type: SettingsRowType.destructive,
                      onTap: _showLogoutConfirm,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
