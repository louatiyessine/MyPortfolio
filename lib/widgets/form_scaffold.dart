import 'package:flutter/material.dart';

/// Squelette commun aux trois formulaires (profil, compétence, projet) :
/// barre de titre, `Form` avec sa clé, champs défilants et bouton final.
class FormScaffold extends StatelessWidget {
  const FormScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.formKey,
    required this.submitLabel,
    required this.onSubmit,
    required this.children,
    this.isSaving = false,
  });

  final String title;

  /// Rappelle à quel portfolio on touche (« Portfolio de Yessine »).
  final String subtitle;

  /// Clé du `Form` : permet d'appeler `validate()` sur tous les champs.
  final GlobalKey<FormState> formKey;
  final String submitLabel;
  final VoidCallback onSubmit;
  final List<Widget> children;

  /// Pendant l'enregistrement, le bouton est désactivé (pas de double clic).
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            Text(subtitle.toUpperCase(), style: textTheme.labelSmall),
            const SizedBox(height: 20),
            ...children,
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: isSaving ? null : onSubmit,
              icon: isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(submitLabel),
            ),
          ],
        ),
      ),
    );
  }
}
