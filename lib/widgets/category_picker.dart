import 'package:flutter/material.dart';

import '../models/skill.dart';
import '../theme/app_colors.dart';
import '../theme/category_icons.dart';

/// Choix de la catégorie d'une compétence sous forme de pastilles
/// (une seule sélectionnée à la fois).
class CategoryPicker extends StatelessWidget {
  const CategoryPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final SkillCategory selected;
  final ValueChanged<SkillCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final category in SkillCategory.values)
          ChoiceChip(
            selected: category == selected,
            onSelected: (_) => onChanged(category),
            showCheckmark: false,
            avatar: Icon(
              category.icon,
              size: 18,
              color: category == selected ? AppColors.ink : accent,
            ),
            label: Text(category.label),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: category == selected ? AppColors.ink : AppColors.parchment,
            ),
            selectedColor: accent,
            backgroundColor: AppColors.night,
            side: BorderSide(
              color: category == selected ? accent : AppColors.line,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          ),
      ],
    );
  }
}
