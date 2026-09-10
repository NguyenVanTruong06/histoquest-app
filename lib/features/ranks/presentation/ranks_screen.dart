import 'package:flutter/material.dart';

class RanksScreen extends StatelessWidget {
  const RanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bảng vàng')),
      body: const Center(
        child: Text('Nội dung Bảng vàng (Ranks)'),
      ),
    );
  }
}
