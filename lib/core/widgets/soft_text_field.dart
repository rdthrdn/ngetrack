import 'package:flutter/material.dart';
import 'package:ngetrack/core/theme/app_theme.dart';

class SoftTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const SoftTextField({
    super.key,
    this.hint,
    this.controller,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white90,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFC9BABA),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTheme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.grey,
          ),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
