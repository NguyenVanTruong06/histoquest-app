import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

/// Màn hình Mock UI: Ghép Thẻ Tướng (Memory Game)
class CardMatchMockScreen extends StatefulWidget {
  const CardMatchMockScreen({super.key});

  @override
  State<CardMatchMockScreen> createState() => _CardMatchMockScreenState();
}

class _CardMatchMockScreenState extends State<CardMatchMockScreen> {
  final List<String> _heroes = [
    'Ngô Quyền', 'Trần Hưng Đạo', 'Quang Trung', 'Hai Bà Trưng',
    'Lê Lợi', 'Đinh Bộ Lĩnh', 'Lý Thường Kiệt', 'Bà Triệu'
  ];
  late List<String> _cards;
  late List<bool> _flipped;
  late List<bool> _matched;
  
  int? _firstFlippedIndex;
  bool _isProcessing = false;
  int _moves = 20;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    // Nhân đôi danh sách thẻ và xáo trộn
    _cards = [..._heroes, ..._heroes];
    _cards.shuffle(Random());
    _flipped = List.generate(16, (index) => false);
    _matched = List.generate(16, (index) => false);
    _moves = 20;
    _firstFlippedIndex = null;
    _isProcessing = false;
  }

  void _onCardTap(int index) async {
    if (_isProcessing || _flipped[index] || _matched[index] || _moves <= 0) return;

    setState(() {
      _flipped[index] = true;
    });

    if (_firstFlippedIndex == null) {
      _firstFlippedIndex = index;
    } else {
      _isProcessing = true;
      setState(() {
        _moves--;
      });

      int firstIndex = _firstFlippedIndex!;
      int secondIndex = index;

      if (_cards[firstIndex] == _cards[secondIndex]) {
        // Khớp!
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          _matched[firstIndex] = true;
          _matched[secondIndex] = true;
          _isProcessing = false;
          _firstFlippedIndex = null;
        });
        
        // Kiểm tra chiến thắng
        if (!_matched.contains(false)) {
          _showWinDialog();
        }
      } else {
        // Không khớp, úp lại
        await Future.delayed(const Duration(milliseconds: 1000));
        if (mounted) {
          setState(() {
            _flipped[firstIndex] = false;
            _flipped[secondIndex] = false;
            _isProcessing = false;
            _firstFlippedIndex = null;
          });
        }
      }
    }
    
    if (_moves <= 0 && _matched.contains(false)) {
      // Thua
      _showGameOverDialog();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Chiến Thắng!'),
        content: const Text('Bạn đã tìm được tất cả các danh tướng!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Thoát game
            },
            child: const Text('Thoát'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _initGame());
            },
            child: const Text('Chơi Lại'),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Hết Lượt!'),
        content: const Text('Bạn đã hết số lượt lật bài.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Thoát game
            },
            child: const Text('Thoát'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _initGame());
            },
            child: const Text('Chơi Lại'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Xanh lam nhạt
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: Text(
          'Ghép Thẻ Tướng',
          style: GoogleFonts.philosopher(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Lượt: $_moves',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    bool isRevealed = _flipped[index] || _matched[index];
                    return GestureDetector(
                      onTap: () => _onCardTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isRevealed ? Colors.white : AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isRevealed ? const Color(0xFF1565C0) : Colors.white,
                            width: 3,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                          ],
                        ),
                        child: Center(
                          child: isRevealed
                              ? Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    _cards[index],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.philosopher(
                                      color: const Color(0xFF1565C0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.help_outline_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Luật: Lật 2 thẻ bài giống nhau để ghép cặp. Trò chơi sẽ kết thúc nếu bạn lật sai quá nhiều lần!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
