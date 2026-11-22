import 'package:flutter/material.dart';

import '../models/project.dart';
import '../theme/app_colors.dart';
import '../utils/link_opener.dart';
import 'tech_tag.dart';

/// Carte d'un projet : année, statut, titre, description, technologies et
/// lien vers le code. Le bouton « ⋯ » ouvre les actions Modifier/Supprimer.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, required this.onMore});

  final Project project;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 8, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TechTag('${project.year}', color: accent),
                if (project.inProgress) ...[
                  const SizedBox(width: 8),
                  const TechTag('EN COURS', color: AppColors.parchment),
                ],
                const Spacer(),
                IconButton(
                  tooltip: 'Actions sur « ${project.title} »',
                  icon: const Icon(Icons.more_horiz_rounded),
                  color: AppColors.sand,
                  onPressed: onMore,
                ),
              ],
            ),
            Padding(
              // Marge droite pour compenser le padding réduit (bouton ⋯).
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(project.description, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final tech in project.technologies) TechTag(tech),
                    ],
                  ),
                ],
              ),
            ),
            if (project.hasLink) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 40),
                ),
                onPressed: () => openLink(context, Uri.parse(project.link)),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Voir le code'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
