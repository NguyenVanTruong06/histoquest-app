import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class NemConGameScreen extends StatefulWidget {
  const NemConGameScreen({super.key});

  @override
  State<NemConGameScreen> createState() => _NemConGameScreenState();
}

class _NemConGameScreenState extends State<NemConGameScreen> {
  // Tọa độ gốc của quả còn (Bottom Left)
  final Offset _startPos = const Offset(0.2, 0.8);
  
  // Tọa độ hiện tại của quả còn
  Offset _currentPos = const Offset(0.2, 0.8);
  
  // Trạng thái kéo
  bool _isDragging = false;
  
  // Vị trí mục tiêu (Vòng tròn trên cây nêu)
  final Offset _targetPos = const Offset(0.8, 0.2);
  
  bool _isFlying = false;
  Timer? _flyTimer;

  void _onPanStart(DragStartDetails details, Size size) {
    if (_isFlying) return;
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    if (_isFlying || !_isDragging) return;
    
    // Giới hạn vùng kéo (chỉ kéo xuống dưới và sang trái)
    double newX = details.localPosition.dx / size.width;
    double newY = details.localPosition.dy / size.height;
    
    // Giới hạn max kéo đà
    if (newX > 0.4) newX = 0.4;
    if (newY < 0.6) newY = 0.6;
    if (newX < 0.05) newX = 0.05;
    if (newY > 0.95) newY = 0.95;

    setState(() {
      _currentPos = Offset(newX, newY);
    });
  }

  void _onPanEnd(DragEndDetails details, Size size) {
    if (_isFlying || !_isDragging) return;
    setState(() {
      _isDragging = false;
      _isFlying = true;
    });
    
    // Tính vector ném (từ current tới start)
    double dx = _startPos.dx - _currentPos.dx;
    double dy = _startPos.dy - _currentPos.dy;
    
    // Hệ số nhân lực ném
    double force = 2.5; 
    
    double velocityX = dx * force;
    double velocityY = dy * force;
    
    // Gravity effect
    double gravity = 0.005;
    
    _flyTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _currentPos = Offset(_currentPos.dx + velocityX, _currentPos.dy + velocityY);
        velocityY += gravity; // Rơi dần
        
        // Kiểm tra va chạm mục tiêu
        double distToTarget = sqrt(pow(_currentPos.dx - _targetPos.dx, 2) + pow(_currentPos.dy - _targetPos.dy, 2));
        if (distToTarget < 0.1) {
          timer.cancel();
          _showVictoryDialog(true);
        }
        
        // Rơi ra ngoài màn hình
        else if (_currentPos.dy > 1.2 || _currentPos.dx > 1.2 || _currentPos.dx < -0.2) {
          timer.cancel();
          _showVictoryDialog(false);
        }
      });
    });
  }

  void _showVictoryDialog(bool isWin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF7F2),
        title: Text(
          isWin ? 'Trúng Đích!' : 'Trượt Rồi!',
          textAlign: TextAlign.center,
          style: GoogleFonts.philosopher(
            color: isWin ? Colors.green.shade800 : AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          isWin 
              ? 'Tuyệt vời! Quả còn ngũ sắc đã bay lọt qua mặt trời trên ngọn cây nêu. Cầu chúc một năm mùa màng bội thu!'
              : 'Hãy canh lực và hướng gió cẩn thận hơn để ném trúng mục tiêu nhé.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _currentPos = _startPos;
                      _isFlying = false;
                      _isDragging = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Ném Lại', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Thoát', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _flyTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE), // Bầu trời mây xuân
      appBar: AppBar(
        backgroundColor: const Color(0xFF0277BD),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'LỄ HỘI NÉM CÓ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: const Color(0xFF01579B),
              child: const Text(
                'KÉO quả còn NGƯỢC VỀ PHÍA SAU để lấy đà và thả tay!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // Nền đồi cỏ
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: constraints.maxHeight * 0.3,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF689F38), // Đồi cỏ xuân
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(200),
                              topRight: Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      
                      // Cây Nêu và Vòng Tròn
                      Positioned(
                        left: constraints.maxWidth * _targetPos.dx,
                        top: constraints.maxHeight * _targetPos.dy,
                        child: Column(
                          children: [
                            // Vòng tròn mặt trời
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.red, width: 6), // Vòng mặt trời
                              ),
                              child: Center(
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.yellow,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            // Thân cây nêu (kéo dài xuống đáy)
                            Container(
                              width: 8,
                              height: constraints.maxHeight * (1 - _targetPos.dy),
                              color: Colors.brown.shade800,
                            ),
                          ],
                        ),
                      ),
                      
                      // Tia laser canh lực (Chỉ hiện khi đang kéo)
                      if (_isDragging && !_isFlying)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: TrajectoryPainter(
                              startPos: Offset(constraints.maxWidth * _startPos.dx + 20, constraints.maxHeight * _startPos.dy + 20),
                              dragPos: Offset(constraints.maxWidth * _currentPos.dx + 20, constraints.maxHeight * _currentPos.dy + 20),
                            ),
                          ),
                        ),
                      
                      // Quả Còn Ngũ Sắc
                      Positioned(
                        left: constraints.maxWidth * _currentPos.dx,
                        top: constraints.maxHeight * _currentPos.dy,
                        child: GestureDetector(
                          onPanStart: (details) => _onPanStart(details, constraints.biggest),
                          onPanUpdate: (details) => _onPanUpdate(details, constraints.biggest),
                          onPanEnd: (details) => _onPanEnd(details, constraints.biggest),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red, // Quả còn
                              border: Border.all(color: Colors.yellow, width: 2),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
                            ),
                            child: const Center(
                              child: Icon(Icons.star, color: Colors.yellow, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrajectoryPainter extends CustomPainter {
  final Offset startPos;
  final Offset dragPos;

  TrajectoryPainter({required this.startPos, required this.dragPos});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Vector lực
    double dx = startPos.dx - dragPos.dx;
    double dy = startPos.dy - dragPos.dy;

    // Vẽ đường nét đứt dự đoán
    Path path = Path();
    path.moveTo(startPos.dx, startPos.dy);
    path.lineTo(startPos.dx + dx * 2, startPos.dy + dy * 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
