import 'package:flutter/material.dart';
import '../../../../data/models/era_model.dart';

/// Header tối giản cho Màn hình Bản đồ Sự kiện: chỉ có nút quay lại và tên
/// thời kỳ, cùng màu giấy với nền bản đồ.
///
/// Các tham số thống kê (xu, streak, tiến độ...) vẫn được giữ trong constructor
/// để tương thích với nơi gọi, nhưng không còn hiển thị.
class EraMapHeader extends StatelessWidget {
  final EraModel era;
  final int completedCount;
  final int totalCount;
  final int userXp;
  final int userCoins;
  final int streakDays;
  final VoidCallback onBack;

  /// Khoảng đệm phía trên để tránh camera / tai thỏ.
  final double topInset;

  const EraMapHeader({
    super.key,
    required this.era,
    required this.completedCount,
    required this.totalCount,
    required this.userXp,
    required this.userCoins,
    required this.streakDays,
    required this.onBack,
    this.topInset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14, 6 + topInset, 14, 6),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B2A18).withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF3B2A18).withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF3B2A18),
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              era.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF3B2A18),
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
