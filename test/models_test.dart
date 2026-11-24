import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:myportfolio/models/skill.dart';
import 'package:myportfolio/models/student.dart';
import 'package:myportfolio/portfolios/all_portfolios.dart';
import 'package:myportfolio/portfolios/chaabouni_portfolio.dart';
import 'package:myportfolio/portfolios/portfolio.dart';
import 'package:myportfolio/portfolios/yessine_portfolio.dart';
import 'package:myportfolio/providers/portfolio_provider.dart';

/// Vérifie l'interface Portfolio et la sérialisation JSON (base de la
/// persistance).
void main() {
  final students = PortfolioProvider.initialStudents;

  test('Les deux étudiants implémentent la même interface Portfolio', () {
    // Polymorphisme : deux classes différentes, un seul type commun.
    const Portfolio yessine = YessinePortfolio();
    const Portfolio chaabouni = ChaabouniPortfolio();
    expect(allPortfolios, [isA<YessinePortfolio>(), isA<ChaabouniPortfolio>()]);

    // Le même code (toStudent, hérité) sert aux deux.
    expect(yessine.toStudent().fullName, 'Mouhamed Yessine Louati');
    expect(chaabouni.toStudent().fullName, 'Mohamed Chaabouni');
  });

  test('Valeurs par défaut de l’interface : pas de photo ni de GitHub', () {
    final chaabouni = const ChaabouniPortfolio().toStudent();
    expect(chaabouni.photoAsset, isNull);
    expect(chaabouni.githubLogin, isEmpty);
  });

  test('toStudent convertit la Map des compétences en objets Skill', () {
    final yessine = const YessinePortfolio().toStudent();
    final first = yessine.skills.first;
    expect(first.name, 'C');
    expect(first.category, SkillCategory.languages);
    expect(first.id, 'yessine-s0');
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

  test('Les identifiants des données initiales sont uniques', () {
    for (final student in students) {
      final skillIds = student.skills.map((s) => s.id).toSet();
      final projectIds = student.projects.map((p) => p.id).toSet();
      expect(skillIds.length, student.skills.length);
      expect(projectIds.length, student.projects.length);
    }
  });
}
