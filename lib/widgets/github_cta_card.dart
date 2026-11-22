import 'package:flutter/material.dart';

import '../models/student.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import 'mosaic_background.dart';

/// Carte d'appel à l'action vers l'écran des dépôts GitHub (API REST).
class GithubCtaCard extends StatelessWidget {
  const GithubCtaCard({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final hasLogin = student.githubLogin.isNotEmpty;

    return Material(
      color: accent.withValues(alpha: 0.12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: accent.withValues(alpha: 0.4)),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.githubRepos,
          arguments: student.id,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: MosaicBackground(
                color: accent,
                opacity: 0.12,
                tileSize: 48,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: accent,
                    child: const Icon(
                      Icons.terminal_rounded,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mes dépôts GitHub',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hasLogin
                              ? "En direct via l'API REST de GitHub"
                              : 'Ajoute ton identifiant GitHub pour les afficher',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded, color: accent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
