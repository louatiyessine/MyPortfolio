import '../models/education.dart';
import '../models/experience.dart';
import '../models/project.dart';
import '../models/skill.dart';
import '../models/student.dart';

/// L'INTERFACE commune à tous les portfolios de l'application.
///
/// En Dart, une classe `abstract` joue le rôle d'interface :
///   1. on ne peut pas l'instancier (`Portfolio()` est interdit) ;
///   2. elle déclare CE QUE chaque étudiant doit fournir (getters sans corps,
///      obligatoirement redéfinis avec `@override`) ;
///   3. elle contient le code COMMUN, écrit une seule fois ([toStudent]).
///
/// Chaque étudiant a sa propre classe qui ne contient QUE ses données :
///   YessinePortfolio   extends Portfolio
///   ChaabouniPortfolio extends Portfolio
///
/// Le reste de l'application (écrans, onglets, formulaires, stockage) ne
/// connaît que ce contrat : le code est écrit UNE fois et sert aux deux.
/// Ajouter un 3e étudiant = écrire une nouvelle classe, rien d'autre.
abstract class Portfolio {
  const Portfolio();

  // --- Obligatoire : chaque étudiant DOIT fournir ces informations ---

  /// Identifiant stable (sert à retrouver l'étudiant et ses données sauvées).
  String get id;
  String get fullName;
  String get title;
  String get bio;
  String get email;
  String get phone;
  String get city;

  /// Index de sa couleur dans `AppColors.accents` (0 = Safran, 1 = Menthe...).
  int get accentIndex;
  Education get education;
  List<Experience> get experiences;

  /// Compétences rangées par catégorie : plus lisible à écrire qu'une liste
  /// d'objets `Skill`. [toStudent] les convertit.
  Map<SkillCategory, List<String>> get skills;
  List<Project> get projects;

  // --- Facultatif : valeur par défaut, à redéfinir seulement si besoin ---

  String get githubLogin => '';
  String get linkedinUrl => '';

  /// Photo dans `assets/images/`, ou `null` pour afficher les initiales.
  String? get photoAsset => null;

  // --- Code commun (hérité par tous les étudiants, jamais répété) ---

  /// Transforme ce CV en [Student] : l'objet que l'application affiche,
  /// modifie (CRUD) et sauvegarde.
  Student toStudent() => Student(
    id: id,
    fullName: fullName,
    title: title,
    bio: bio,
    email: email,
    phone: phone,
    city: city,
    githubLogin: githubLogin,
    linkedinUrl: linkedinUrl,
    photoAsset: photoAsset,
    accentIndex: accentIndex,
    education: education,
    experiences: experiences,
    skills: _buildSkills(),
    projects: projects,
  );

  /// Map « catégorie -> noms » vers une liste de [Skill] avec un id unique
  /// par compétence (« yessine-s0 », « yessine-s1 »...).
  List<Skill> _buildSkills() {
    final result = <Skill>[];
    skills.forEach((category, names) {
      for (final name in names) {
        result.add(
          Skill(id: '$id-s${result.length}', name: name, category: category),
        );
      }
    });
    return result;
  }
}
