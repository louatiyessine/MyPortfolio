import 'package:flutter/material.dart';

import '../models/github_repo.dart';
import '../theme/app_colors.dart';
import '../theme/language_colors.dart';
import 'mosaic_background.dart';

/// En-tête de l'écran GitHub : identifiant, chiffres clés et répartition
/// des langages, calculés à partir des données reçues de l'API.
class GithubSummary extends StatelessWidget {
  const GithubSummary({super.key, required this.login, required this.repos});

  final String login;
  final List<GithubRepo> repos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final stars = repos.fold<int>(0, (sum, repo) => sum + repo.stars);

    // Nombre de dépôts par langage, du plus fréquent au moins fréquent.
    final counts = <String, int>{};
    for (final repo in repos) {
      final language = repo.language ?? 'Autre';
      counts[language] = (counts[language] ?? 0) + 1;
    }
    final languages = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: MosaicBackground(color: accent, opacity: 0.10, tileSize: 52),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@$login', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  '${repos.length} dépôts publics · $stars étoiles',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                // Barre empilée : chaque segment est proportionnel au nombre
                // de dépôts du langage (flex).
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 10,
                    child: Row(
                      children: [
                        for (final entry in languages)
                          Expanded(
                            flex: entry.value,
                            child: Container(color: languageColor(entry.key)),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    for (final entry in languages)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: languageColor(entry.key),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${entry.key} ${entry.value}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.sand,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
