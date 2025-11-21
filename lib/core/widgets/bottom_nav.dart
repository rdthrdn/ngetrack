import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngetrack/core/theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final VoidCallback onAddTap;

  const BottomNav({
    super.key,
    required this.navigationShell,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 80 + MediaQuery.of(context).padding.bottom,
            decoration: BoxDecoration(
              color: AppTheme.white90.withValues(alpha: 0.45),
              border: const Border(
                top: BorderSide(color: AppTheme.glassBorder, width: 1),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
              left: 16,
              right: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: navigationShell.currentIndex == 0,
                  onTap: () => navigationShell.goBranch(0),
                ),
                _NavItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Stats',
                  isSelected: navigationShell.currentIndex == 1,
                  onTap: () => navigationShell.goBranch(1),
                ),
                // Add Button
                GestureDetector(
                  onTap: onAddTap,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.pink900,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.pink900.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 32),
                  ),
                ),
                _NavItem(
                  icon: Icons.timer_rounded,
                  label: 'Pomodoro',
                  isSelected: navigationShell.currentIndex == 2,
                  onTap: () => navigationShell.goBranch(2),
                ),
                _NavItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: navigationShell.currentIndex == 3,
                  onTap: () => navigationShell.goBranch(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppTheme.pink900 : AppTheme.onGlass.withValues(alpha: 0.5),
            size: 28,
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppTheme.pink900,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
