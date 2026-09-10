import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/mancala_engine.dart';

/// Widget hiển thị Bàn cờ Ô Ăn Quan dân gian Việt Nam với 2 ô Quan và 10 ô Dân
class MancalaBoard extends StatelessWidget {
  final List<int> pits;
  final int? selectedPit;
  final bool isPlayerTurn;
  final bool isMoving;
  final Function(int pitIndex) onPitTap;
  final Function(MoveDirection direction) onDirectionSelect;

  const MancalaBoard({
    super.key,
    required this.pits,
    required this.selectedPit,
    required this.isPlayerTurn,
    required this.isMoving,
    required this.onPitTap,
    required this.onDirectionSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // Khung gỗ sơn son mài truyền thống
        color: const Color(0xFF3E2D20),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF5A4332), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x35000000),
            offset: Offset(0, 8),
            blurRadius: 16,
          ),
          BoxShadow(
            color: Color(0xFF22170F),
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Lớp nền bàn cờ cát cổ HistoQuest
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFECE6D8),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFD4CABB), width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. Ô Quan Trái (Index 11) - Hình bán nguyệt mở sang trái
                _buildQuanPit(
                  index: 11,
                  isLeft: true,
                  count: pits[11],
                ),

                const SizedBox(width: 8),

                // 2. Khu vực 10 Ô Dân ở giữa (2 hàng x 5 ô)
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Hàng trên: 5 ô dân của AI (10, 9, 8, 7, 6)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 10; i >= 6; i--)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                child: _buildCivilianPit(
                                  index: i,
                                  count: pits[i],
                                  isAiSide: true,
                                ),
                              ),
                            ),
                        ],
                      ),

                      // Ranh giới trung tuyến giữa 2 hàng quân
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFFC7BCAB).withValues(alpha: 0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Hàng dưới: 5 ô dân của Người chơi (0, 1, 2, 3, 4)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0; i <= 4; i++)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                child: _buildCivilianPit(
                                  index: i,
                                  count: pits[i],
                                  isAiSide: false,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // 3. Ô Quan Phải (Index 5) - Hình bán nguyệt mở sang phải
                _buildQuanPit(
                  index: 5,
                  isLeft: false,
                  count: pits[5],
                ),
              ],
            ),
          ),

          // 4. Nút chọn hướng rải quân (Trái ⟲ / Phải ⟳) khi người chơi đã chọn 1 ô
          if (selectedPit != null && isPlayerTurn && !isMoving)
            _buildDirectionChooserOverlay(),
        ],
      ),
    );
  }

  /// Dựng Ô Quan bán nguyệt (Trái hoặc Phải)
  Widget _buildQuanPit({
    required int index,
    required bool isLeft,
    required int count,
  }) {
    final bool hasLargeQuan = count >= 10;

    return Container(
      width: 58,
      height: 124,
      decoration: BoxDecoration(
        color: const Color(0xFFDFD7C7),
        borderRadius: BorderRadius.only(
          topLeft: isLeft ? const Radius.circular(55) : const Radius.circular(10),
          bottomLeft: isLeft ? const Radius.circular(55) : const Radius.circular(10),
          topRight: !isLeft ? const Radius.circular(55) : const Radius.circular(10),
          bottomRight: !isLeft ? const Radius.circular(55) : const Radius.circular(10),
        ),
        border: Border.all(color: const Color(0xFFC4B8A4), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Hạt Quan lớn & hạt sỏi dân gian bên trong
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (count > 0) ...[
                // Biểu tượng Quan Lớn (Ngọc quý màu vàng hoàng gia)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD54F), Color(0xFFE4A93A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    hasLargeQuan ? Icons.military_tech_rounded : Icons.circle,
                    color: Colors.white,
                    size: hasLargeQuan ? 22 : 14,
                  ),
                ),
                const SizedBox(height: 6),
              ] else ...[
                const Icon(
                  Icons.lens_blur_rounded,
                  color: Color(0xFFB5A998),
                  size: 20,
                ),
                const SizedBox(height: 4),
              ],

              // Badge hiển thị số lượng hạt trong ô Quan
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: count > 0 ? const Color(0xFF4A3728) : const Color(0xFFA69A89),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 2),
              Text(
                isLeft ? 'Quan Tây' : 'Quan Đông',
                style: const TextStyle(
                  color: Color(0xFF7A6B5C),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Dựng Ô Dân (1 trong 10 ô ở giữa)
  Widget _buildCivilianPit({
    required int index,
    required int count,
    required bool isAiSide,
  }) {
    final bool isSelected = selectedPit == index;
    final bool canSelect = isPlayerTurn && !isAiSide && count > 0 && !isMoving;

    return GestureDetector(
      onTap: canSelect ? () => onPitTap(index) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFF0EA)
              : (canSelect ? const Color(0xFFFAF7F2) : const Color(0xFFE4DDD0)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (canSelect ? const Color(0xFFD9B9A3) : const Color(0xFFC7BBAA)),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            else
              const BoxShadow(
                color: Color(0x10000000),
                offset: Offset(0, 2),
                blurRadius: 2,
              ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Các hạt sỏi nhỏ trang trí bên dưới
            if (count > 0) _buildScatteredPebbles(count),

            // Nhãn số lượng hạt to, rõ
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (count > 0 ? const Color(0xFF4A3728) : const Color(0xFFB5A998)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Vẽ các viên sỏi đa sắc nhỏ rải ngẫu nhiên trong ô dân
  Widget _buildScatteredPebbles(int count) {
    const pebbleColors = [
      Color(0xFF2E7D32), // Xanh ngọc bích
      Color(0xFFD95D39), // Đất nung
      Color(0xFFE4A93A), // Vàng cát
      Color(0xFF5D4037), // Nâu sẫm
    ];

    final displayCount = count.clamp(1, 6);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 3,
      runSpacing: 3,
      children: List.generate(displayCount, (i) {
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: pebbleColors[i % pebbleColors.length],
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  /// Nút nổi chọn hướng rải quân (Trái / Phải)
  Widget _buildDirectionChooserOverlay() {
    return Positioned(
      bottom: -16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.gold, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x35000000),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nút rải sang Trái ⟲
            InkWell(
              onTap: () => onDirectionSelect(MoveDirection.left),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.undo_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Rải Trái',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Nút rải sang Phải ⟳
            InkWell(
              onTap: () => onDirectionSelect(MoveDirection.right),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Rải Phải',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.redo_rounded, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
