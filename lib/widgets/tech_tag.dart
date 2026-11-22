import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Petite étiquette en police mono : technologie, année, statut.
///
/// Sans [color] : étiquette neutre avec bordure.
/// Avec [color] : étiquette teintée (fond léger + texte coloré).
class TechTag extends StatelessWidget {
  const TechTag(this.label, {super.key, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color;
    final style = Theme.of(context).textTheme.labelMedium;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: tint?.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: tint == null ? Border.all(color: AppColors.line) : null,
      ),
      child: Text(label, style: style?.copyWith(color: tint)),
    );
  }
}
