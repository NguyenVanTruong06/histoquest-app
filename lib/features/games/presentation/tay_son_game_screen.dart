import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class TaySonGameScreen extends StatefulWidget {
  const TaySonGameScreen({super.key});

  @override
  State<TaySonGameScreen> createState() => _TaySonGameScreenState();
}

class _TaySonGameScreenState extends State<TaySonGameScreen> {
  // Tọa độ người chơi (0.0 đến 1.0)
  double _playerX = 0.5;
  
  // Đạn người chơi
  final List<Offset> _bullets = [];
  
  // Kẻ địch
  final List<Offset> _enemies = [];
  
  Timer? _gameLoop;
  int _score = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _gameLoop = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_isGameOver) return;
      
      setState(() {
        // Cập nhật vị trí đạn bay lên
        for (int i = _bullets.length - 1; i >= 0; i--) {
          _bullets[i] = Offset(_bullets[i].dx, _bullets[i].dy - 0.05);
          if (_bullets[i].dy < 0) {
            _bullets.removeAt(i); // Đạn ra khỏi màn hình
          }
        }
        
        // Sinh kẻ địch ngẫu nhiên
        if (_enemies.length < 3 && DateTime.now().millisecond % 50 == 0) {
          _enemies.add(Offset(0.1 + (DateTime.now().millisecond % 8) / 10.0, 0.0));
        }

        // Cập nhật vị trí kẻ địch bay xuống
        for (int i = _enemies.length - 1; i >= 0; i--) {
          _enemies[i] = Offset(_enemies[i].dx, _enemies[i].dy + 0.01);
          
          // Kiểm tra va chạm đạn
          for (int j = _bullets.length - 1; j >= 0; j--) {
            if ((_bullets[j].dx - _enemies[i].dx).abs() < 0.1 &&
                (_bullets[j].dy - _enemies[i].dy).abs() < 0.1) {
              // Bắn trúng
              _bullets.removeAt(j);
              _enemies.removeAt(i);
              _score++;
              
              if (_score >= 5) {
                _endGame(true);
              }
              break; // Đạn chạm một địch là mất
            }
          }
          
          // Kiểm tra địch lọt qua (không quan trọng trong mock, nhưng có thể cho thua)
          if (i < _enemies.length && _enemies[i].dy > 1.0) {
            _enemies.removeAt(i);
          }
        }
      });
    });
  }

  void _shoot() {
    if (_isGameOver) return;
    setState(() {
      _bullets.add(Offset(_playerX, 0.8)); // Bắn từ vị trí hiện tại
    });
  }

  void _endGame(bool isWin) {
    _gameLoop?.cancel();
    setState(() {
      _isGameOver = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF7F2),
        title: Text(
          isWin ? 'Toàn Thắng!' : 'Thất Bại!',
          textAlign: TextAlign.center,
          style: GoogleFonts.philosopher(
            color: isWin ? Colors.green.shade800 : AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          isWin 
              ? 'Chiến thuyền Tây Sơn đã tiêu diệt hạm đội địch. Thủy chiến Rạch Gầm - Xoài Mút thắng lợi rực rỡ!'
              : 'Chiến thuyền của ngài đã bị bao vây.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
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
  void dispose() {
    _gameLoop?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // Màu nước biển
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF002171),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'THUYỀN RỒNG TÂY SƠN',
                    style: GoogleFonts.philosopher(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Diệt: $_score/5', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            
            // Khu vực chơi
            Expanded(
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _playerX += details.delta.dx / MediaQuery.of(context).size.width;
                    _playerX = _playerX.clamp(0.05, 0.95);
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage('https://www.transparenttextures.com/patterns/waves.png'),
                      repeat: ImageRepeat.repeat,
                      opacity: 0.3,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Kẻ địch
                      ..._enemies.map((enemy) => Positioned(
                        left: MediaQuery.of(context).size.width * enemy.dx - 25,
                        top: MediaQuery.of(context).size.height * 0.7 * enemy.dy,
                        child: const Icon(Icons.directions_boat_rounded, color: Colors.black, size: 50),
                      )),
                      
                      // Đạn
                      ..._bullets.map((bullet) => Positioned(
                        left: MediaQuery.of(context).size.width * bullet.dx - 10,
                        top: MediaQuery.of(context).size.height * 0.7 * bullet.dy,
                        child: const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 30),
                      )),
                      
                      // Thuyền người chơi
                      Positioned(
                        left: MediaQuery.of(context).size.width * _playerX - 35,
                        bottom: 40,
                        child: Column(
                          children: [
                            const Text('Tây Sơn', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
                            Icon(Icons.sailing_rounded, color: Colors.yellow.shade700, size: 70),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bảng điều khiển
            Container(
              height: 100,
              color: const Color(0xFF002171),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Vuốt trên màn hình để di chuyển',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                  FloatingActionButton.large(
                    onPressed: _shoot,
                    backgroundColor: Colors.red.shade700,
                    child: const Icon(Icons.my_location_rounded, color: Colors.white, size: 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
