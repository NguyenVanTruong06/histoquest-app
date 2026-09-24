import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_dau_tien/data/repositories/history_repository_provider.dart';

void main() {
  group('HistoryRepositoryProvider & UserProfileNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('erasFutureProvider fetches all 6 Vietnamese eras', () async {
      final eras = await container.read(erasFutureProvider.future);
      expect(eras.length, 6);
      expect(eras.first.id, 'era_1');
      expect(eras.first.name, 'Thời kỳ Tiền sử');
    });

    test('eraDetailFutureProvider finds specific era by id', () async {
      final era = await container.read(eraDetailFutureProvider('era_2').future);
      expect(era, isNotNull);
      expect(era?.id, 'era_2');
      expect(era?.events.isNotEmpty, isTrue);
    });

    test('eventDetailFutureProvider finds specific event by id', () async {
      final event = await container.read(eventDetailFutureProvider('event_nuido').future);
      expect(event, isNotNull);
      expect(event?.id, 'event_nuido');
      expect(event?.title, 'Người tối cổ ở núi Đọ');
      expect(event?.questions.length, 3);
    });

    test('userProfileProvider adds rewards correctly', () {
      final initialUser = container.read(userProfileProvider);
      final initialCoins = initialUser.coins;
      final initialXp = initialUser.xp;

      container.read(userProfileProvider.notifier).addRewards(coins: 100, xp: 50);

      final updatedUser = container.read(userProfileProvider);
      expect(updatedUser.coins, initialCoins + 100);
      expect(updatedUser.xp, initialXp + 50);
    });

    test('userProfileProvider updates avatar frame and banner', () {
      container.read(userProfileProvider.notifier).updateDecorations(
        frameId: 'frame_dragon',
        bannerId: 'banner_thang_long',
      );

      final updatedUser = container.read(userProfileProvider);
      expect(updatedUser.currentFrameId, 'frame_dragon');
      expect(updatedUser.currentBannerId, 'banner_thang_long');
    });

    test('userProfileProvider purchases shop decoration', () {
      final notifier = container.read(userProfileProvider.notifier);
      final initialCoins = container.read(userProfileProvider).coins;

      final success = notifier.unlockDecoration('frame_lotus', 100);
      expect(success, isTrue);

      final updatedUser = container.read(userProfileProvider);
      expect(updatedUser.unlockedDecorationIds.contains('frame_lotus'), isTrue);
      expect(updatedUser.coins, initialCoins - 100);
    });
  });
}
