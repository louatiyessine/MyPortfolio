import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:myportfolio/data/seed_data.dart';
import 'package:myportfolio/models/skill.dart';
import 'package:myportfolio/models/student.dart';

/// Vérifie que la sérialisation JSON ne perd aucune information :
/// c'est la base de la persistance.
void main() {
  test('Student : toJson puis fromJson redonne le même portfolio', () {
    final original = SeedData.students.first;

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
    final yessine = SeedData.students[0];
    final mohamed = SeedData.students[1];
    expect(yessine.initials, 'YL');
    expect(yessine.firstName, 'Yessine');
    expect(mohamed.initials, 'MC');
    expect(mohamed.firstName, 'Mohamed');
  });

  test('Les identifiants des données initiales sont uniques', () {
    for (final student in SeedData.students) {
      final skillIds = student.skills.map((s) => s.id).toSet();
      final projectIds = student.projects.map((p) => p.id).toSet();
      expect(skillIds.length, student.skills.length);
      expect(projectIds.length, student.projects.length);
    }
  });
}
