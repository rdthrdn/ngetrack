import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ngetrack/core/theme/app_theme.dart';
import 'package:ngetrack/core/widgets/glass_card.dart';
import 'package:ngetrack/core/widgets/soft_button.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _selectedMode = 0; // 0: 25/5, 1: 50/10, 2: Custom
  bool _isRunning = false;
  int _timeLeft = 25 * 60;
  Timer? _timer;

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeLeft > 0) {
          setState(() {
            _timeLeft--;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
          });
        }
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _timeLeft = _selectedMode == 0 ? 25 * 60 : (_selectedMode == 1 ? 50 * 60 : 30 * 60);
    });
  }

  String get _timerString {
    final minutes = (_timeLeft / 60).floor().toString().padLeft(2, '0');
    final seconds = (_timeLeft % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

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

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  "Pomodoro Timer",
                  style: AppTheme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 32),

                // Toggle
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.white90.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppTheme.glassBorder),
                  ),
                  child: Row(
                    children: [
                      _buildToggleItem("25/5", 0),
                      _buildToggleItem("50/10", 1),
                      _buildToggleItem("Custom", 2),
                    ],
                  ),
                ),
                const Spacer(),

                // Timer Display
                GlassCard(
                  width: 280,
                  height: 280,
                  borderRadius: BorderRadius.circular(140),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _timerString,
                        style: AppTheme.textTheme.displayLarge?.copyWith(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 120,
                        child: LinearProgressIndicator(
                          value: 1 - (_timeLeft / (25 * 60)), // Mock progress base
                          backgroundColor: AppTheme.pink900.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.pink900),
                          minHeight: 4,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: SoftButton(
                          label: "Reset",
                          style: SoftButtonStyle.outline,
                          onTap: _resetTimer,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: SoftButton(
                          label: _isRunning ? "Pause" : "Play",
                          onTap: _toggleTimer,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String label, int index) {
    final isSelected = _selectedMode == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMode = index;
            _resetTimer();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.white90 : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTheme.textTheme.labelLarge?.copyWith(
              color: isSelected ? AppTheme.pink900 : AppTheme.onGlass.withValues(alpha: 0.6),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
