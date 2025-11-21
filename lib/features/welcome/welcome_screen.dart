import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngetrack/core/theme/app_theme.dart';
import 'package:ngetrack/core/widgets/glass_card.dart';
import 'package:ngetrack/core/widgets/soft_button.dart';
import 'package:ngetrack/features/welcome/widgets/speech_bubble.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
                  Color(0x14B97980), // pink900 8%
                ],
              ),
            ),
          ),

          // PageView
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildPage1(),
              _buildPage2(context),
            ],
          ),

          // Pager Indicator
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppTheme.pink900
                        : AppTheme.pink900.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage1() {
    return Stack(
      children: [
        // Speech Bubble (Centered)
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SpeechBubble(
                  text: "start building better habit today!",
                ),
                const SizedBox(height: 24),
                // Small arrow below bubble
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildPage2(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to",
                style: AppTheme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              GlassCard(
                borderRadius: BorderRadius.circular(50),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/ui/Logo.png',
                      height: 32,
                    ),
                    const SizedBox(width: 12),
                    RichText(
                      text: TextSpan(
                        style: AppTheme.textTheme.displayMedium,
                        children: [
                          const TextSpan(
                            text: "nge",
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text: "Track",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.pink900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 100,
          left: 32,
          right: 32,
          child: SoftButton(
            label: "Swipe to start →",
            onTap: () => context.go('/home'),
          ),
        ),
      ],
    );
  }
}
