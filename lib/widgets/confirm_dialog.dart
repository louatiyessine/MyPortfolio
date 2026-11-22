import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Demande une confirmation avant une action irréversible (suppression).
///
/// Retourne `true` si l'utilisateur confirme, `false` s'il annule ou ferme
/// la boîte de dialogue en touchant à côté.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Supprimer',
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(
        Icons.delete_outline_rounded,
        color: AppColors.danger,
        size: 32,
      ),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.danger,
            minimumSize: const Size(120, 46),
          ),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  // `null` quand on ferme sans choisir : on considère que c'est « non ».
  return confirmed ?? false;
}
