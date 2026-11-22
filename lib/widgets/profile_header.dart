import 'package:flutter/material.dart';

import '../models/student.dart';
import '../theme/app_colors.dart';
import 'mosaic_background.dart';
import 'student_avatar.dart';

/// Grand en-tête du portfolio : dégradé + motif de la couleur de
/// l'étudiant, avatar, nom, titre et ville.
///
/// Placé dans le `flexibleSpace` du `SliverAppBar` : il se replie quand
/// on fait défiler la page.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.student});

  final Student student;

  /// Espace réservé en bas pour la barre d'onglets.
  static const double tabBarSpace = 64;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = Theme.of(context).colorScheme.primary;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Dégradé vertical : le bas est exactement la couleur du fond, pour
        // une transition invisible avec le contenu.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [accent.withValues(alpha: 0.30), AppColors.ink],
              stops: const [0, 0.92],
            ),
          ),
        ),
        // Halo lumineux dans le coin supérieur droit.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.1,
              colors: [accent.withValues(alpha: 0.28), Colors.transparent],
            ),
          ),
        ),
        MosaicBackground(color: accent, opacity: 0.16),
        Positioned(
          left: 20,
          right: 20,
          bottom: tabBarSpace + 14,
          child: Row(
            children: [
              StudentAvatar(student: student, size: 92),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      student.fullName,
                      style: textTheme.headlineSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.title,
                      style: textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.place_outlined, size: 15, color: accent),
                        const SizedBox(width: 4),
                        Text(student.city, style: textTheme.labelMedium),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
