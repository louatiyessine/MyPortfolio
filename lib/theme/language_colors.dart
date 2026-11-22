import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Couleurs des langages telles que GitHub les affiche, pour que l'écran
/// des dépôts ressemble à ce que l'on voit sur github.com.
const Map<String, Color> _languageColors = {
  'Python': Color(0xFF3572A5),
  'JavaScript': Color(0xFFF1E05A),
  'TypeScript': Color(0xFF3178C6),
  'Java': Color(0xFFB07219),
  'C++': Color(0xFFF34B7D),
  'C': Color(0xFF555555),
  'C#': Color(0xFF178600),
  'PHP': Color(0xFF4F5D95),
  'Dart': Color(0xFF00B4AB),
  'HTML': Color(0xFFE34C26),
  'CSS': Color(0xFF663399),
  'Kotlin': Color(0xFFA97BFF),
  'Jupyter Notebook': Color(0xFFDA5B0B),
};

/// Couleur d'un langage ; gris neutre s'il est inconnu ou absent.
Color languageColor(String? language) =>
    _languageColors[language] ?? AppColors.mist;
