import 'package:flutter/material.dart';

/// Titre de section avec une icône dans une pastille de la couleur d'accent.
/// Utilisé dans tous les onglets pour garder la même hiérarchie visuelle.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.icon, this.trailing});

  final String title;
  final IconData? icon;

  /// Widget optionnel aligné à droite (compteur, bouton...).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Row(
      children: [
        if (icon != null) ...[
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: theme.textTheme.titleLarge),
          ),
        ),
        // « ?trailing » : ajouté à la liste seulement s'il n'est pas null.
        ?trailing,
      ],
    );
  }
}

/// Petit sur-titre en majuscules et police mono (« LE BINÔME », « 02 »).
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall;
    return Text(text.toUpperCase(), style: style?.copyWith(color: color));
  }
}
