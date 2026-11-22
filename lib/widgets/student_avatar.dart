import 'package:flutter/material.dart';

import '../models/student.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Photo ronde de l'étudiant entourée d'un anneau de sa couleur.
/// Sans photo, on affiche ses initiales sur un dégradé.
///
/// Le widget [Hero] fait « voler » l'avatar de la carte de l'accueil
/// jusqu'à l'en-tête du portfolio pendant la navigation.
class StudentAvatar extends StatelessWidget {
  const StudentAvatar({super.key, required this.student, this.size = 64});

  final Student student;
  final double size;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentAt(student.accentIndex);
    final photo = student.photoAsset;

    return Hero(
      tag: 'avatar-${student.id}',
      // Material transparent : garde un style de texte correct pendant le vol.
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(size * 0.05),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accent, width: 2),
          ),
          child: ClipOval(
            child: photo == null
                ? _Initials(student: student, accent: accent, size: size)
                : Image.asset(
                    photo,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo de ${student.fullName}',
                    // Si l'image manque, on retombe sur les initiales.
                    errorBuilder: (_, _, _) =>
                        _Initials(student: student, accent: accent, size: size),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Initiales sur un dégradé de la couleur d'accent.
class _Initials extends StatelessWidget {
  const _Initials({
    required this.student,
    required this.accent,
    required this.size,
  });

  final Student student;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent, Color.lerp(accent, AppColors.ink, 0.45)!],
        ),
      ),
      child: Center(
        child: Text(
          student.initials,
          semanticsLabel: student.fullName,
          style: TextStyle(
            fontFamily: AppTheme.displayFont,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.34,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}
