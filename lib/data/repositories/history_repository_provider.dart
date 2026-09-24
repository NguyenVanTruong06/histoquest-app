import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock_data.dart';
import '../models/era_model.dart';
import '../models/hero_card_model.dart';
import '../models/historical_event_model.dart';
import '../models/user_model.dart';
import 'history_repository.dart';

/// Provider cung cấp tầng HistoryRepository đơn vị duy nhất (Singleton Instance)
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return MockHistoryRepository();
});

/// StateNotifier quản lý trạng thái người dùng (XP, Xu, Streak, Cửa hàng & Trang bị)
class UserProfileNotifier extends Notifier<UserModel> {
  @override
  UserModel build() {
    return MockData.currentUser;
  }

  /// Nhận thưởng sau khi hoàn thành Quiz hoặc Mini-game
  void addRewards({required int coins, required int xp}) {
    state = state.copyWith(
      coins: state.coins + coins,
      xp: state.xp + xp,
    );
    MockData.currentUser = state;
  }

  /// Cập nhật trang bị đại diện (Khung avatar & Ảnh bìa)
  void updateDecorations({String? frameId, String? bannerId}) {
    state = state.copyWith(
      currentFrameId: frameId ?? state.currentFrameId,
      currentBannerId: bannerId ?? state.currentBannerId,
    );
    MockData.currentUser = state;
  }

  /// Mua hoặc mở khóa một vật phẩm trang trí mới từ cửa hàng
  bool unlockDecoration(String decorationId, int cost) {
    if (state.unlockedDecorationIds.contains(decorationId)) return true;
    if (state.coins < cost) return false;

    final updatedUnlocked = List<String>.from(state.unlockedDecorationIds)..add(decorationId);
    state = state.copyWith(
      coins: state.coins - cost,
      unlockedDecorationIds: updatedUnlocked,
    );
    MockData.currentUser = state;
    return true;
  }

  /// Đánh dấu hoàn thành một nhiệm vụ hoặc mốc lịch sử
  void incrementCompletedQuests() {
    state = state.copyWith(
      totalQuestsCompleted: state.totalQuestsCompleted + 1,
    );
    MockData.currentUser = state;
  }
}

/// Provider người dùng theo dõi và cập nhật toàn app
final userProfileProvider = NotifierProvider<UserProfileNotifier, UserModel>(() {
  return UserProfileNotifier();
});

/// FutureProvider lấy danh sách toàn bộ các thời kỳ
final erasFutureProvider = FutureProvider<List<EraModel>>((ref) async {
  final repository = ref.watch(historyRepositoryProvider);
  return repository.getEras();
});

/// FutureProvider lấy chi tiết 1 thời kỳ theo [eraId]
final eraDetailFutureProvider = FutureProvider.family<EraModel?, String>((ref, eraId) async {
  final repository = ref.watch(historyRepositoryProvider);
  return repository.getEraById(eraId);
});

/// FutureProvider lấy chi tiết 1 sự kiện lịch sử theo [eventId]
final eventDetailFutureProvider = FutureProvider.family<HistoricalEventModel?, String>((ref, eventId) async {
  final repository = ref.watch(historyRepositoryProvider);
  return repository.getEventById(eventId);
});

/// FutureProvider lấy bảng xếp hạng
final leaderboardFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(historyRepositoryProvider);
  return repository.getLeaderboard();
});

/// FutureProvider lấy danh sách thẻ tướng thu thập
final heroCardsFutureProvider = FutureProvider<List<HeroCardModel>>((ref) async {
  final repository = ref.watch(historyRepositoryProvider);
  return repository.getHeroCards();
});
