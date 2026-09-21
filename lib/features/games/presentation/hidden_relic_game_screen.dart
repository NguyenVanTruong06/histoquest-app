import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import 'widgets/hidden_relic_painting.dart';

class RelicLevel {
  final String id;
  final String name;
  final String clue;
  final double x;
  final double y;
  final double w;
  final double h;
  final IconData icon;

  RelicLevel({
    required this.id,
    required this.name,
    required this.clue,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.icon,
  });
}

class HiddenRelicGameScreen extends StatefulWidget {
  const HiddenRelicGameScreen({super.key});

  @override
  State<HiddenRelicGameScreen> createState() => _HiddenRelicGameScreenState();
}

class _HiddenRelicGameScreenState extends State<HiddenRelicGameScreen> {
  int _timeLeft = 180;
  int _score = 0;
  Timer? _timer;
  int _currentLevelIndex = 0;
  bool _isGameOver = false;
  bool _showHint = false;

  final List<RelicLevel> _levels = [
    RelicLevel(
      id: 'dragon',
      name: 'Kim Long Tượng',
      clue: 'Nằm uy nghi giữa điện tiền,\nVảy vàng rực rỡ, thiêng liêng vương quyền.',
      x: 0.38,
      y: 0.70,
      w: 0.18,
      h: 0.22,
      icon: Icons.star_rounded,
    ),
    RelicLevel(
      id: 'vase',
      name: 'Bình Gốm Cổ',
      clue: 'Nép mình bên cột sơn son,\nSứ xanh men ngọc, mỏi mòn đợi chờ.',
      x: 0.04,
      y: 0.65,
      w: 0.12,
      h: 0.25,
      icon: Icons.local_drink_rounded,
    ),
    RelicLevel(
      id: 'lantern',
      name: 'Lồng Đèn Lục Giác',
      clue: 'Treo cao soi sáng hoàng cung,\nSáu mặt hoa văn, sáng bừng đêm thâu.',
      x: 0.65,
      y: 0.10,
      w: 0.10,
      h: 0.20,
      icon: Icons.light_mode_rounded,
    ),
    RelicLevel(
      id: 'scroll',
      name: 'Chiếu Chỉ',
      clue: 'Trải ra trên kỷ bằng vàng,\nSắc phong thiên tử, ban ngàn ân sâu.',
      x: 0.22,
      y: 0.82,
      w: 0.18,
      h: 0.15,
      icon: Icons.history_edu_rounded,
    ),
    RelicLevel(
      id: 'ink',
      name: 'Nghiên Mực & Lông Chim',
      clue: 'Nằm chờ trang giấy mở ra,\nNét son châu phê, sơn hà ngợi ca.',
      x: 0.65,
      y: 0.80,
      w: 0.08,
      h: 0.12,
      icon: Icons.edit_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && !_isGameOver) {
        setState(() {
          _timeLeft--;
        });
      } else if (_timeLeft <= 0) {
        _endGame();
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _isGameOver = true;
    });
    _showGameOverDialog();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _useHint() {
    if (_timeLeft > 20 && !_showHint) {
      setState(() {
        _timeLeft -= 20;
        _showHint = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showHint = false;
          });
        }
      });
    } else if (_timeLeft <= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không đủ thời gian để dùng quyền trợ giúp! (Cần 20s)'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleFoundRelic() {
    final foundName = _levels[_currentLevelIndex].name;
    setState(() {
      _score += 100 + _timeLeft; // Thưởng thời gian
      if (_currentLevelIndex < _levels.length - 1) {
        _currentLevelIndex++;
      } else {
        _endGame();
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text('Chính xác! Đã tìm thấy $foundName'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleWrongTap() {
    if (_timeLeft > 5) {
      setState(() {
        _timeLeft -= 5; // Phạt 5s khi bấm sai
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('-5s: Không có cổ vật ở vị trí này!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }

  void _showGameOverDialog() {
    final bool isVictory = _currentLevelIndex >= _levels.length - 1 && _timeLeft > 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF7F2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isVictory ? '🎉 Xuất Sắc!' : '⏳ Hết Giờ!',
          textAlign: TextAlign.center,
          style: GoogleFonts.philosopher(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isVictory
                  ? 'Bạn đã tìm thấy tất cả cổ vật hoàng cung!'
                  : 'Thời gian thám hiểm đã kết thúc.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Điểm số: $_score',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              Navigator.pop(context); // Thoát game
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Rời Khỏi'),
          ),
        ],
      ),
    );
  }

  String get _formattedTime {
    final m = _timeLeft ~/ 60;
    final s = _timeLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isGameOver && _currentLevelIndex >= _levels.length) {
      return const Scaffold(backgroundColor: Color(0xFF2B2119));
    }
    
    final currentLevel = _levels[_currentLevelIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF2B2119),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header: Trạng thái Game
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1510),
                border: Border(bottom: BorderSide(color: AppColors.gold, width: 2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.white70, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        _formattedTime,
                        style: GoogleFonts.rubik(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _timeLeft <= 30 ? Colors.redAccent : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.gold, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '${_currentLevelIndex + 1}/${_levels.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Nội dung chính: Hình ảnh & Manh mối (Ngang)
            Expanded(
              child: Row(
                children: [
                  // Sidebar: Manh mối
                  Container(
                    width: 250,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE4D5B7),
                      border: Border(right: BorderSide(color: Color(0xFFC7B590), width: 3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Mật Thư Cổ',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.philosopher(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5A1E1E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFC7B590)),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Center(
                            child: Text(
                              currentLevel.clue,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.philosopher(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF333333),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _useHint,
                          icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
                          label: const Text('Gợi Ý (-20s)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A1E1E),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Khung tranh (Main)
                  Expanded(
                    child: HiddenRelicPainting(
                      currentLevel: currentLevel,
                      showHint: _showHint,
                      onFound: _handleFoundRelic,
                      onWrongTap: _handleWrongTap,
                    ),
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
