import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class BachDangGameScreen extends StatefulWidget {
  const BachDangGameScreen({super.key});

  @override
  State<BachDangGameScreen> createState() => _BachDangGameScreenState();
}

class _BachDangGameScreenState extends State<BachDangGameScreen> {
  double _waterLevel = 1.0; // 1.0 = Max, 0.0 = Cạn
  Timer? _tideTimer;
  bool _isGameOver = false;
  bool _spikesActivated = false;

  @override
  void initState() {
    super.initState();
    _startTide();
  }

  void _startTide() {
    _tideTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_waterLevel > 0 && !_isGameOver) {
        setState(() {
          _waterLevel -= 0.005; // Giảm dần 0.5% mỗi 50ms (tầm 10s cạn)
        });
      } else if (_waterLevel <= 0 && !_isGameOver) {
        _endGame(false, "Thủy triều đã rút cạn mà bạn chưa kích hoạt cọc. Thuyền giặc đã thoát!");
      }
    });
  }

  @override
  void dispose() {
    _tideTimer?.cancel();
    super.dispose();
  }

  void _activateSpikes() {
    if (_isGameOver || _spikesActivated) return;
    
    setState(() {
      _spikesActivated = true;
    });
    
    // Check win condition
    // Sweet spot: 0.15 <= waterLevel <= 0.30
    if (_waterLevel >= 0.15 && _waterLevel <= 0.30) {
      _endGame(true, "Tuyệt vời! Bãi cọc ngầm đã đâm thủng chiến thuyền giặc Nam Hán!");
    } else if (_waterLevel > 0.30) {
      _endGame(false, "Quá sớm! Nước còn cao, thuyền giặc dễ dàng lướt qua bãi cọc.");
    } else {
      _endGame(false, "Quá muộn! Thuyền giặc đã đi qua khu vực bãi cọc trước khi nước rút.");
    }
  }

  void _endGame(bool isWin, String message) {
    setState(() {
      _isGameOver = true;
    });
    _tideTimer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF7F2),
        title: Text(
          isWin ? 'Chiến Thắng!' : 'Thất Bại!',
          textAlign: TextAlign.center,
          style: GoogleFonts.philosopher(
            color: isWin ? Colors.green.shade800 : AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
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
              child: const Text('Rời Khỏi', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00695C), // Nền nước
      appBar: AppBar(
        backgroundColor: const Color(0xFF004D40),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'BẠCH ĐẰNG CỌC NGẦM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              color: const Color(0xFF00332A),
              child: const Text(
                'Chờ thủy triều rút đến mức CẢNH BÁO màu cam để kích hoạt bãi cọc!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            
            Expanded(
              child: Row(
                children: [
                  // Thanh thủy triều
                  Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white30, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Cột nước
                        FractionallySizedBox(
                          heightFactor: _waterLevel,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        // Vùng Sweet Spot (Cam)
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.6 * 0.15, // 15% height of bar (rough est)
                          child: Container(
                            width: 56,
                            height: MediaQuery.of(context).size.height * 0.6 * 0.15, // 15% to 30% gap
                            color: Colors.orange.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Khu vực sông & bãi cọc
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 24, right: 24),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade800,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade200, width: 4),
                        image: const DecorationImage(
                          image: NetworkImage('https://www.transparenttextures.com/patterns/water.png'),
                          repeat: ImageRepeat.repeat,
                          opacity: 0.3,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Thuyền giặc (Nổi)
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 100),
                            top: 50 + (1 - _waterLevel) * 200,
                            child: Icon(
                              Icons.sailing_rounded,
                              size: 80,
                              color: Colors.brown.shade800,
                            ),
                          ),
                          
                          // Bãi cọc (Chìm)
                          if (_spikesActivated)
                            Positioned(
                              bottom: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3, 
                                  (index) => const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Icon(Icons.change_history_rounded, size: 60, color: Colors.grey), // Mũi giáo nhọn
                                  )
                                ),
                              ),
                            ),
                            
                          if (!_spikesActivated && _waterLevel < 0.4)
                            Positioned(
                              bottom: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3, 
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Icon(Icons.change_history_rounded, size: 60, color: Colors.grey.withValues(alpha: 0.3)), // Bóng mờ bãi cọc
                                  )
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Nút kích hoạt
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _activateSpikes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'KÍCH HOẠT BÃI CỌC',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
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
