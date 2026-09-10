import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EraEventsMapScreen extends StatelessWidget {
  final String eraId;
  const EraEventsMapScreen({super.key, required this.eraId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bản đồ sự kiện: $eraId')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/eras/$eraId/events/event_1'),
          child: const Text('Mở Mốc sự kiện 1'),
        ),
      ),
    );
  }
}
