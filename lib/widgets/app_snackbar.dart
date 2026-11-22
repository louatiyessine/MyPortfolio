import 'package:flutter/material.dart';

/// Affiche un message de confirmation en bas de l'écran après une action
/// (ajout, modification, suppression).
///
/// On passe par le `ScaffoldMessenger` de l'application : le message reste
/// visible même si on vient de fermer un formulaire avec `Navigator.pop`.
void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final icon = isError ? Icons.error_outline_rounded : Icons.check_circle_rounded;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}
