import 'package:flutter/foundation.dart';

import '../models/project.dart';
import '../models/skill.dart';
import '../models/student.dart';
import '../services/storage_service.dart';

/// Cerveau de l'application : contient les deux portfolios en mémoire.
///
/// Les écrans lisent les données ici (`context.watch`) et appellent ses
/// méthodes pour le CRUD. Après chaque changement :
///   1. la liste en mémoire est remplacée,
///   2. elle est enregistrée sur l'appareil ([StorageService]),
///   3. `notifyListeners()` demande aux écrans abonnés de se reconstruire.
class PortfolioProvider extends ChangeNotifier {
  PortfolioProvider(this._storage);

  final StorageService _storage;

  List<Student> _students = [];
  bool _isLoading = true;

  /// Liste en lecture seule : on ne peut la modifier QUE via les méthodes
  /// ci-dessous, ce qui garantit que chaque changement est sauvegardé.
  List<Student> get students => List.unmodifiable(_students);

  bool get isLoading => _isLoading;

  /// Retourne l'étudiant correspondant à [id], ou `null` s'il n'existe pas.
  Student? studentById(String id) {
    for (final student in _students) {
      if (student.id == id) return student;
    }
    return null;
  }

  /// Génère un identifiant unique basé sur l'heure (en microsecondes).
  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  // -------------------------------------------------------------------------
  // Chargement
  // -------------------------------------------------------------------------

  /// Charge les données au démarrage : les données sauvegardées si elles
  /// existent, sinon (premier lancement) le fichier JSON de départ
  /// `assets/data/portfolios.json`, qu'on enregistre aussitôt.
  Future<void> load() async {
    final saved = await _storage.loadStudents();
    if (saved == null || saved.isEmpty) {
      _students = await _storage.loadInitialStudents();
      await _storage.saveStudents(_students);
    } else {
      _students = saved;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Remet les portfolios du fichier JSON de départ (utile en démo).
  Future<void> resetToDefaults() async {
    _students = await _storage.loadInitialStudents();
    await _storage.saveStudents(_students);
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // CRUD : profil
  // -------------------------------------------------------------------------

  /// Remplace les informations personnelles et académiques d'un étudiant.
  Future<void> updateProfile(Student updated) =>
      _updateStudent(updated.id, (_) => updated);

  // -------------------------------------------------------------------------
  // CRUD : compétences
  // -------------------------------------------------------------------------

  Future<void> addSkill(String studentId, Skill skill) => _updateStudent(
    studentId,
    (s) => s.copyWith(skills: [...s.skills, skill]),
  );

  Future<void> updateSkill(String studentId, Skill skill) => _updateStudent(
    studentId,
    (s) => s.copyWith(skills: _replaceById(s.skills, skill, (k) => k.id)),
  );

  Future<void> deleteSkill(String studentId, String skillId) => _updateStudent(
    studentId,
    (s) => s.copyWith(skills: s.skills.where((k) => k.id != skillId).toList()),
  );

  // -------------------------------------------------------------------------
  // CRUD : projets
  // -------------------------------------------------------------------------

  /// Le nouveau projet est placé en tête de liste : le plus récent d'abord.
  Future<void> addProject(String studentId, Project project) => _updateStudent(
    studentId,
    (s) => s.copyWith(projects: [project, ...s.projects]),
  );

  Future<void> updateProject(String studentId, Project project) =>
      _updateStudent(
        studentId,
        (s) => s.copyWith(
          projects: _replaceById(s.projects, project, (p) => p.id),
        ),
      );

  Future<void> deleteProject(String studentId, String projectId) =>
      _updateStudent(
        studentId,
        (s) => s.copyWith(
          projects: s.projects.where((p) => p.id != projectId).toList(),
        ),
      );

  // -------------------------------------------------------------------------
  // Outils internes (évitent de répéter le même code dans chaque méthode)
  // -------------------------------------------------------------------------

  /// Applique [change] à l'étudiant [studentId], sauvegarde, puis prévient
  /// les écrans. Toutes les méthodes CRUD passent par ici.
  Future<void> _updateStudent(
    String studentId,
    Student Function(Student current) change,
  ) async {
    _students = [
      for (final student in _students)
        student.id == studentId ? change(student) : student,
    ];
    await _storage.saveStudents(_students);
    notifyListeners();
  }

  /// Retourne une nouvelle liste où l'élément ayant le même id que
  /// [updated] est remplacé. Fonctionne pour les compétences ET les projets
  /// grâce au type générique `T`.
  static List<T> _replaceById<T>(
    List<T> items,
    T updated,
    String Function(T item) idOf,
  ) => [for (final item in items) idOf(item) == idOf(updated) ? updated : item];
}
