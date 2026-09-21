import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class RongRanGameScreen extends StatefulWidget {
  const RongRanGameScreen({super.key});

  @override
  State<RongRanGameScreen> createState() => _RongRanGameScreenState();
}

class _RongRanGameScreenState extends State<RongRanGameScreen> {
  final int _squaresPerRow = 15;
  final int _squaresPerCol = 15;
  
  List<int> _snake = [45, 44, 43];
  int _food = 100;
  String _direction = 'down';
  bool _isPlaying = false;
  Timer? _timer;
  int _score = 0;

  void _startGame() {
    setState(() {
      _snake = [45, 44, 43];
      _direction = 'right';
      _score = 0;
      _isPlaying = true;
      _generateFood();
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (Timer timer) {
      _updateSnake();
      if (_checkGameOver()) {
        timer.cancel();
        _showGameOverDialog(false);
      }
    });
  }

  void _generateFood() {
    _food = Random().nextInt(_squaresPerRow * _squaresPerCol);
    while (_snake.contains(_food)) {
      _food = Random().nextInt(_squaresPerRow * _squaresPerCol);
    }
  }

  void _updateSnake() {
    setState(() {
      switch (_direction) {
        case 'down':
          if (_snake.first + _squaresPerRow >= _squaresPerRow * _squaresPerCol) {
            _snake.insert(0, _snake.first + _squaresPerRow - _squaresPerRow * _squaresPerCol);
          } else {
            _snake.insert(0, _snake.first + _squaresPerRow);
          }
          break;
        case 'up':
          if (_snake.first - _squaresPerRow < 0) {
            _snake.insert(0, _snake.first - _squaresPerRow + _squaresPerRow * _squaresPerCol);
          } else {
            _snake.insert(0, _snake.first - _squaresPerRow);
          }
          break;
        case 'right':
          if ((_snake.first + 1) % _squaresPerRow == 0) {
            _snake.insert(0, _snake.first + 1 - _squaresPerRow);
          } else {
            _snake.insert(0, _snake.first + 1);
          }
          break;
        case 'left':
          if (_snake.first % _squaresPerRow == 0) {
            _snake.insert(0, _snake.first - 1 + _squaresPerRow);
          } else {
            _snake.insert(0, _snake.first - 1);
          }
          break;
      }

      if (_snake.first == _food) {
        _score++;
        if (_score >= 5) {
          _timer?.cancel();
          _showGameOverDialog(true);
        } else {
          _generateFood();
        }
      } else {
        _snake.removeLast();
      }
    });
  }

  bool _checkGameOver() {
    // Tự cắn đuôi
    for (int i = 1; i < _snake.length; ++i) {
      if (_snake[i] == _snake[0]) {
        return true;
      }
    }
    return false;
  }

  void _showGameOverDialog(bool isWin) {
    setState(() {
      _isPlaying = false;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFAF7F2),
          title: Text(
            isWin ? 'Tuyệt Vời!' : 'Thầy Thuốc Bắt Được Rồi!',
            textAlign: TextAlign.center,
            style: GoogleFonts.philosopher(
              color: isWin ? Colors.green.shade800 : AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            isWin 
                ? 'Đoàn rồng rắn đã thu thập đủ 5 quả thị mà an toàn!' 
                : 'Thân rồng rắn đã bị đứt khúc.',
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _startGame();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Chơi Lại', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('Thoát', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Xanh nhạt
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'RỒNG RẮN LÊN MÂY',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1B5E20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mục tiêu: $_score/5 Quả Thị', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  if (!_isPlaying)
                    ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('BẮT ĐẦU', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
            
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8E6C9),
                      border: Border.all(color: const Color(0xFF81C784), width: 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _squaresPerRow * _squaresPerCol,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _squaresPerRow),
                      itemBuilder: (BuildContext context, int index) {
                        if (_snake.contains(index)) {
                          bool isHead = index == _snake.first;
                          return Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: isHead ? Colors.red.shade700 : Colors.green.shade700,
                              shape: isHead ? BoxShape.circle : BoxShape.rectangle,
                              borderRadius: !isHead ? BorderRadius.circular(4) : null,
                            ),
                          );
                        }
                        if (index == _food) {
                          return Container(
                            margin: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          );
                        }
                        return Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            
            // D-Pad Controls
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1B5E20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNavBtn(Icons.keyboard_arrow_up_rounded, 'up'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNavBtn(Icons.keyboard_arrow_left_rounded, 'left'),
                      const SizedBox(width: 50),
                      _buildNavBtn(Icons.keyboard_arrow_right_rounded, 'right'),
                    ],
                  ),
                  _buildNavBtn(Icons.keyboard_arrow_down_rounded, 'down'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBtn(IconData icon, String direction) {
    return GestureDetector(
      onTap: () {
        if (_direction == 'up' && direction == 'down') return;
        if (_direction == 'down' && direction == 'up') return;
        if (_direction == 'left' && direction == 'right') return;
        if (_direction == 'right' && direction == 'left') return;
        setState(() {
          _direction = direction;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white54, width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}
