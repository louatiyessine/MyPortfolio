/// Un projet réalisé par un étudiant.
class Project {
  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    required this.year,
    this.link = '',
    this.inProgress = false,
  });

  final String id;
  final String title;
  final String description;

  /// Technologies utilisées, affichées sous forme d'étiquettes.
  final List<String> technologies;
  final int year;

  /// Lien vers le code (GitHub). Chaîne vide si le projet n'a pas de lien.
  final String link;

  /// `true` si le projet n'est pas terminé (badge « En cours »).
  final bool inProgress;

  bool get hasLink => link.isNotEmpty;

  Project copyWith({
    String? title,
    String? description,
    List<String>? technologies,
    int? year,
    String? link,
    bool? inProgress,
  }) =>
      Project(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        technologies: technologies ?? this.technologies,
        year: year ?? this.year,
        link: link ?? this.link,
        inProgress: inProgress ?? this.inProgress,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'technologies': technologies,
        'year': year,
        'link': link,
        'inProgress': inProgress,
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        // Le JSON renvoie une List<dynamic> : on la convertit en List<String>.
        technologies: List<String>.from(json['technologies'] as List? ?? []),
        year: json['year'] as int,
        link: json['link'] as String? ?? '',
        inProgress: json['inProgress'] as bool? ?? false,
      );
}
