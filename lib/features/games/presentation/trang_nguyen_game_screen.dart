import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class TrangNguyenGameScreen extends StatefulWidget {
  const TrangNguyenGameScreen({super.key});

  @override
  State<TrangNguyenGameScreen> createState() => _TrangNguyenGameScreenState();
}

class _TrangNguyenGameScreenState extends State<TrangNguyenGameScreen> {
  int _currentStage = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  
  final List<Map<String, dynamic>> _stages = [
    {
      'title': 'Thi Hương (Cấp Địa Phương)',
      'question': 'Ai là vị vua đã dời đô từ Hoa Lư về Thăng Long năm 1010?',
      'options': ['Lý Thái Tổ', 'Lý Thường Kiệt', 'Trần Thái Tông', 'Lê Lợi'],
      'correct': 0,
    },
    {
      'title': 'Thi Hội (Cấp Quốc Gia)',
      'question': 'Bản Tuyên ngôn Độc lập đầu tiên của nước ta là bài thơ nào?',
      'options': ['Hịch Tướng Sĩ', 'Nam Quốc Sơn Hà', 'Bình Ngô Đại Cáo', 'Chiếu Dời Đô'],
      'correct': 1,
    },
    {
      'title': 'Thi Đình (Cấp Hoàng Cung)',
      'question': 'Trạng Nguyên trẻ nhất trong lịch sử khoa bảng Việt Nam là ai?',
      'options': ['Mạc Đĩnh Chi', 'Nguyễn Bỉnh Khiêm', 'Nguyễn Hiền', 'Lương Thế Vinh'],
      'correct': 2,
    }
  ];

  void _handleAnswer(int index) {
    if (_showResult) return;
    
    setState(() {
      _selectedAnswer = index;
      _showResult = true;
      
      if (index == _stages[_currentStage]['correct']) {
        _score += 150;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (_currentStage < _stages.length - 1) {
          setState(() {
            _currentStage++;
            _selectedAnswer = null;
            _showResult = false;
          });
        } else {
          // Hoàn thành
          _showVictoryDialog();
        }
      }
    });
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF7F2),
        title: Text(
          'Vinh Quy Bái Tổ!',
          textAlign: TextAlign.center,
          style: GoogleFonts.philosopher(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.military_tech_rounded, color: AppColors.gold, size: 64),
            const SizedBox(height: 16),
            Text(
              'Chúc mừng tân Khoa Bảng!\nBạn đã đạt được $_score điểm trong kỳ thi Đình.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Nhận Mũ Áo Cánh Chuồn', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stage = _stages[_currentStage];
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'KỲ ĐÀI TRẠNG NGUYÊN',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              color: const Color(0xFF3E2D20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stage['title'],
                    style: GoogleFonts.philosopher(
                      color: AppColors.gold,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Điểm: $_score',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Cuộn thư câu hỏi
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFdf5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFC7B590), width: 3),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            stage['question'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.philosopher(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2B2119),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Đáp án
                    Expanded(
                      flex: 3,
                      child: ListView.separated(
                        itemCount: stage['options'].length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final isCorrectAnswer = index == stage['correct'];
                          final isSelected = index == _selectedAnswer;
                          
                          Color bgColor = Colors.white;
                          Color borderColor = const Color(0xFFC7B590);
                          Color textColor = const Color(0xFF2B2119);
                          
                          if (_showResult) {
                            if (isCorrectAnswer) {
                              bgColor = Colors.green.shade50;
                              borderColor = Colors.green;
                              textColor = Colors.green.shade800;
                            } else if (isSelected) {
                              bgColor = Colors.red.shade50;
                              borderColor = Colors.red;
                              textColor = Colors.red.shade800;
                            }
                          }

                          return GestureDetector(
                            onTap: () => _handleAnswer(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor, width: 2),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFFE4D5B7),
                                      border: Border.all(color: const Color(0xFFC7B590)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + index), // A, B, C, D
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5A1E1E)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      stage['options'][index],
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  if (_showResult && isCorrectAnswer)
                                    const Icon(Icons.check_circle_rounded, color: Colors.green),
                                  if (_showResult && isSelected && !isCorrectAnswer)
                                    const Icon(Icons.cancel_rounded, color: Colors.red),
                                ],
                              ),
                            ),
                          );
                        },
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
