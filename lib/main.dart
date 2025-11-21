import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ngetrack/core/theme/app_theme.dart';
import 'package:ngetrack/routes/app_router.dart';

void main() {
  runApp(const ProviderScope(child: NgeTrackApp()));
}

class NgeTrackApp extends StatelessWidget {
  const NgeTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NgeTrack! Pro',
      theme: AppTheme.theme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
