import 'package:flutter/material.dart';

import '../models/experience.dart';
import '../theme/app_colors.dart';

/// Un élément de la frise chronologique du parcours : un point, un trait
/// vertical qui le relie au suivant, puis le contenu.
class ExperienceTile extends StatelessWidget {
  const ExperienceTile({
    super.key,
    required this.experience,
    this.isLast = false,
  });

  final Experience experience;

  /// Le dernier élément n'a pas de trait vers le bas.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    // IntrinsicHeight : la colonne du trait prend la hauteur du texte.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: 3),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.ink,
                    border: Border.all(color: accent, width: 3),
                  ),
                ),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: AppColors.line)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience.period,
                    style: theme.textTheme.labelMedium?.copyWith(color: accent),
                  ),
                  const SizedBox(height: 4),
                  Text(experience.role, style: theme.textTheme.titleMedium),
                  Text(
                    experience.organization,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.parchment.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(experience.description, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
