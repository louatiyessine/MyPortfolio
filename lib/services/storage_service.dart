import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/student.dart';

/// D'où viennent les données des portfolios.
///
/// 1. Les données de DÉPART (Yessine et Mohamed) sont dans le fichier
///    `assets/data/portfolios.json`. Le code Dart ne contient aucune donnée
///    d'étudiant : le même template affiche n'importe quel étudiant du JSON.
/// 2. Les données MODIFIÉES (CRUD) sont enregistrées en JSON dans
///    `shared_preferences`, un stockage clé/valeur qui survit à la fermeture
///    de l'application.
///
/// Les deux utilisent exactement le même format JSON et le même
/// `Student.fromJson`.
class StorageService {
  /// Fichier JSON des données de départ (déclaré dans pubspec.yaml).
  static const String initialDataAsset = 'assets/data/portfolios.json';

  /// Clé unique sous laquelle tout le portfolio est enregistré.
  /// Le suffixe « v1 » permet de changer de format plus tard sans conflit.
  static const String _studentsKey = 'myportfolio.students.v1';

  /// Lit les données de départ dans le fichier JSON de l'application.
  Future<List<Student>> loadInitialStudents() async {
    final text = await rootBundle.loadString(initialDataAsset);
    return _decode(text);
  }

  /// Charge les étudiants enregistrés.
  ///
  /// Retourne `null` s'il n'y a encore rien (premier lancement) ou si les
  /// données sont illisibles : le provider utilisera alors les données de
  /// départ.
  Future<List<Student>?> loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_studentsKey);
    if (text == null) return null;

    try {
      return _decode(text);
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
    final text = jsonEncode(students.map((s) => s.toJson()).toList());
    await prefs.setString(_studentsKey, text);
  }

  /// Texte JSON -> liste de [Student] (`jsonDecode` puis `fromJson`).
  List<Student> _decode(String text) {
    final list = jsonDecode(text) as List;
    return list
        .map((item) => Student.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
