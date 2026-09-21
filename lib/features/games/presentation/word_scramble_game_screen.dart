import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class WordScrambleGameScreen extends StatefulWidget {
  const WordScrambleGameScreen({super.key});

  @override
  State<WordScrambleGameScreen> createState() => _WordScrambleGameScreenState();
}

class _WordScrambleGameScreenState extends State<WordScrambleGameScreen> {
  final String _clue = "Người anh hùng áo vải cờ đào đại phá 29 vạn quân Thanh";
  final String _targetWord = "QUANG TRUNG";
  
  late List<String> _poolLetters;
  late List<String?> _answerSlots;
  int _score = 0;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    // Tách các chữ cái (bỏ dấu cách)
    String lettersOnly = _targetWord.replaceAll(' ', '');
    _poolLetters = lettersOnly.split('')..shuffle();
    
    // Khởi tạo slots (bằng null nếu là khoảng trống, hoặc khoảng trắng nếu là space)
    _answerSlots = List.filled(_targetWord.length, null);
    for (int i = 0; i < _targetWord.length; i++) {
      if (_targetWord[i] == ' ') {
        _answerSlots[i] = ' ';
      }
    }
  }

  void _handlePoolTap(int poolIndex) {
    if (_isSuccess) return;
    
    // Tìm slot trống đầu tiên
    int emptySlot = -1;
    for (int i = 0; i < _answerSlots.length; i++) {
      if (_answerSlots[i] == null) {
        emptySlot = i;
        break;
      }
    }

    if (emptySlot != -1) {
      setState(() {
        _answerSlots[emptySlot] = _poolLetters[poolIndex];
        _poolLetters.removeAt(poolIndex);
      });
      _checkWin();
    }
  }

  void _handleSlotTap(int slotIndex) {
    if (_isSuccess) return;
    if (_answerSlots[slotIndex] != null && _answerSlots[slotIndex] != ' ') {
      setState(() {
        _poolLetters.add(_answerSlots[slotIndex]!);
        _answerSlots[slotIndex] = null;
      });
    }
  }

  void _checkWin() {
    String currentAnswer = _answerSlots.map((e) => e ?? '').join('');
    if (currentAnswer == _targetWord) {
      setState(() {
        _isSuccess = true;
        _score = 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3), // Nền giấy cổ
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3728),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'VUA CHỮ SỬ KÝ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Điểm số
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: const Color(0xFF3E2D20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Câu: 1/10',
                    style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'Điểm: $_score',
                    style: GoogleFonts.roboto(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Text(
                    'Thời gian: 00:59',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Manh mối
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFC7B590), width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.help_outline_rounded, color: AppColors.primary, size: 32),
                          const SizedBox(height: 12),
                          Text(
                            _clue,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.philosopher(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2B2119),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Ô trống đáp án
                    Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: List.generate(_targetWord.length, (index) {
                        if (_targetWord[index] == ' ') {
                          return const SizedBox(width: 20, height: 40);
                        }
                        
                        final String? char = _answerSlots[index];
                        final bool hasChar = char != null;
                        
                        return GestureDetector(
                          onTap: () => _handleSlotTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 45,
                            height: 55,
                            decoration: BoxDecoration(
                              color: hasChar ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _isSuccess 
                                    ? Colors.green 
                                    : (hasChar ? AppColors.primaryDark : const Color(0xFFB5A998)), 
                                width: 2,
                              ),
                              boxShadow: hasChar ? const [
                                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                              ] : null,
                            ),
                            child: Center(
                              child: Text(
                                char ?? '',
                                style: GoogleFonts.rubik(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Thư viện chữ cái (Pool)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: List.generate(_poolLetters.length, (index) {
                        return GestureDetector(
                          onTap: () => _handlePoolTap(index),
                          child: Container(
                            width: 45,
                            height: 55,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFD4CABB), width: 2),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _poolLetters[index],
                                style: GoogleFonts.rubik(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2B2119),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    
                    if (_isSuccess) ...[
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.check_circle_rounded),
                        label: const Text('Hoàn Thành Tuyệt Sắc'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]
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
