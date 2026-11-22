import 'package:flutter/material.dart';

import '../models/project.dart';
import '../models/skill.dart';
import '../screens/home_screen.dart';
import '../screens/portfolio_screen.dart';
import '../screens/profile_form_screen.dart';
import '../screens/project_form_screen.dart';
import '../screens/skill_form_screen.dart';
import 'item_form_args.dart';

/// Toutes les routes nommées de l'application, au même endroit.
///
/// On navigue avec `Navigator.pushNamed(context, AppRoutes.xxx,
/// arguments: ...)` et on revient avec `Navigator.pop(context)` (ou la
/// flèche retour), ce qui garde une pile de navigation cohérente :
///   Accueil -> Portfolio -> Formulaire / GitHub -> retour au Portfolio.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String portfolio = '/portfolio';
  static const String profileForm = '/portfolio/profile';
  static const String skillForm = '/portfolio/skill';
  static const String projectForm = '/portfolio/project';
  static const String githubRepos = '/portfolio/github';

  /// Table donnée à `MaterialApp(routes: ...)`.
  /// Chaque écran reçoit ses arguments déjà typés par son constructeur.
  static Map<String, WidgetBuilder> get routes => {
    home: (_) => const HomeScreen(),
    portfolio: _withArgs<String>(
      (studentId) => PortfolioScreen(studentId: studentId),
    ),
    profileForm: _withArgs<String>(
      (studentId) => ProfileFormScreen(studentId: studentId),
    ),
    skillForm: _withArgs<ItemFormArgs<Skill>>(
      (args) => SkillFormScreen(args: args),
    ),
    projectForm: _withArgs<ItemFormArgs<Project>>(
      (args) => ProjectFormScreen(args: args),
    ),
  };

  /// Lit les `arguments` de la route et construit l'écran avec.
  ///
  /// Si l'argument manque ou n'a pas le bon type (par exemple une page
  /// rechargée dans le navigateur), on affiche l'accueil au lieu de planter.
  static WidgetBuilder _withArgs<T>(Widget Function(T args) buildScreen) {
    return (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      return args is T ? buildScreen(args) : const HomeScreen();
    };
  }
}
