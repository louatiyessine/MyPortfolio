import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/student.dart';

/// Persistance locale des portfolios.
///
/// Principe : la liste des étudiants est convertie en texte JSON
/// (`toJson` + `jsonEncode`) puis rangée dans `shared_preferences`, un petit
/// stockage clé/valeur qui survit à la fermeture de l'application
/// (fichier XML sur Android, NSUserDefaults sur iOS, localStorage sur le web).
/// Au démarrage, on fait le chemin inverse (`jsonDecode` + `fromJson`).
class StorageService {
  /// Clé unique sous laquelle tout le portfolio est enregistré.
  /// Le suffixe « v1 » permet de changer de format plus tard sans conflit.
  static const String _studentsKey = 'myportfolio.students.v1';

  /// Charge les étudiants enregistrés.
  ///
  /// Retourne `null` s'il n'y a encore rien (premier lancement) ou si les
  /// données sont illisibles : le provider utilisera alors les données
  /// initiales.
  Future<List<Student>?> loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_studentsKey);
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((item) => Student.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      // JSON corrompu ou format inattendu : on ne plante pas l'application.
      debugPrint('StorageService: données illisibles ($error)');
      return null;
    }
  }

  /// Enregistre TOUTE la liste des étudiants (appelé après chaque
  /// ajout, modification ou suppression).
  Future<void> saveStudents(List<Student> students) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(students.map((s) => s.toJson()).toList());
    await prefs.setString(_studentsKey, json);
  }
}
