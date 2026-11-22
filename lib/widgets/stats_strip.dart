import 'package:flutter/material.dart';

import '../models/student.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Bande de trois chiffres clés : compétences, projets, expériences.
/// Les chiffres sont calculés à partir des données : ils changent dès
/// qu'on ajoute ou supprime un élément.
class StatsStrip extends StatelessWidget {
  const StatsStrip({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(value: student.skills.length, label: 'compétences'),
        const _Separator(),
        _Stat(value: student.projects.length, label: 'projets'),
        const _Separator(),
        _Stat(value: student.experiences.length, label: 'expériences'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$value',
            style: const TextStyle(
              fontFamily: AppTheme.displayFont,
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: AppColors.parchment,
            ),
          ),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      margin: const EdgeInsets.only(right: 14),
      color: AppColors.line,
    );
  }
}
