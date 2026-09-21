import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Một Widget bọc bên ngoài các màn hình trò chơi yêu cầu màn hình ngang.
/// Tự động xoay ngang khi khởi tạo, và trả về màn hình dọc khi thoát.
class LandscapeGameWrapper extends StatefulWidget {
  final Widget child;

  const LandscapeGameWrapper({super.key, required this.child});

  @override
  State<LandscapeGameWrapper> createState() => _LandscapeGameWrapperState();
}

class _LandscapeGameWrapperState extends State<LandscapeGameWrapper> {
  @override
  void initState() {
    super.initState();
    // Chuyển sang màn hình ngang (cả 2 hướng)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Trả về màn hình dọc mặc định khi thoát game
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
