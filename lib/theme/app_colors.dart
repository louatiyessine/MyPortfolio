import 'package:flutter/material.dart';

/// Une couleur personnelle qu'un étudiant peut choisir pour son portfolio.
class AccentColor {
  const AccentColor(this.name, this.color);

  final String name;
  final Color color;
}

/// Palette « Nuit de Sfax ».
///
/// Un fond bleu nuit (la médina après le coucher du soleil), un texte
/// couleur parchemin, et des couleurs d'accent inspirées de la Tunisie.
/// Chaque étudiant a SA couleur : tout son portfolio s'y adapte.
class AppColors {
  AppColors._(); // Pas d'instance : on n'utilise que les constantes.

  // --- Fonds (du plus sombre au plus clair) ---
  static const Color ink = Color(0xFF0B1120); // fond principal
  static const Color night = Color(0xFF111A2E); // champs, barres
  static const Color dusk = Color(0xFF18233B); // cartes
  static const Color line = Color(0xFF2A3656); // bordures fines

  // --- Textes ---
  static const Color parchment = Color(0xFFF4EDE1); // texte principal
  static const Color sand = Color(0xFFB9C0D2); // texte secondaire
  static const Color mist = Color(0xFF8C95AB); // texte discret

  static const Color danger = Color(0xFFFF6B6B);

  /// Couleurs d'accent. L'ordre compte : `Student.accentIndex` pointe ici.
  static const List<AccentColor> accents = [
    AccentColor('Safran', Color(0xFFFFB547)),
    AccentColor('Menthe', Color(0xFF5EE0B0)),
    AccentColor('Harissa', Color(0xFFFF7A59)),
    AccentColor('Sidi Bou Saïd', Color(0xFF5CB8FF)),
    AccentColor('Figue', Color(0xFFC79BFF)),
    AccentColor('Olive', Color(0xFFB9CF6B)),
  ];

  /// Couleur d'accent sûre : un index hors limites ne fait pas planter.
  static Color accentAt(int index) =>
      accents[index.clamp(0, accents.length - 1)].color;
}
