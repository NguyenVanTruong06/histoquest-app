import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

/// Màn hình Mock UI Mô phỏng Chế độ Đấu Trí 1v1 (PvP)
class PvPDuelMockScreen extends StatefulWidget {
  const PvPDuelMockScreen({super.key});

  @override
  State<PvPDuelMockScreen> createState() => _PvPDuelMockScreenState();
}

class _PvPDuelMockScreenState extends State<PvPDuelMockScreen> {
  int _playerScore = 0;
  final int _opponentScore = 0;
  int _timeLeft = 60;
  
  // Dữ liệu mock câu hỏi
  final String _question = "Vị tướng nào đã lãnh đạo nghĩa quân đánh bại quân Nam Hán trên sông Bạch Đằng năm 938?";
  final List<String> _answers = [
    "Ngô Quyền",
    "Lý Thường Kiệt",
    "Trần Hưng Đạo",
    "Lê Lợi",
  ];
  
  int? _selectedAnswerIndex;
  int? _opponentAnswerIndex;
  
  @override
  void initState() {
    super.initState();
    _startMockSimulation();
  }
  
  void _startMockSimulation() async {
    // Đếm ngược thời gian giả lập
    while (_timeLeft > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _timeLeft--;
      });
      
      // Giả lập đối thủ bấm chọn đáp án sau 3 giây
      if (_timeLeft == 57 && _opponentAnswerIndex == null) {
        setState(() {
          _opponentAnswerIndex = 2; // Đối thủ chọn sai (Trần Hưng Đạo)
        });
      }
    }
  }

  void _handleAnswer(int index) {
    if (_selectedAnswerIndex != null) return;
    
    setState(() {
      _selectedAnswerIndex = index;
      if (index == 0) {
        _playerScore += 10; // Trả lời đúng Ngô Quyền
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A38),
      body: SafeArea(
        child: Column(
          children: [
            // Header: Thanh trạng thái 2 bên (Split view)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.black26,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Player Info (Trái)
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bạn (An)',
                            style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '$_playerScore Điểm',
                            style: GoogleFonts.roboto(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Đồng hồ đếm ngược (Giữa)
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _timeLeft > 10 ? AppColors.primaryDark : Colors.red,
                      border: Border.all(color: AppColors.gold, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$_timeLeft',
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  // Opponent Info (Phải)
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Đối Thủ (Bình)',
                            style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '$_opponentScore Điểm',
                            style: GoogleFonts.roboto(color: Colors.grey[400]!, fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blueGrey,
                        child: Icon(Icons.computer, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Câu hỏi
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 5)),
                        ],
                      ),
                      child: Text(
                        _question,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.philosopher(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2B2119),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 4 Đáp án dạng lưới 2x2
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: List.generate(4, (index) {
                          // Xác định trạng thái của nút đáp án
                          bool isSelectedByMe = _selectedAnswerIndex == index;
                          bool isSelectedByOpponent = _opponentAnswerIndex == index;
                          bool isCorrect = index == 0; // Ngô Quyền
                          
                          Color bgColor = Colors.white;
                          Color textColor = const Color(0xFF2B2119);
                          Border? border;
                          
                          if (isSelectedByMe) {
                            bgColor = isCorrect ? Colors.green : Colors.red;
                            textColor = Colors.white;
                          } else if (isSelectedByOpponent) {
                            border = Border.all(color: Colors.blueGrey, width: 3);
                          }
                          
                          return GestureDetector(
                            onTap: () => _handleAnswer(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(12),
                                border: border ?? Border.all(color: const Color(0xFFE2DDD2), width: 2),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      _answers[index],
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  // Hiển thị icon nếu đối thủ đã chọn đáp án này
                                  if (isSelectedByOpponent)
                                    const Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Icon(Icons.computer, color: Colors.blueGrey, size: 20),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    
                    // Nút Thoát 
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: IconButton(
                        icon: const Icon(Icons.exit_to_app_rounded, color: Colors.white70, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
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
