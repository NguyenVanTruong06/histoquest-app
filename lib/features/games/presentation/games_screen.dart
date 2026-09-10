import 'package:flutter/material.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trò chơi')),
      body: const Center(
        child: Text('Nội dung Trò chơi (Games)'),
      ),
    );
  }
}
