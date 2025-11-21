import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngetrack/core/widgets/bottom_nav.dart';
import 'package:ngetrack/features/create/create_habit_sheet.dart';
import 'package:ngetrack/features/home/home_screen.dart';
import 'package:ngetrack/features/pomodoro/pomodoro_screen.dart';
import 'package:ngetrack/features/settings/settings_screen.dart';
import 'package:ngetrack/features/stats/stats_screen.dart';
import 'package:ngetrack/features/welcome/welcome_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNav(
            navigationShell: navigationShell,
            onAddTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const CreateHabitSheet(),
              );
            },
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const StatsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pomodoro',
              builder: (context, state) => const PomodoroScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
