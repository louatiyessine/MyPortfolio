import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme.dart';

/// Applique une couleur d'accent à tout ce qui est en dessous dans l'arbre
/// des widgets.
///
/// Exemple : dans le portfolio de Yessine, les boutons sont Safran ; dans
/// celui de Mohamed, ils sont Menthe. Aucun écran n'a besoin de le gérer.
/// Dans le formulaire de profil, la couleur change en direct quand on en
/// choisit une nouvelle.
class AccentTheme extends StatelessWidget {
  const AccentTheme({
    super.key,
    required this.accentIndex,
    required this.child,
  });

  /// Index dans `AppColors.accents` (souvent `student.accentIndex`).
  final int accentIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentAt(accentIndex);
    return Theme(data: AppTheme.build(accent), child: child);
  }
}
