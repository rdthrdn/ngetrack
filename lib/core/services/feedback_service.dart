import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;

  final AudioPlayer _audioPlayer = AudioPlayer();

  FeedbackService._internal();

  /// Triggers a light haptic impact (good for buttons, toggles)
  Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// Triggers a medium haptic impact (good for success states)
  Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Triggers a heavy haptic impact (good for errors or major actions)
  Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Triggers a selection click (good for scrollers, pickers)
  Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Plays a success sound (requires 'assets/sounds/success.mp3')
  /// If file not found, it fails silently or logs error.
  Future<void> playSuccess() async {
    try {
      // We use 'AssetSource' which looks in 'assets/' by default.
      // So 'sounds/success.mp3' maps to 'assets/sounds/success.mp3'
      await _audioPlayer.play(
        AssetSource('sounds/success.mp3'),
        mode: PlayerMode.lowLatency,
      );
    } catch (e) {
      // Ignore if asset not found to prevent crash
      debugPrint("Audio playback failed: $e");
    }
  }

  /// Plays a click sound
  Future<void> playClick() async {
    try {
      // Use system sound for simple clicks to avoid asset dependency for now
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      debugPrint("System sound failed: $e");
    }
  }
}
