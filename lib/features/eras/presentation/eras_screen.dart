import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErasScreen extends StatelessWidget {
  const ErasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn Thời Đại (Map)')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/eras/era_1'),
          child: const Text('Mở Thời đại 1'),
        ),
      ),
    );
  }
}
