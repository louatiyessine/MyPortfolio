import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Les deux actions possibles sur une compétence ou un projet.
enum ItemAction { edit, delete }

/// Panneau du bas qui propose « Modifier » ou « Supprimer ».
///
/// Partagé par les compétences et les projets : un seul composant, un seul
/// comportement. Retourne l'action choisie, ou `null` si on ferme le panneau.
Future<ItemAction?> showItemActionsSheet(
  BuildContext context, {
  required String title,
  String? subtitle,
}) {
  return showModalBottomSheet<ItemAction>(
    context: context,
    builder: (sheetContext) {
      final textTheme = Theme.of(sheetContext).textTheme;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(title, style: textTheme.titleLarge),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                  child: Text(subtitle, style: textTheme.bodySmall),
                ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Modifier'),
                onTap: () => Navigator.pop(sheetContext, ItemAction.edit),
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.danger,
                ),
                title: const Text(
                  'Supprimer',
                  style: TextStyle(color: AppColors.danger),
                ),
                onTap: () => Navigator.pop(sheetContext, ItemAction.delete),
              ),
            ],
          ),
        ),
      );
    },
  );
}
