import 'package:flutter/material.dart';

import 'empty_state.dart';

/// Écran de secours si l'étudiant demandé n'existe pas (id inconnu).
/// Évite un crash et propose de revenir en arrière.
class StudentNotFound extends StatelessWidget {
  const StudentNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: EmptyState(
        icon: Icons.person_off_outlined,
        title: 'Portfolio introuvable',
        message: "Cet étudiant n'existe pas ou plus.",
        actionLabel: 'Retour',
        onAction: () => Navigator.pop(context),
      ),
    );
  }
}
