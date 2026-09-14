import '../models/user_model.dart';
import '../models/era_model.dart';
import '../models/historical_event_model.dart';
import '../models/hero_card_model.dart';
import '../mock_data.dart';

/// Interface trừu tượng cho tầng dữ liệu HistoQuest.
/// Sau này khi có Backend (Firebase/Supabase/REST API), chỉ cần viết RemoteHistoryRepository
/// kế thừa interface này mà không cần sửa bất kỳ dòng code giao diện (UI) nào!
abstract class HistoryRepository {
  Future<UserModel> getUserProfile();
  Future<List<EraModel>> getEras();
  Future<EraModel?> getEraById(String eraId);
  Future<HistoricalEventModel?> getEventById(String eventId);
  Future<List<HeroCardModel>> getHeroCards();
  Future<List<Map<String, dynamic>>> getLeaderboard();
  Future<UserModel> addRewards({required int coins, required int xp});
  Future<bool> markEventCompleted(String eventId);
}

/// Triển khai MockRepository dùng hoàn toàn dữ liệu giả lập chuẩn xác
class MockHistoryRepository implements HistoryRepository {
  UserModel _user = MockData.currentUser;
  final List<EraModel> _eras = List.from(MockData.eras);
  final List<HeroCardModel> _cards = List.from(MockData.heroCards);

  // Giả lập độ trễ mạng thực tế (Network Latency)
  Future<void> _simulateNetworkDelay([int ms = 250]) async {
    await Future.delayed(Duration(milliseconds: ms));
  }

  @override
  Future<UserModel> getUserProfile() async {
    await _simulateNetworkDelay(150);
    return _user;
  }

  @override
  Future<List<EraModel>> getEras() async {
    await _simulateNetworkDelay(250);
    return List.unmodifiable(_eras);
  }

  @override
  Future<EraModel?> getEraById(String eraId) async {
    await _simulateNetworkDelay(150);
    try {
      return _eras.firstWhere((e) => e.id == eraId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<HistoricalEventModel?> getEventById(String eventId) async {
    await _simulateNetworkDelay(150);
    for (final era in _eras) {
      for (final event in era.events) {
        if (event.id == eventId) return event;
      }
    }
    return null;
  }

  @override
  Future<List<HeroCardModel>> getHeroCards() async {
    await _simulateNetworkDelay(200);
    return List.unmodifiable(_cards);
  }

  @override
  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    await _simulateNetworkDelay(200);
    return List.unmodifiable(MockData.leaderboard);
  }

  @override
  Future<UserModel> addRewards({required int coins, required int xp}) async {
    await _simulateNetworkDelay(100);
    _user = _user.copyWith(
      coins: _user.coins + coins,
      xp: _user.xp + xp,
    );
    return _user;
  }

  @override
  Future<bool> markEventCompleted(String eventId) async {
    await _simulateNetworkDelay(150);
    for (int i = 0; i < _eras.length; i++) {
      final era = _eras[i];
      final eventIndex = era.events.indexWhere((e) => e.id == eventId);
      if (eventIndex != -1) {
        final currentEvent = era.events[eventIndex];
        final updatedEvent = currentEvent.copyWith(isCompleted: true);
        final updatedEvents = List<HistoricalEventModel>.from(era.events);
        updatedEvents[eventIndex] = updatedEvent;
        _eras[i] = era.copyWith(events: updatedEvents);
        _user = _user.copyWith(
          totalQuestsCompleted: _user.totalQuestsCompleted + 1,
        );
        return true;
      }
    }
    return false;
  }
}
