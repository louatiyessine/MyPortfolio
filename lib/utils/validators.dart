import 'package:flutter/widgets.dart';

/// Fonctions de validation réutilisées par tous les formulaires.
///
/// Un validator reçoit le texte saisi et retourne :
///   - `null` si la valeur est correcte,
///   - un message d'erreur (affiché sous le champ) sinon.
class Validators {
  Validators._();

  /// Champ obligatoire, avec une longueur maximale facultative.
  static FormFieldValidator<String> required(String fieldName, {int? max}) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) return '$fieldName est obligatoire.';
      if (max != null && text.length > max) {
        return '$max caractères maximum (${text.length} actuellement).';
      }
      return null;
    };
  }

  /// Texte obligatoire d'une longueur minimale (ex. une description).
  static FormFieldValidator<String> minLength(String fieldName, int min) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) return '$fieldName est obligatoire.';
      if (text.length < min) return 'Au moins $min caractères, s’il te plaît.';
      return null;
    };
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return "L'e-mail est obligatoire.";
    final pattern = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
    return pattern.hasMatch(text) ? null : 'Adresse e-mail invalide.';
  }

  /// Numéro : chiffres, espaces et « + » au début (8 chiffres minimum).
  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Le téléphone est obligatoire.';
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (!RegExp(r'^\+?[\d ]+$').hasMatch(text) || digits.length < 8) {
      return 'Numéro invalide (ex. +216 12 345 678).';
    }
    return null;
  }

  /// Année entre 2000 et l'année prochaine.
  static String? year(String? value) {
    final year = int.tryParse(value?.trim() ?? '');
    final max = DateTime.now().year + 1;
    if (year == null) return "L'année est obligatoire (ex. 2026).";
    if (year < 2000 || year > max) return 'Année entre 2000 et $max.';
    return null;
  }

  /// Lien facultatif : vide accepté, sinon il doit commencer par http(s).
  static String? optionalUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    final valid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return valid ? null : 'Lien invalide (doit commencer par https://).';
  }

  /// Identifiant GitHub facultatif : lettres, chiffres et tirets.
  static String? optionalGithubLogin(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final pattern = RegExp(r'^[A-Za-z0-9](?:[A-Za-z0-9-]{0,38})$');
    return pattern.hasMatch(text)
        ? null
        : 'Identifiant invalide : lettres, chiffres et tirets.';
  }
}
