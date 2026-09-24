import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_dau_tien/features/eras/presentation/era_events_map_screen.dart';
import 'package:app_mobile_dau_tien/features/eras/presentation/widgets/map_event_node.dart';

void main() {
  testWidgets('EraEventsMapScreen renders vintage map, header and event nodes for era_1', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: EraEventsMapScreen(eraId: 'era_1'),
        ),
      ),
    );
    // Dùng pump với duration thay vì pumpAndSettle vì MapEventNode có pulse animation vô tận
    await tester.pump(const Duration(milliseconds: 500));

    // 1. Kiểm tra header và cờ xuất quân
    expect(find.text('XUẤT QUÂN'), findsOneWidget);
    expect(find.byType(MapEventNode), findsWidgets);

    // 2. Chạm vào node sự kiện đang active (Người tối cổ ở núi Đọ)
    final firstNode = find.byType(MapEventNode).first;
    expect(firstNode, findsOneWidget);
    await tester.tap(firstNode);
    await tester.pump(const Duration(milliseconds: 500));

    // 3. BottomSheet hiển thị thông tin mốc lịch sử
    expect(find.textContaining('Người tối cổ ở núi Đọ'), findsWidgets);
    expect(find.text('Bối cảnh lịch sử:'), findsOneWidget);
    expect(find.text('Ôn tập mốc này'), findsOneWidget);
  });

  testWidgets('EraEventsMapScreen handles empty/updating era gracefully', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: EraEventsMapScreen(eraId: 'non_existent_era'),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // Fallback về thời kỳ hợp lệ đầu tiên hoặc hiển thị an toàn
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
