import 'package:flutter/material.dart';
import 'package:ngetrack/core/theme/app_theme.dart';
import 'package:ngetrack/core/widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFEFECED),
                  AppTheme.pink50,
                  Color(0x14B97980),
                ],
              ),
            ),
          ),

          Center(
            child: GlassCard(
              padding: const EdgeInsets.all(32),
              borderRadius: BorderRadius.circular(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.settings_rounded, size: 48, color: AppTheme.pink900),
                  const SizedBox(height: 16),
                  Text(
                    "Settings Coming Soon",
                    style: AppTheme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We are working hard to bring you more features!",
                    style: AppTheme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
