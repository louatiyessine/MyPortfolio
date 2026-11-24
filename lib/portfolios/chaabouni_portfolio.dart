import '../models/education.dart';
import '../models/experience.dart';
import '../models/project.dart';
import '../models/skill.dart';
import 'portfolio.dart';

/// Portfolio de Mohamed Chaabouni : implémente l'interface [Portfolio].
/// Même structure que `YessinePortfolio`, seules les données changent.
///
/// Pas de photo ni d'identifiant GitHub pour l'instant : on garde les
/// valeurs par défaut de l'interface (initiales affichées à la place de la
/// photo). Pour afficher ses dépôts GitHub, il suffit d'ajouter :
///   @override
///   String get githubLogin => 'son-identifiant';
class ChaabouniPortfolio extends Portfolio {
  const ChaabouniPortfolio();

  /// Gardé à 'mohamed' : c'est la clé des données déjà sauvegardées.
  @override
  String get id => 'mohamed';

  @override
  String get fullName => 'Mohamed Chaabouni';

  @override
  String get title => 'Génie logiciel & intégration de systèmes';

  @override
  String get bio =>
      "Étudiant en 3e année de génie logiciel à l'IIT Sfax, en PFE chez "
      "OliveSoft : migration de flux d'intégration d'entreprise de Boomi "
      'vers n8n. Expérience en développement web full-stack (PHP, ASP.NET '
      'MVC), en applications desktop (JavaFX) et en automatisation de '
      'workflows. Bénévole IEEE, à l’aise en équipe et en Scrum. Objectif : '
      'un cycle ingénieur en architecture logicielle.';

  @override
  String get email => 'mohamedchaabouni23@gmail.com';

  @override
  String get phone => '+216 55 757 503';

  @override
  String get city => 'Sfax, Tunisie';

  @override
  int get accentIndex => 1; // Menthe

  @override
  Education get education => const Education(
    establishment: 'North American Private University (NAPU) – IIT Sfax',
    program: 'Licence en informatique — 3e année',
    diploma: "Génie logiciel et systèmes d'information (GLSI)",
    period: '2024 – aujourd’hui',
  );

  @override
  List<Experience> get experiences => const [
    Experience(
      role: 'Stagiaire ingénieur logiciel (PFE)',
      organization: 'OliveSoft',
      period: '2026',
      description:
          'Migration de flux Boomi vers n8n : workflows SFTP '
          '(récupération, transformation, archivage, transfert), mapping '
          'des données avec des Code nodes JavaScript et tests de parité '
          'fonctionnelle.',
    ),
    Experience(
      role: 'Officer & Media Manager',
      organization: 'IEEE Computer Society SBC',
      period: '2025 – 2026',
      description:
          'Réseaux sociaux et contenus promotionnels du club ; '
          "couverture vidéo, communication et logistique de l'événement "
          'CodeCore.',
    ),
    Experience(
      role: 'CASS Challenge — 4e sur 53 équipes',
      organization: 'IEEE TSYP 2025',
      period: '2025',
      description:
          "Contribution à la couche IoT d'un prototype de "
          "récupération d'énergie des vagues : interface matériel–logiciel "
          'et monitoring en temps réel.',
    ),
  ];

  @override
  Map<SkillCategory, List<String>> get skills => const {
    SkillCategory.languages: ['C', 'Python', 'Java', 'JavaScript', 'C#'],
    SkillCategory.web: ['HTML', 'CSS', 'PHP', 'ASP.NET MVC', 'Bootstrap'],
    SkillCategory.mobileDesktop: ['JavaFX'],
    SkillCategory.data: [
      'MySQL',
      'Oracle XE',
      'JDBC',
      'Entity Framework',
      'ADO.NET',
    ],
    SkillCategory.automation: ['n8n', 'Boomi', 'SFTP'],
    SkillCategory.tools: [
      'UML',
      'Scrum',
      'Conception de systèmes',
      'Analyse de données',
      'Git / GitHub',
      'Visual Studio',
      'Canva',
      'Photoshop',
    ],
  };

  @override
  List<Project> get projects => const [
    Project(
      id: 'm-p0',
      title: 'Migration Boomi → n8n',
      description:
          "Reconstruction de flux d'intégration d'entreprise en "
          'workflows n8n : SFTP, transformation des données en JavaScript, '
          'archivage et nettoyage automatiques. Projet de fin d’études chez '
          'OliveSoft.',
      technologies: ['n8n', 'JavaScript', 'SFTP', 'Boomi'],
      year: 2026,
      inProgress: true,
    ),
    Project(
      id: 'm-p1',
      title: 'UniClubs',
      description:
          'Plateforme web full-stack de gestion des clubs '
          'universitaires et de leurs événements : authentification e-mail '
          'et Google OAuth, contrôle d’accès par rôles (RBAC).',
      technologies: ['PHP 8.2', 'MySQL', 'Bootstrap 5'],
      year: 2026,
    ),
    Project(
      id: 'm-p2',
      title: 'School Management System',
      description:
          'Application desktop JavaFX en équipe Scrum de quatre '
          '(Oracle XE via JDBC). Ma part : inscriptions, dossiers étudiants, '
          'administration des niveaux et des classes.',
      technologies: ['Java', 'JavaFX', 'Oracle XE', 'JDBC'],
      year: 2026,
    ),
    Project(
      id: 'm-p3',
      title: 'Application web de gestion',
      description:
          'Application web en architecture MVC, accès aux données '
          'via Entity Framework / ADO.NET et authentification des '
          'utilisateurs.',
      technologies: ['C#', 'ASP.NET MVC', 'Entity Framework', 'ADO.NET'],
      year: 2026,
      inProgress: true,
    ),
  ];
}
