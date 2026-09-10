import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  final String eraId;
  final String eventId;
  const EventDetailScreen({super.key, required this.eraId, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết sự kiện: $eventId')),
      body: Center(
        child: Text('Nội dung sự kiện $eventId thuộc thời đại $eraId'),
      ),
    );
  }
}
