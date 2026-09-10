import 'package:flutter/material.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tin tức / Xã hội')),
      body: const Center(
        child: Text('Nội dung Tin tức (Social/News)'),
      ),
    );
  }
}
