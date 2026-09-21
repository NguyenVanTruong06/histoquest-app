import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class CoLauGameScreen extends StatefulWidget {
  const CoLauGameScreen({super.key});

  @override
  State<CoLauGameScreen> createState() => _CoLauGameScreenState();
}

class _CoLauGameScreenState extends State<CoLauGameScreen> {
  // Bàn cờ 3x3 (null: trống, 1: phe ta cờ lau, 2: phe địch)
  final List<int?> _board = List.filled(9, null);
  int _flagsPlaced = 0;
  bool _isPlayerTurn = true;
  bool _isGameOver = false;

  void _handleTap(int index) {
    if (_isGameOver || !_isPlayerTurn || _board[index] != null) return;

    setState(() {
      _board[index] = 1; // Phe ta đặt cờ lau
      _flagsPlaced++;
      _isPlayerTurn = false;
    });

    if (_checkWin(1)) {
      _endGame(true);
      return;
    }

    if (_flagsPlaced == 9) {
      _endGame(false); // Hòa
      return;
    }

    // Địch đi
    Future.delayed(const Duration(milliseconds: 500), _enemyTurn);
  }

  void _enemyTurn() {
    if (_isGameOver) return;
    
    // Tìm ô trống đầu tiên
    int emptyIndex = _board.indexWhere((element) => element == null);
    if (emptyIndex != -1) {
      setState(() {
        _board[emptyIndex] = 2; // Địch cắm cờ
        _flagsPlaced++;
        _isPlayerTurn = true;
      });

      if (_checkWin(2)) {
        _endGame(false);
      }
    }
  }

  bool _checkWin(int player) {
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Ngang
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Dọc
      [0, 4, 8], [2, 4, 6]             // Chéo
    ];

    for (var line in lines) {
      if (_board[line[0]] == player &&
          _board[line[1]] == player &&
          _board[line[2]] == player) {
        return true;
      }
    }
    return false;
  }

  void _endGame(bool isWin) {
    setState(() {
      _isGameOver = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF5E6D3),
        title: Text(
          isWin ? 'Chiến Thắng!' : 'Đã kết thúc!',
          textAlign: TextAlign.center,
          style: GoogleFonts.philosopher(
            color: isWin ? Colors.green.shade800 : AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          isWin 
              ? 'Tài thao lược xuất chúng! Ngài đã dùng cờ lau bày trận đánh bại đám mục đồng.'
              : 'Trận địa đã bị đối phương chiếm giữ hoặc hòa hoãn.',
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784), // Nền cỏ xanh
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'CỜ LAU TẬP TRẬN',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              color: const Color(0xFF1B5E20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flag_rounded, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        _isPlayerTurn ? 'Lượt của bạn' : 'Đối phương suy nghĩ...',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Mục tiêu: Chiếm 3 Gò', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7CB342),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF558B2F), width: 6),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
                      ],
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        final val = _board[index];
                        return GestureDetector(
                          onTap: () => _handleTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: val == null ? const Color(0xFFAED581) : (val == 1 ? const Color(0xFFFFF9C4) : const Color(0xFFFFCDD2)),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: val == null ? const Color(0xFF8BC34A) : (val == 1 ? Colors.orange : Colors.red), 
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: val == 1
                                  ? const Icon(Icons.flag_rounded, color: Colors.orange, size: 60)
                                  : val == 2
                                      ? const Icon(Icons.close_rounded, color: Colors.red, size: 60)
                                      : null,
                            ),
                          ),
                        );
                      },
                    ),
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
