import 'package:flutter/material.dart';

import '../models/education.dart';

/// Carte des informations académiques : établissement, formation, diplôme
/// et période.
class EducationCard extends StatelessWidget {
  const EducationCard({super.key, required this.education});

  final Education education;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: accent.withValues(alpha: 0.14),
                  child: Icon(Icons.school_outlined, color: accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    education.establishment,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _EducationLine(label: 'Formation', value: education.program),
            _EducationLine(label: 'Diplôme', value: education.diploma),
            _EducationLine(label: 'Période', value: education.period),
          ],
        ),
      ),
    );
  }
}

/// Une ligne « LIBELLÉ  valeur » de la carte. Masquée si la valeur est vide.
class _EducationLine extends StatelessWidget {
  const _EducationLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(label.toUpperCase(), style: textTheme.labelSmall),
            ),
          ),
          Expanded(child: Text(value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
