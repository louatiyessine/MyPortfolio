import 'package:flutter/material.dart';

import '../models/github_repo.dart';
import '../theme/app_colors.dart';
import '../theme/language_colors.dart';
import '../utils/link_opener.dart';
import '../utils/time_ago.dart';

/// Carte d'un dépôt GitHub. Un appui ouvre le dépôt dans le navigateur.
class RepoCard extends StatelessWidget {
  const RepoCard({super.key, required this.repo});

  final GithubRepo repo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openLink(context, Uri.parse(repo.htmlUrl)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    repo.isFork
                        ? Icons.call_split_rounded
                        : Icons.book_outlined,
                    size: 18,
                    color: AppColors.sand,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      repo.name,
                      style: textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.north_east_rounded,
                    size: 18,
                    color: AppColors.mist,
                  ),
                ],
              ),
              if (repo.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  repo.description,
                  style: textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 14),
              // Wrap : les infos passent à la ligne sur un écran étroit.
              Wrap(
                spacing: 16,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (repo.language != null) _LanguageLabel(repo.language!),
                  _Metric(
                    icon: Icons.star_border_rounded,
                    value: '${repo.stars}',
                  ),
                  _Metric(
                    icon: Icons.call_split_rounded,
                    value: '${repo.forks}',
                  ),
                  Text(
                    'Mis à jour ${timeAgo(repo.updatedAt)}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pastille de couleur + nom du langage.
class _LanguageLabel extends StatelessWidget {
  const _LanguageLabel(this.language);

  final String language;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 5, backgroundColor: languageColor(language)),
        const SizedBox(width: 6),
        Text(language, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

/// Icône + nombre (étoiles, forks).
class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.mist),
        const SizedBox(width: 4),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
