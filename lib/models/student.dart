import 'education.dart';
import 'experience.dart';
import 'project.dart';
import 'skill.dart';

/// Le portfolio complet d'un étudiant.
///
/// Chaque étudiant possède SES propres compétences et SES propres projets :
/// c'est ce qui rend les deux portfolios indépendants.
class Student {
  const Student({
    required this.id,
    required this.fullName,
    required this.title,
    required this.bio,
    required this.email,
    required this.phone,
    required this.city,
    required this.education,
    this.githubLogin = '',
    this.linkedinUrl = '',
    this.photoAsset,
    this.accentIndex = 0,
    this.experiences = const [],
    this.skills = const [],
    this.projects = const [],
  });

  final String id;

  // --- Informations personnelles ---
  final String fullName;
  final String title;
  final String bio;
  final String email;
  final String phone;
  final String city;
  final String githubLogin;
  final String linkedinUrl;

  /// Chemin d'une photo dans `assets/images`, ou `null` (on affiche alors
  /// les initiales).
  final String? photoAsset;

  /// Index de la couleur personnelle dans `AppColors.accents`.
  final int accentIndex;

  // --- Informations académiques et parcours ---
  final Education education;
  final List<Experience> experiences;

  // --- Contenu modifiable par le CRUD ---
  final List<Skill> skills;
  final List<Project> projects;

  /// Initiales des deux derniers mots du nom : « Mouhamed Yessine Louati »
  /// donne « YL ». Utilisé quand il n'y a pas de photo.
  String get initials {
    final words = fullName.trim().split(RegExp(r'\s+'));
    final lastTwo = words.length > 2 ? words.sublist(words.length - 2) : words;
    return lastTwo.map((w) => w.isEmpty ? '' : w[0].toUpperCase()).join();
  }

  /// Prénom d'usage (avant-dernier mot) : « Yessine », « Mohamed ».
  String get firstName {
    final words = fullName.trim().split(RegExp(r'\s+'));
    return words.length >= 2 ? words[words.length - 2] : fullName;
  }

  Student copyWith({
    String? fullName,
    String? title,
    String? bio,
    String? email,
    String? phone,
    String? city,
    String? githubLogin,
    String? linkedinUrl,
    int? accentIndex,
    Education? education,
    List<Skill>? skills,
    List<Project>? projects,
  }) =>
      Student(
        id: id,
        fullName: fullName ?? this.fullName,
        title: title ?? this.title,
        bio: bio ?? this.bio,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        city: city ?? this.city,
        githubLogin: githubLogin ?? this.githubLogin,
        linkedinUrl: linkedinUrl ?? this.linkedinUrl,
        photoAsset: photoAsset,
        accentIndex: accentIndex ?? this.accentIndex,
        education: education ?? this.education,
        experiences: experiences,
        skills: skills ?? this.skills,
        projects: projects ?? this.projects,
      );

  /// Sérialise tout le portfolio, listes comprises, en Map JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'title': title,
        'bio': bio,
        'email': email,
        'phone': phone,
        'city': city,
        'githubLogin': githubLogin,
        'linkedinUrl': linkedinUrl,
        'photoAsset': photoAsset,
        'accentIndex': accentIndex,
        'education': education.toJson(),
        'experiences': experiences.map((e) => e.toJson()).toList(),
        'skills': skills.map((s) => s.toJson()).toList(),
        'projects': projects.map((p) => p.toJson()).toList(),
      };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        title: json['title'] as String? ?? '',
        bio: json['bio'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        city: json['city'] as String? ?? '',
        githubLogin: json['githubLogin'] as String? ?? '',
        linkedinUrl: json['linkedinUrl'] as String? ?? '',
        photoAsset: json['photoAsset'] as String?,
        accentIndex: json['accentIndex'] as int? ?? 0,
        education: Education.fromJson(
          json['education'] as Map<String, dynamic>? ?? const {},
        ),
        experiences: _listFrom(json['experiences'], Experience.fromJson),
        skills: _listFrom(json['skills'], Skill.fromJson),
        projects: _listFrom(json['projects'], Project.fromJson),
      );

  /// Convertit une liste JSON en liste d'objets avec la fonction [fromJson]
  /// donnée. Factorise le même code pour les expériences, compétences et
  /// projets (pas de duplication).
  static List<T> _listFrom<T>(
    Object? raw,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      (raw as List? ?? [])
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
}
