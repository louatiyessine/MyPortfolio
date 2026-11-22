import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ligne d'information : icône, petit libellé et valeur (e-mail, téléphone...).
/// Si [onTap] est fourni, la ligne devient cliquable et affiche une flèche.
class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label.toUpperCase(), style: theme.textTheme.labelSmall),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.north_east_rounded,
                size: 18,
                color: AppColors.mist,
              ),
          ],
        ),
      ),
    );
  }
}
