/// Une expérience (stage, responsabilité associative, compétition).
/// Affichée sous forme de frise chronologique dans l'onglet Profil.
class Experience {
  const Experience({
    required this.role,
    required this.organization,
    required this.period,
    required this.description,
  });

  final String role;
  final String organization;
  final String period;
  final String description;

  Map<String, dynamic> toJson() => {
        'role': role,
        'organization': organization,
        'period': period,
        'description': description,
      };

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
        role: json['role'] as String? ?? '',
        organization: json['organization'] as String? ?? '',
        period: json['period'] as String? ?? '',
        description: json['description'] as String? ?? '',
      );
}
