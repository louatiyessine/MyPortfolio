import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_snackbar.dart';
import 'confirm_dialog.dart';

/// Les deux actions possibles sur une compétence ou un projet.
enum ItemAction { edit, delete }

/// Appui sur une compétence ou un projet :
///   1. un panneau du bas propose « Modifier » ou « Supprimer » ;
///   2. Modifier  -> [onEdit] (ouvre le formulaire) ;
///   3. Supprimer -> AlertDialog de confirmation, puis [onDelete] et une
///      SnackBar [deletedMessage].
///
/// Écrit UNE fois, utilisé par l'onglet Compétences ET l'onglet Projets.
Future<void> showItemActions(
  BuildContext context, {
  required String title,
  required String subtitle,
  required VoidCallback onEdit,
  required String confirmTitle,
  required String confirmMessage,
  required Future<void> Function() onDelete,
  required String deletedMessage,
}) async {
  final action = await showModalBottomSheet<ItemAction>(
    context: context,
    builder: (sheetContext) => _ActionsSheet(title: title, subtitle: subtitle),
  );
  if (!context.mounted) return;

  if (action == ItemAction.edit) onEdit();
  if (action != ItemAction.delete) return; // Modifié, ou panneau fermé.

  final confirmed = await showConfirmDialog(
    context,
    title: confirmTitle,
    message: confirmMessage,
  );
  if (!confirmed || !context.mounted) return;

  await onDelete();
  if (context.mounted) showAppSnackBar(context, deletedMessage);
}

/// Contenu du panneau : titre, sous-titre et les deux actions.
class _ActionsSheet extends StatelessWidget {
  const _ActionsSheet({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(title, style: textTheme.titleLarge),
              subtitle: Text(subtitle, style: textTheme.bodySmall),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Modifier'),
              // Le panneau se ferme et renvoie l'action choisie.
              onTap: () => Navigator.pop(context, ItemAction.edit),
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
              onTap: () => Navigator.pop(context, ItemAction.delete),
            ),
          ],
        ),
      ),
    );
  }
}
