import 'package:flutter_test/flutter_test.dart';
import 'package:myportfolio/models/project.dart';
import 'package:myportfolio/models/skill.dart';
import 'package:myportfolio/providers/portfolio_provider.dart';
import 'package:myportfolio/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Teste le CRUD et la persistance sans lancer l'interface.
void main() {
  // Chaque test démarre avec un stockage vide (simulé en mémoire).
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Crée un provider et charge les données, comme au démarrage de l'app.
  Future<PortfolioProvider> startApp() async {
    final provider = PortfolioProvider(StorageService());
    await provider.load();
    return provider;
  }

  test('Premier lancement : les deux portfolios sont créés', () async {
    final provider = await startApp();
    expect(provider.isLoading, isFalse);
    expect(provider.students.length, 2);
    expect(provider.studentById('yessine'), isNotNull);
    expect(provider.studentById('mohamed'), isNotNull);
  });

  test('Une compétence ajoutée survit au « redémarrage »', () async {
    final first = await startApp();
    const skill = Skill(
      id: 'test-skill',
      name: 'Kotlin',
      category: SkillCategory.languages,
    );
    await first.addSkill('yessine', skill);

    // Nouveau provider = l'application a été fermée puis relancée.
    final restarted = await startApp();
    final names = restarted.studentById('yessine')!.skills.map((s) => s.name);
    expect(names, contains('Kotlin'));
  });

  test('Les portfolios sont indépendants', () async {
    final provider = await startApp();
    final before = provider.studentById('mohamed')!.skills.length;

    await provider.addSkill(
      'yessine',
      const Skill(id: 'x', name: 'Rust', category: SkillCategory.languages),
    );

    expect(provider.studentById('mohamed')!.skills.length, before);
  });

  test('Modifier puis supprimer un projet', () async {
    final provider = await startApp();
    final project = provider.studentById('mohamed')!.projects.first;

    await provider.updateProject(
      'mohamed',
      project.copyWith(title: 'Titre modifié'),
    );
    expect(
      provider.studentById('mohamed')!.projects.first.title,
      'Titre modifié',
    );

    await provider.deleteProject('mohamed', project.id);
    final ids = provider.studentById('mohamed')!.projects.map((p) => p.id);
    expect(ids, isNot(contains(project.id)));
  });

  test('Un nouveau projet apparaît en tête de liste', () async {
    final provider = await startApp();
    const project = Project(
      id: 'new',
      title: 'MyPortfolio',
      description: 'Application Flutter du DS.',
      technologies: ['Flutter', 'Dart'],
      year: 2026,
    );
    await provider.addProject('yessine', project);
    expect(provider.studentById('yessine')!.projects.first.id, 'new');
  });

  test('Réinitialiser remet les données des CV', () async {
    final provider = await startApp();
    final initialCount = provider.studentById('yessine')!.skills.length;
    await provider.deleteSkill(
      'yessine',
      provider.studentById('yessine')!.skills.first.id,
    );
    await provider.resetToDefaults();
    expect(provider.studentById('yessine')!.skills.length, initialCount);
  });
}
