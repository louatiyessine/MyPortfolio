import 'package:flutter/material.dart';

import '../models/student.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'stats_strip.dart';
import 'student_avatar.dart';

/// Carte d'un étudiant sur l'écran d'accueil. Un appui ouvre son portfolio
/// via la route nommée [AppRoutes.portfolio], avec son id en argument.
class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student, required this.index});

  final Student student;

  /// Numéro affiché en filigrane (« 01 », « 02 »).
  final int index;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = AppColors.accentAt(student.accentIndex);

    return Material(
      color: AppColors.dusk,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: accent.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.portfolio,
          arguments: student.id,
        ),
        child: Ink(
          // Lueur de la couleur d'accent dans le coin supérieur gauche.
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accent.withValues(alpha: 0.20), Colors.transparent],
              stops: const [0, 0.65],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StudentAvatar(student: student, size: 72),
                    const Spacer(),
                    Text(
                      index.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontFamily: AppTheme.displayFont,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        fontSize: 44,
                        color: accent.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(student.fullName, style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(student.title, style: textTheme.bodyMedium),
                const SizedBox(height: 20),
                StatsStrip(student: student),
                const SizedBox(height: 20),
                _OpenRow(accent: accent, firstName: student.firstName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ligne « Explorer le portfolio » + flèche ronde.
class _OpenRow extends StatelessWidget {
  const _OpenRow({required this.accent, required this.firstName});

  final Color accent;
  final String firstName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Expanded : le texte passe à la ligne au lieu de déborder sur
        // un petit écran ou avec une grande taille de police.
        Expanded(
          child: Text(
            'Explorer le portfolio de $firstName',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: accent),
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 20,
          backgroundColor: accent,
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.ink,
            size: 20,
          ),
        ),
      ],
    );
  }
}
