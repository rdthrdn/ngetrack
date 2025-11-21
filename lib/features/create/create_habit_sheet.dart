import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ngetrack/core/providers/habit_provider.dart';
import 'package:ngetrack/core/theme/app_theme.dart';
import 'package:ngetrack/core/widgets/soft_button.dart';
import 'package:ngetrack/core/widgets/soft_text_field.dart';

class CreateHabitSheet extends ConsumerStatefulWidget {
  const CreateHabitSheet({super.key});

  @override
  ConsumerState<CreateHabitSheet> createState() => _CreateHabitSheetState();
}

class _CreateHabitSheetState extends ConsumerState<CreateHabitSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetController = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.pink50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            "Tambahkan Kebiasaan Baru",
            style: AppTheme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),

          // Name Field
          Text(
            "Nama Kebiasaan",
            style: AppTheme.textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          SoftTextField(
            hint: "Contoh: Minum Air",
            controller: _nameController,
          ),
          const SizedBox(height: 20),

          // Target Field
          Text(
            "Target per Hari",
            style: AppTheme.textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          SoftTextField(
            hint: "1",
            keyboardType: TextInputType.number,
            controller: _targetController,
          ),
          const SizedBox(height: 32),

          // Buttons
          Row(
            children: [
              Expanded(
                child: SoftButton(
                  label: "Batal",
                  style: SoftButtonStyle.outline,
                  onTap: () => context.pop(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SoftButton(
                  label: "Simpan",
                  onTap: () {
                    final name = _nameController.text;
                    final target = int.tryParse(_targetController.text) ?? 1;
                    if (name.isNotEmpty) {
                      ref.read(habitProvider.notifier).addHabit(name, target);
                      context.pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
