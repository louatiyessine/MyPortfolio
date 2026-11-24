import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:myportfolio/models/skill.dart';
import 'package:myportfolio/models/student.dart';
import 'package:myportfolio/services/storage_service.dart';

/// Vérifie le fichier JSON des données de départ et la sérialisation JSON
/// (base de la persistance).
void main() {
  // Nécessaire pour lire un fichier des assets (rootBundle) dans un test.
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<Student> students;
  setUpAll(() async {
    students = await StorageService().loadInitialStudents();
  });

  test('Le fichier JSON contient les données des deux étudiants', () {
    expect(students.map((s) => s.id), ['yessine', 'mohamed']);
    expect(students[0].fullName, 'Mouhamed Yessine Louati');
    expect(students[1].fullName, 'Mohamed Chaabouni');
    expect(students[0].skills.first.category, SkillCategory.languages);
  });

  test('Student : toJson puis fromJson redonne le même portfolio', () {
    final original = students.first;

    // On passe par une vraie chaîne JSON, comme dans shared_preferences.
    final text = jsonEncode(original.toJson());
    final restored = Student.fromJson(jsonDecode(text) as Map<String, dynamic>);

    expect(restored.fullName, original.fullName);
    expect(restored.education.establishment, original.education.establishment);
    expect(restored.skills.length, original.skills.length);
    expect(restored.projects.length, original.projects.length);
    expect(restored.experiences.length, original.experiences.length);
    expect(
      restored.projects.first.technologies,
      original.projects.first.technologies,
    );
    expect(restored.skills.first.category, original.skills.first.category);
  });

  test('SkillCategory.fromName retombe sur "tools" si le nom est inconnu', () {
    expect(SkillCategory.fromName('web'), SkillCategory.web);
    expect(SkillCategory.fromName('inconnu'), SkillCategory.tools);
    expect(SkillCategory.fromName(null), SkillCategory.tools);
  });

  test('Initiales et prénom calculés à partir du nom complet', () {
    final yessine = students[0];
    final mohamed = students[1];
    expect(yessine.initials, 'YL');
    expect(yessine.firstName, 'Yessine');
    expect(mohamed.initials, 'MC');
    expect(mohamed.firstName, 'Mohamed');
  });

  test('Les identifiants des données de départ sont uniques', () {
    for (final student in students) {
      final skillIds = student.skills.map((s) => s.id).toSet();
      final projectIds = student.projects.map((p) => p.id).toSet();
      expect(skillIds.length, student.skills.length);
      expect(projectIds.length, student.projects.length);
    }
  });
}
