import 'package:flutter/material.dart';

import '../models/skill.dart';
import '../theme/app_colors.dart';

/// Pastille d'une compétence. Un appui ouvre les actions Modifier/Supprimer.
class SkillChip extends StatelessWidget {
  const SkillChip({super.key, required this.skill, required this.onTap});

  final Skill skill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Material(
      color: AppColors.night,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(skill.name, style: theme.textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}
