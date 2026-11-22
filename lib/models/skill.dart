/// Catégories de compétences proposées dans le formulaire.
///
/// Un `enum` évite les fautes de frappe : on ne peut choisir qu'une valeur
/// prévue. Chaque valeur porte son libellé affiché à l'écran.
enum SkillCategory {
  languages('Langages'),
  web('Web & Backend'),
  mobileDesktop('Mobile & Desktop'),
  data('Données & Bases'),
  automation('IA & Automatisation'),
  tools('Outils & Méthodes');

  const SkillCategory(this.label);

  /// Texte lisible affiché dans l'interface.
  final String label;

  /// Retrouve une catégorie à partir de son nom enregistré en JSON.
  /// Si le nom est inconnu (donnée ancienne ou corrompue), on retombe sur
  /// [SkillCategory.tools] plutôt que de faire planter l'application.
  static SkillCategory fromName(String? name) =>
      SkillCategory.values.asNameMap()[name] ?? SkillCategory.tools;
}

/// Une compétence d'un étudiant (ex. « Flutter » dans « Mobile & Desktop »).
class Skill {
  const Skill({required this.id, required this.name, required this.category});

  /// Identifiant unique : permet de modifier ou supprimer la bonne compétence.
  final String id;
  final String name;
  final SkillCategory category;

  /// Crée une copie en changeant seulement certains champs.
  /// Les objets restent immuables : on remplace au lieu de modifier.
  Skill copyWith({String? name, SkillCategory? category}) => Skill(
    id: id,
    name: name ?? this.name,
    category: category ?? this.category,
  );

  /// Conversion objet Dart -> Map JSON (pour l'enregistrement).
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category.name,
  };

  /// Conversion Map JSON -> objet Dart (au chargement).
  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    id: json['id'] as String,
    name: json['name'] as String,
    category: SkillCategory.fromName(json['category'] as String?),
  );
}
