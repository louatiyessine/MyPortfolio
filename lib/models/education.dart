/// Informations académiques d'un étudiant (établissement, formation, diplôme).
class Education {
  const Education({
    required this.establishment,
    required this.program,
    required this.diploma,
    required this.period,
  });

  final String establishment;

  /// Formation suivie, ex. « Licence en informatique — 3e année ».
  final String program;
  final String diploma;

  /// Période en texte libre, ex. « 2024 – 2027 (prévu) ».
  final String period;

  Education copyWith({
    String? establishment,
    String? program,
    String? diploma,
    String? period,
  }) => Education(
    establishment: establishment ?? this.establishment,
    program: program ?? this.program,
    diploma: diploma ?? this.diploma,
    period: period ?? this.period,
  );

  Map<String, dynamic> toJson() => {
    'establishment': establishment,
    'program': program,
    'diploma': diploma,
    'period': period,
  };

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    establishment: json['establishment'] as String? ?? '',
    program: json['program'] as String? ?? '',
    diploma: json['diploma'] as String? ?? '',
    period: json['period'] as String? ?? '',
  );
}
