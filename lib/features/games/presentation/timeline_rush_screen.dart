import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TimelineRushScreen extends StatefulWidget {
  const TimelineRushScreen({super.key});

  @override
  State<TimelineRushScreen> createState() => _TimelineRushScreenState();
}

class _TimelineRushScreenState extends State<TimelineRushScreen> {
  // Demo list of historical events out of order
  final List<Map<String, dynamic>> _events = [
    {'year': 1010, 'title': 'Lý Thái Tổ dời đô về Thăng Long'},
    {'year': 938, 'title': 'Chiến thắng Bạch Đằng'},
    {'year': 1288, 'title': 'Đại thắng Bạch Đằng lần 3'},
    {'year': 968, 'title': 'Đinh Bộ Lĩnh dẹp loạn 12 sứ quân'},
  ];

  bool _isChecking = false;
  bool _isSuccess = false;

  void _checkOrder() {
    setState(() {
      _isChecking = true;
      _isSuccess = true;
      for (int i = 0; i < _events.length - 1; i++) {
        if ((_events[i]['year'] as int) > (_events[i + 1]['year'] as int)) {
          _isSuccess = false;
          break;
        }
      }
    });

    if (_isSuccess) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thành công!'),
          content: const Text('Bạn đã sắp xếp chính xác dòng thời gian! Nhận 200 XP & 80 xu.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to Games
              },
              child: const Text('Nhận thưởng & Quay về'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Timeline Rush'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      // Landscape: giới hạn chiều rộng nội dung và căn giữa để danh sách
      // kéo-thả không bị kéo dãn quá rộng trên màn hình ngang.
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Sắp xếp các sự kiện sau theo thứ tự thời gian từ cũ nhất đến mới nhất (kéo và thả):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: _events.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = _events.removeAt(oldIndex);
                    _events.insert(newIndex, item);
                    _isChecking = false;
                  });
                },
                itemBuilder: (context, index) {
                  final event = _events[index];
                  bool isCorrect = false;
                  bool isWrong = false;
                  if (_isChecking) {
                    List<Map<String, dynamic>> sorted = List.from(_events)..sort((a, b) => (a['year'] as int).compareTo(b['year'] as int));
                    if (sorted[index]['year'] == event['year']) {
                      isCorrect = true;
                    } else {
                      isWrong = true;
                    }
                  }

                  return Card(
                    key: ValueKey(event['title']),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: isCorrect
                        ? Colors.green.shade100
                        : (isWrong ? Colors.red.shade100 : Colors.white),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.drag_handle, color: AppColors.textSecondary),
                      title: Text(
                        event['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      subtitle: Text('Năm: ${event['year']}', style: const TextStyle(color: AppColors.textSecondary)),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _checkOrder,
                child: const Text(
                  'Kiểm tra',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }
}
