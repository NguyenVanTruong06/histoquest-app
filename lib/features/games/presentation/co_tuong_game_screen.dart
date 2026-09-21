import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class CoTuongGameScreen extends StatefulWidget {
  const CoTuongGameScreen({super.key});

  @override
  State<CoTuongGameScreen> createState() => _CoTuongGameScreenState();
}

class _CoTuongGameScreenState extends State<CoTuongGameScreen> {
  // Puzzle: Red Chariot (Xe Đỏ) starts at [4, 2]. Target checkmate position: [0, 2].
  bool _isCheckmate = false;

  void _onPieceMoved() {
    setState(() {
      _isCheckmate = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF7F2),
        title: Text(
          'Chiếu Tướng!',
          textAlign: TextAlign.center,
          style: GoogleFonts.philosopher(color: Colors.red.shade800, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Tuyệt kỹ cờ thế! Bạn đã đi nước cờ quyết định chiếu bí tướng địch. Ván cờ kết thúc.',
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
              child: const Text('Rời Bàn Cờ', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7CCC8), // Nền gỗ sáng
      appBar: AppBar(
        backgroundColor: const Color(0xFF5D4037),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'CỜ THẾ: CHIẾU BÍ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              color: const Color(0xFF4E342E),
              width: double.infinity,
              child: const Text(
                'Kéo quân XE ĐỎ tiến lên chiếu bí Tướng Đen!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            
            Expanded(
              child: Center(
                child: Container(
                  width: 320,
                  height: 380,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCC80), // Màu bàn cờ gỗ
                    border: Border.all(color: const Color(0xFF5D4037), width: 4),
                  ),
                  child: Stack(
                    children: [
                      // Kẻ sọc bàn cờ (Grid đơn giản 5x6 cho cờ thế)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: BoardPainter(),
                        ),
                      ),
                      
                      // Tướng Đen (Đứng im ở trên cùng giữa)
                      const Positioned(
                        left: 130, // Cột giữa
                        top: 20,  // Hàng 0
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFFEFEBE9),
                          child: Text('將', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      
                      // Vị trí mục tiêu (Đích đến để chiếu bí)
                      Positioned(
                        left: 130,
                        top: 80, // Hàng 1 (Ngay dưới Tướng)
                        child: DragTarget<String>(
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: candidateData.isNotEmpty ? Colors.green.withValues(alpha: 0.3) : Colors.transparent,
                                border: candidateData.isNotEmpty ? Border.all(color: Colors.green, width: 2) : null,
                              ),
                            );
                          },
                          onAcceptWithDetails: (details) {
                            _onPieceMoved();
                          },
                        ),
                      ),
                      
                      // Quân Xe Đỏ (Draggable)
                      if (!_isCheckmate)
                        Positioned(
                          left: 130, // Cột giữa
                          bottom: 20, // Hàng cuối
                          child: Draggable<String>(
                            data: 'xe_do',
                            feedback: const CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFEFEBE9),
                              child: Text('車', style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold)),
                            ),
                            childWhenDragging: const Opacity(
                              opacity: 0.3,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xFFEFEBE9),
                                child: Text('車', style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFEFEBE9),
                              child: Text('車', style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        
                      // Nếu đã di chuyển thành công
                      if (_isCheckmate)
                        const Positioned(
                          left: 130,
                          top: 80, // Vị trí chiếu
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xFFEFEBE9),
                            child: Text('車', style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 2.0;

    // Vẽ dọc (5 cột)
    double colWidth = size.width / 4;
    for (int i = 0; i <= 4; i++) {
      canvas.drawLine(Offset(colWidth * i, 0), Offset(colWidth * i, size.height), paint);
    }
    
    // Vẽ ngang (6 hàng)
    double rowHeight = size.height / 5;
    for (int i = 0; i <= 5; i++) {
      canvas.drawLine(Offset(0, rowHeight * i), Offset(size.width, rowHeight * i), paint);
    }
    
    // Vẽ chéo cung tướng (Đen)
    canvas.drawLine(Offset(colWidth * 1, 0), Offset(colWidth * 3, rowHeight * 2), paint);
    canvas.drawLine(Offset(colWidth * 3, 0), Offset(colWidth * 1, rowHeight * 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
