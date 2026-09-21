import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_dau_tien/features/eras/presentation/eras_screen.dart';

void main() {
  testWidgets('ErasScreen displays Civilization Select then Era Beanstalk view', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ErasScreen(),
        ),
      ),
    );

    // Màn 1: Chọn nền văn minh
    expect(find.text('Chọn nền văn minh'), findsOneWidget);
    expect(find.text('Việt Nam'), findsWidgets);

    // Chạm vào thẻ Việt Nam
    await tester.tap(find.text('Việt Nam'));
    await tester.pumpAndSettle();

    // Màn 2: Chọn Thời Kì
    expect(find.text('Chọn Thời Kì'), findsOneWidget);
    expect(find.text('VIỆT NAM'), findsOneWidget);
    expect(find.text('Đang chọn'), findsOneWidget);
  });
}
