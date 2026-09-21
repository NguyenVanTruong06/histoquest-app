import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class ThanhTriGameScreen extends StatefulWidget {
  const ThanhTriGameScreen({super.key});

  @override
  State<ThanhTriGameScreen> createState() => _ThanhTriGameScreenState();
}

class _ThanhTriGameScreenState extends State<ThanhTriGameScreen> {
  // 3 vị trí đặt quân trên thành (true = đã đặt)
  final List<bool> _slots = [false, false, false];
  int _archersToPlace = 3;

  void _onArcherPlaced(int index) {
    if (!_slots[index]) {
      setState(() {
        _slots[index] = true;
        _archersToPlace--;
      });

      if (_archersToPlace == 0) {
        _showVictoryDialog();
      }
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF7F2),
        title: Text(
          'Phòng Thủ Thành Công!',
          textAlign: TextAlign.center,
          style: GoogleFonts.philosopher(color: Colors.green.shade800, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Đội hình phòng thủ đã được thiết lập hoàn hảo. Quân giặc không thể tiến bước!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Rút Quân', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4E342E), // Nền đất chiến trường
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'BẢO VỆ THÀNH CỔ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Cảnh báo địch tiến công
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.red.shade900.withValues(alpha: 0.8),
              width: double.infinity,
              child: const Text(
                'KÉO THẢ CUNG THỦ LÊN MẶT THÀNH ĐỂ PHÒNG THỦ!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
            
            Expanded(
              child: Stack(
                children: [
                  // Làn sóng địch (Giả lập)
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        3, 
                        (index) => Column(
                          children: [
                            const Icon(Icons.arrow_downward_rounded, color: Colors.redAccent),
                            const SizedBox(height: 8),
                            Icon(Icons.person_pin_circle_rounded, size: 40, color: Colors.grey.shade400),
                          ],
                        )
                      ),
                    ),
                  ),
                  
                  // Bức tường thành
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 250,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.brown.shade700,
                        border: const Border(top: BorderSide(color: Colors.black45, width: 8)),
                      ),
                      child: Column(
                        children: [
                          // Mặt thành (Các ô đặt quân)
                          Container(
                            height: 100,
                            color: Colors.brown.shade600,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(3, (index) {
                                return DragTarget<String>(
                                  builder: (context, candidateData, rejectedData) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: _slots[index] ? Colors.green.withValues(alpha: 0.3) : Colors.black26,
                                        border: Border.all(
                                          color: candidateData.isNotEmpty ? Colors.yellow : Colors.white30,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: _slots[index]
                                            ? const Icon(Icons.sports_martial_arts_rounded, color: Colors.greenAccent, size: 50)
                                            : const Icon(Icons.add_rounded, color: Colors.white30, size: 30),
                                      ),
                                    );
                                  },
                                  onAcceptWithDetails: (details) {
                                    _onArcherPlaced(index);
                                  },
                                );
                              }),
                            ),
                          ),
                          // Thân thành
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.castle_rounded, size: 100, color: Colors.brown.shade900),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Thanh công cụ kéo thả quân
            Container(
              height: 120,
              color: const Color(0xFF2E1503),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Cung Thủ Còn Lại: $_archersToPlace', style: const TextStyle(color: Colors.white, fontSize: 16)),
                        const Text('Kéo biểu tượng bên phải lên mặt thành', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
                  if (_archersToPlace > 0)
                    Draggable<String>(
                      data: 'archer',
                      feedback: const Icon(Icons.sports_martial_arts_rounded, color: Colors.yellow, size: 60),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: _buildArcherIcon(),
                      ),
                      child: _buildArcherIcon(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArcherIcon() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.brown.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold, width: 2),
      ),
      child: const Center(
        child: Icon(Icons.sports_martial_arts_rounded, color: Colors.white, size: 40),
      ),
    );
  }
}
