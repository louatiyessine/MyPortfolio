/// Un dépôt public renvoyé par l'API REST de GitHub.
///
/// Seuls les champs utiles à l'affichage sont gardés parmi la centaine que
/// renvoie l'API.
class GithubRepo {
  const GithubRepo({
    required this.name,
    required this.description,
    required this.language,
    required this.stars,
    required this.forks,
    required this.htmlUrl,
    required this.updatedAt,
    this.isFork = false,
  });

  final String name;

  /// Vide si le dépôt n'a pas de description.
  final String description;

  /// Langage principal détecté par GitHub, ou `null`.
  final String? language;
  final int stars;
  final int forks;

  /// Adresse de la page du dépôt sur github.com.
  final String htmlUrl;
  final DateTime updatedAt;
  final bool isFork;

  /// Les clés JSON de GitHub sont en snake_case (`stargazers_count`...).
  factory GithubRepo.fromJson(Map<String, dynamic> json) => GithubRepo(
    name: json['name'] as String,
    description: json['description'] as String? ?? '',
    language: json['language'] as String?,
    stars: json['stargazers_count'] as int? ?? 0,
    forks: json['forks_count'] as int? ?? 0,
    htmlUrl: json['html_url'] as String,
    updatedAt:
        DateTime.tryParse(json['updated_at'] as String? ?? '') ??
        DateTime.now(),
    isFork: json['fork'] as bool? ?? false,
  );
}
