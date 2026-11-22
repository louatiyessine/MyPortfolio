import 'package:flutter/material.dart';

import '../models/student.dart';
import 'app_colors.dart';
import 'app_theme.dart';

/// Applique la couleur personnelle d'un étudiant à tout ce qui est en
/// dessous dans l'arbre des widgets.
///
/// Exemple : dans le portfolio de Yessine, les boutons sont Safran ; dans
/// celui de Mohamed, ils sont Menthe. Aucun écran n'a besoin de le gérer.
class StudentTheme extends StatelessWidget {
  const StudentTheme({super.key, required this.student, required this.child});

  final Student student;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentAt(student.accentIndex);
    return Theme(data: AppTheme.build(accent), child: child);
  }
}
