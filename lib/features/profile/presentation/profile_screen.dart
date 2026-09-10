import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Của tôi')),
      body: const Center(
        child: Text('Nội dung Của tôi (Profile)'),
      ),
    );
  }
}
