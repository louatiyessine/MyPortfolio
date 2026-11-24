import '../models/education.dart';
import '../models/experience.dart';
import '../models/project.dart';
import '../models/skill.dart';
import 'portfolio.dart';

/// Portfolio de Mouhamed Yessine Louati : implémente l'interface
/// [Portfolio]. Cette classe ne contient QUE des données (tirées du CV) :
/// aucun code d'affichage, tout est partagé avec l'autre étudiant.
///
/// Ces données ne servent qu'au PREMIER lancement (stockage vide) ou après
/// « Réinitialiser ». Ensuite, l'app relit les données sauvegardées.
class YessinePortfolio extends Portfolio {
  const YessinePortfolio();

  @override
  String get id => 'yessine';

  @override
  String get fullName => 'Mouhamed Yessine Louati';

  @override
  String get title => 'Développeur Full Stack';

  @override
  String get bio =>
      "Étudiant en 3e année de licence en informatique à l'IIT Sfax, en "
      'cours de PFE. Je conçois des applications web (PHP, JavaScript, '
      'Angular), desktop (JavaFX) et .NET. Stage d’été 2026 chez Mobelite '
      'Labs : agents IA et automatisations n8n. Trésorier IEEE Computer '
      'Society, habitué à piloter des projets et des événements techniques.';

  @override
  String get email => 'louatiyessine70@gmail.com';

  @override
  String get phone => '+216 58 636 767';

  @override
  String get city => 'Sfax, Tunisie';

  @override
  String get githubLogin => 'louatiyessine';

  @override
  String get linkedinUrl =>
      'https://www.linkedin.com/in/yessine-louati-047254330/';

  @override
  String? get photoAsset => 'assets/images/yessine.jpg';

  @override
  int get accentIndex => 0; // Safran

  @override
  Education get education => const Education(
    establishment: 'North American Private University (IIT Sfax)',
    program: "Licence en informatique — 3e année, projet de fin d'études",
    diploma: 'Technicien Supérieur en Informatique',
    period: '2024 – 2027 (prévu)',
  );

  @override
  List<Experience> get experiences => const [
    Experience(
      role: 'Stagiaire Agents IA & Automatisation',
      organization: 'Mobelite Labs',
      period: '20 juin – 31 juil. 2026',
      description:
          'Application web multi-agents Flask : Gemini 2.5 Flash '
          'avec RAG (ChromaDB), Llama 3.2 local (Ollama) et agent Jira via '
          "l'API REST Atlassian. Résolution de tickets via MCP, workflows "
          'n8n et agent ReAct avec LangGraph.',
    ),
    Experience(
      role: "Président de l'événement CodeCore",
      organization: 'IEEE Computer Society SBC',
      period: '2025',
      description:
          "Organisation complète d'un événement de programmation "
          "compétitive (concours + bootcamp) et gestion d'une équipe "
          'pluridisciplinaire.',
    ),
    Experience(
      role: 'Trésorier',
      organization: 'IEEE Computer Society SBC',
      period: '2024 – aujourd’hui',
      description:
          'Finances du club, recherche de sponsors, budgets et '
          "rapports financiers ; responsable financier de CrackCode 1.0 et "
          "d'ATIC.",
    ),
    Experience(
      role: 'CASS Challenge — 4e sur 53 équipes',
      organization: 'IEEE TSYP 2025',
      period: '2025',
      description:
          "Couche d'intégration IoT d'un prototype de récupération "
          "de l'énergie des vagues : interface matériel-logiciel et "
          'supervision en temps réel.',
    ),
  ];

  @override
  Map<SkillCategory, List<String>> get skills => const {
    SkillCategory.languages: [
      'C',
      'C#',
      'Python',
      'Java',
      'JavaScript',
      'TypeScript',
      'Dart',
    ],
    SkillCategory.web: [
      'HTML / CSS',
      'React',
      'Angular',
      'PHP',
      'ASP.NET MVC',
      'Spring Boot',
      'Flask',
    ],
    SkillCategory.mobileDesktop: ['Flutter', 'JavaFX'],
    SkillCategory.data: [
      'MySQL',
      'Oracle XE',
      'Entity Framework',
      'ADO.NET',
      'ChromaDB',
      'Big Data',
    ],
    SkillCategory.automation: [
      'n8n',
      'LangChain',
      'LangGraph',
      'RAG',
      'MCP',
      'Ollama',
      'Gemini',
    ],
    SkillCategory.tools: [
      'Git',
      'GitHub',
      'Jira',
      'VS Code',
      'Visual Studio',
      'UML',
    ],
  };

  @override
  List<Project> get projects => const [
    Project(
      id: 'y-p0',
      title: "Espace d'agents IA",
      description:
          'Application Flask réunissant trois agents (Gemini + '
          'RAG, Llama local, Jira) avec quatre modes de chat, dont la '
          'comparaison des modèles (tokens, coût) et la résolution de '
          'tickets via MCP. Projet de stage.',
      technologies: [
        'Python',
        'Flask',
        'LangChain',
        'Ollama',
        'ChromaDB',
        'MCP',
        'n8n',
        'Angular',
      ],
      year: 2026,
      link: 'https://github.com/louatiyessine/ai-agents_jira',
    ),
    Project(
      id: 'y-p1',
      title: 'UniClubs',
      description:
          'Plateforme full stack de gestion des clubs '
          'universitaires : connexion e-mail et Google OAuth, rôles '
          'étudiant/admin, clubs et événements, notifications AJAX.',
      technologies: ['PHP 8.2', 'MySQL', 'Bootstrap 5', 'JavaScript'],
      year: 2025,
    ),
    Project(
      id: 'y-p2',
      title: 'Système de gestion scolaire',
      description:
          'Application desktop JavaFX en équipe Scrum de 4 sur '
          'Oracle XE (JDBC). Ma part : connexion, navigation, module de '
          'notes et bulletins (moyennes pondérées, classements).',
      technologies: ['Java', 'JavaFX', 'Oracle XE', 'JDBC'],
      year: 2025,
    ),
    Project(
      id: 'y-p3',
      title: "CASS — Énergie des vagues",
      description:
          'Prototype IoT (4e sur 53 au TSYP 2025) : capteurs, '
          'ESP32 et ESP32-CAM pour la supervision en temps réel et le '
          'contrôle à distance, serveur Python pour le traitement.',
      technologies: ['C++', 'ESP32', 'ESP32-CAM', 'Python'],
      year: 2025,
      link: 'https://github.com/louatiyessine/CASS-Iot-Project',
    ),
    Project(
      id: 'y-p4',
      title: 'Application de gestion ASP.NET MVC',
      description:
          'Application web MVC avec Entity Framework (Code First) '
          "et ADO.NET, intégration d'un template personnalisé et "
          'authentification.',
      technologies: ['C#', 'ASP.NET MVC', 'Entity Framework', 'ADO.NET'],
      year: 2025,
      inProgress: true,
    ),
    Project(
      id: 'y-p5',
      title: 'ShopEase',
      description:
          'Interface e-commerce responsive réalisée pour apprendre '
          'les bases du web : catalogue, panier et commandes.',
      technologies: ['HTML', 'CSS', 'JavaScript'],
      year: 2024,
      link: 'https://github.com/louatiyessine/shopease',
    ),
  ];
}
