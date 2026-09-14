import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/countries/presentation/country_select_screen.dart';
import '../features/eras/presentation/eras_screen.dart';
import '../features/eras/presentation/era_events_map_screen.dart';
import '../features/eras/presentation/event_detail_screen.dart';
import '../features/ranks/presentation/ranks_screen.dart';
import '../features/games/presentation/games_screen.dart';
import '../features/social/presentation/social_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/quiz/presentation/quiz_screen.dart';
import '../features/quiz/presentation/quiz_result_screen.dart';
import '../data/models/historical_event_model.dart';
import '../shared/widgets/scaffold_with_nav_bar.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _mapNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'map');
final _ranksNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'ranks');
final _gamesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'games');
final _socialNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'social');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    // Màn 0 - Chọn quốc gia / nền văn minh, hiển thị TRƯỚC khi vào bản đồ
    // thời kỳ. Đây là màn khởi đầu của app.
    initialLocation: '/countries',
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/countries',
        builder: (context, state) => const CountrySelectScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Bản đồ (Map)
          StatefulShellBranch(
            navigatorKey: _mapNavigatorKey,
            routes: [
              GoRoute(
                path: '/eras',
                builder: (context, state) => const ErasScreen(),
                routes: [
                  GoRoute(
                    path: ':eraId',
                    builder: (context, state) {
                      final eraId = state.pathParameters['eraId']!;
                      return EraEventsMapScreen(eraId: eraId);
                    },
                    routes: [
                      GoRoute(
                        path: 'events/:eventId',
                        builder: (context, state) {
                          final eraId = state.pathParameters['eraId']!;
                          final eventId = state.pathParameters['eventId']!;
                          return EventDetailScreen(
                            eraId: eraId,
                            eventId: eventId,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
          // Branch 2: Bảng vàng (Ranks)
          StatefulShellBranch(
            navigatorKey: _ranksNavigatorKey,
            routes: [
              GoRoute(
                path: '/ranks',
                builder: (context, state) => const RanksScreen(),
              ),
            ],
          ),

          // Branch 3: Trò chơi (Games)
          StatefulShellBranch(
            navigatorKey: _gamesNavigatorKey,
            routes: [
              GoRoute(
                path: '/games',
                builder: (context, state) => const GamesScreen(),
              ),
            ],
          ),

          // Branch 4: Tin tức (Social/News)
          StatefulShellBranch(
            navigatorKey: _socialNavigatorKey,
            routes: [
              GoRoute(
                path: '/social',
                builder: (context, state) => const SocialScreen(),
              ),
            ],
          ),

          // Branch 5: Của tôi (Profile)
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Màn 2 - Quiz toàn màn hình
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/quiz',
        builder: (context, state) {
          final event = state.extra as HistoricalEventModel?;
          return QuizScreen(event: event);
        },
        routes: [
          // Màn 3 - Kết quả Quiz
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: 'result',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              return QuizResultScreen(
                correctCount: extra['correctCount'] as int? ?? 0,
                totalCount: extra['totalCount'] as int? ?? 3,
                event: extra['event'] as HistoricalEventModel?,
              );
            },
          ),
        ],
      ),
    ],
  );
}
