import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Màn hình Mock UI: Nỏ Thần Cổ Loa
class ArcheryMockScreen extends StatefulWidget {
  const ArcheryMockScreen({super.key});

  @override
  State<ArcheryMockScreen> createState() => _ArcheryMockScreenState();
}

class _Target {
  final double x;
  final double y;
  final int id;
  
  _Target(this.id, this.x, this.y);
}

class _ArcheryMockScreenState extends State<ArcheryMockScreen> {
  int _score = 0;
  int _timeLeft = 30;
  final Random _random = Random();
  final List<_Target> _targets = [];
  Timer? _gameTimer;
  Timer? _spawnTimer;
  int _targetIdCounter = 0;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          timer.cancel();
          _spawnTimer?.cancel();
          _showGameOverDialog();
        }
      });
    });

    _spawnTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!mounted || _timeLeft <= 0) {
        timer.cancel();
        return;
      }
      if (_targets.length < 5) {
        _spawnTarget();
      }
    });
  }

  void _spawnTarget() {
    // Tọa độ ngẫu nhiên từ 0.1 đến 0.9 để không bị sát viền
    final x = _random.nextDouble() * 0.8 + 0.1;
    final y = _random.nextDouble() * 0.7 + 0.1;
    
    final target = _Target(_targetIdCounter++, x, y);
    setState(() {
      _targets.add(target);
    });
    
    // Tự động biến mất sau 2 giây nếu không bắn trúng
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _targets.contains(target)) {
        setState(() {
          _targets.remove(target);
        });
      }
    });
  }

  void _shootTarget(_Target target) {
    if (_timeLeft <= 0) return;
    setState(() {
      _score += 10;
      _targets.remove(target);
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Hết Giờ!'),
        content: Text('Bạn đã bắn được $_score điểm!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Thoát'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _score = 0;
                _timeLeft = 30;
                _targets.clear();
                _startGame();
              });
            },
            child: const Text('Chơi Lại'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background - Giả lập tường thành
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF880E4F), Color(0xFF4A148C)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Crosshairs hoặc các họa tiết mô phỏng
          Center(
            child: Icon(
              Icons.track_changes_outlined,
              color: Colors.white.withValues(alpha: 0.1),
              size: 200,
            ),
          ),
          
          // Các mục tiêu di động
          ..._targets.map((t) {
            return Align(
              alignment: FractionalOffset(t.x, t.y),
              child: GestureDetector(
                onTap: () => _shootTarget(t),
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.5, end: 1.0),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, val, child) {
                    return Transform.scale(
                      scale: val,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(2, 2)),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.sailing_rounded, color: Colors.white, size: 30),
                    ),
                  ),
                ),
              ),
            );
          }),
          
          // HUD: Điểm và thời gian
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'ĐIỂM: $_score',
                      style: GoogleFonts.roboto(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _timeLeft <= 5 ? Colors.red.withValues(alpha: 0.8) : Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_timeLeft s',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Nỏ thần ở dưới cùng
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Icon(
                Icons.adjust_rounded,
                color: Colors.amber.withValues(alpha: 0.8),
                size: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
