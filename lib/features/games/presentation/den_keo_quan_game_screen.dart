import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class DenKeoQuanGameScreen extends StatefulWidget {
  const DenKeoQuanGameScreen({super.key});

  @override
  State<DenKeoQuanGameScreen> createState() => _DenKeoQuanGameScreenState();
}

class _DenKeoQuanGameScreenState extends State<DenKeoQuanGameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  
  final String _question = 'Bóng ai cỡi voi ra trận, nữ nhi đánh đuổi giặc Hán?';
  final List<String> _answers = ['Bà Triệu', 'Hai Bà Trưng', 'Bùi Thị Xuân', 'Ỷ Lan'];
  final int _correctIndex = 1; // Hai Bà Trưng
  
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  void _handleAnswer(int index) {
    if (_selectedIndex != null) return;
    setState(() {
      _selectedIndex = index;
    });
    
    // Stop spinning if correct
    if (index == _correctIndex) {
      _spinController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A110B), // Đêm tối
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background stars/particles
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.network(
                'https://www.transparenttextures.com/patterns/stardust.png',
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'ĐÈN KÉO QUÂN',
                  style: GoogleFonts.philosopher(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Nhìn bóng hình, đoán danh nhân',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                
                const SizedBox(height: 40),
                
                // Đèn kéo quân
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Khung ngoài đèn
                      Container(
                        width: 200,
                        height: 260,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5722).withValues(alpha: 0.2),
                          border: Border.all(color: AppColors.gold, width: 4),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF5722).withValues(alpha: 0.5),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      
                      // Lõi đèn quay (chứa bóng)
                      AnimatedBuilder(
                        animation: _spinController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _spinController.value * 2 * 3.14159,
                            child: Container(
                              width: 140,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFFCC80),
                                boxShadow: const [
                                  BoxShadow(color: Colors.white54, blurRadius: 20),
                                ],
                              ),
                              child: Center(
                                // Silhouette
                                child: Icon(
                                  Icons.accessibility_new_rounded, // Tượng trưng cho người cưỡi voi
                                  size: 80,
                                  color: Colors.black.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Câu hỏi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    _question,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.philosopher(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Đáp án
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: List.generate(4, (index) {
                        bool isSelected = _selectedIndex == index;
                        bool isCorrect = index == _correctIndex;
                        
                        Color bgColor = const Color(0xFF3E2D20);
                        Color borderColor = const Color(0xFFC7B590);
                        
                        if (_selectedIndex != null) {
                          if (isCorrect) {
                            bgColor = Colors.green.shade700;
                            borderColor = Colors.greenAccent;
                          } else if (isSelected) {
                            bgColor = Colors.red.shade800;
                            borderColor = Colors.redAccent;
                          }
                        }

                        return GestureDetector(
                          onTap: () => _handleAnswer(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                _answers[index],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
