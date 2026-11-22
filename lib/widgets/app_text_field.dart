import 'package:flutter/material.dart';

/// Champ de formulaire standard de l'application.
///
/// Regroupe les réglages répétés partout (icône, libellé, validation,
/// espacement) : chaque formulaire n'écrit que ce qui change.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.helper,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final String? helper;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  /// Affiche un compteur « 12/60 » sous le champ.
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final multiline = maxLines > 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        keyboardType: multiline ? TextInputType.multiline : keyboardType,
        textInputAction: multiline
            ? TextInputAction.newline
            : TextInputAction.next,
        textCapitalization: TextCapitalization.sentences,
        maxLines: maxLines,
        minLines: multiline ? 3 : 1,
        maxLength: maxLength,
        // L'erreur s'affiche dès que l'utilisateur a touché au champ.
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: helper,
          helperMaxLines: 2,
          alignLabelWithHint: multiline,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
