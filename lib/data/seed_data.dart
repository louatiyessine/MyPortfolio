import '../models/education.dart';
import '../models/experience.dart';
import '../models/project.dart';
import '../models/skill.dart';
import '../models/student.dart';

/// Données de départ, tirées des CV du binôme.
///
/// Elles ne sont utilisées qu'au PREMIER lancement, quand le stockage local
/// est vide. Ensuite, l'application relit toujours les données enregistrées
/// (y compris les ajouts, modifications et suppressions de l'utilisateur).
class SeedData {
  SeedData._(); // Classe utilitaire : pas d'instance.

  static List<Student> get students => [_yessine, _mohamed];

  /// Construit la liste des compétences à partir d'une Map
  /// catégorie -> noms. Les identifiants sont générés avec un préfixe pour
  /// rester uniques (« y-s0 », « m-s3 », ...).
  static List<Skill> _skills(
    String prefix,
    Map<SkillCategory, List<String>> groups,
  ) {
    final result = <Skill>[];
    groups.forEach((category, names) {
      for (final name in names) {
        result.add(
          Skill(
            id: '$prefix-s${result.length}',
            name: name,
            category: category,
          ),
        );
      }
    });
    return result;
  }

  // ---------------------------------------------------------------------
  // Mouhamed Yessine Louati
  // ---------------------------------------------------------------------
  static final Student _yessine = Student(
    id: 'yessine',
    fullName: 'Mouhamed Yessine Louati',
    title: 'Développeur Full Stack',
    bio:
        "Étudiant en 3e année de licence en informatique à l'IIT Sfax, en "
        'cours de PFE. Je conçois des applications web (PHP, JavaScript, '
        'Angular), desktop (JavaFX) et .NET. Stage d’été 2026 chez Mobelite '
        'Labs : agents IA et automatisations n8n. Trésorier IEEE Computer '
        'Society, habitué à piloter des projets et des événements techniques.',
    email: 'louatiyessine70@gmail.com',
    phone: '+216 58 636 767',
    city: 'Sfax, Tunisie',
    githubLogin: 'louatiyessine',
    linkedinUrl: 'https://www.linkedin.com/in/yessine-louati-047254330/',
    photoAsset: 'assets/images/yessine.jpg',
    accentIndex: 0, // Safran
    education: const Education(
      establishment: 'North American Private University (IIT Sfax)',
      program: "Licence en informatique — 3e année, projet de fin d'études",
      diploma: 'Technicien Supérieur en Informatique',
      period: '2024 – 2027 (prévu)',
    ),
    experiences: const [
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
    ],
    skills: _skills('y', {
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
    }),
    projects: const [
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
    ],
  );

  // ---------------------------------------------------------------------
  // Mohamed Chaabouni
  // ---------------------------------------------------------------------
  static final Student _mohamed = Student(
    id: 'mohamed',
    fullName: 'Mohamed Chaabouni',
    title: 'Génie logiciel & intégration de systèmes',
    bio:
        "Étudiant en 3e année de génie logiciel à l'IIT Sfax, en PFE chez "
        "OliveSoft : migration de flux d'intégration d'entreprise de Boomi "
        'vers n8n. Expérience en développement web full-stack (PHP, ASP.NET '
        'MVC), en applications desktop (JavaFX) et en automatisation de '
        'workflows. Bénévole IEEE, à l’aise en équipe et en Scrum. Objectif : '
        'un cycle ingénieur en architecture logicielle.',
    email: 'mohamedchaabouni23@gmail.com',
    phone: '+216 55 757 503',
    city: 'Sfax, Tunisie',
    accentIndex: 1, // Menthe
    education: const Education(
      establishment: 'North American Private University (NAPU) – IIT Sfax',
      program: 'Licence en informatique — 3e année',
      diploma: "Génie logiciel et systèmes d'information (GLSI)",
      period: '2024 – aujourd’hui',
    ),
    experiences: const [
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
    ],
    skills: _skills('m', {
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
    }),
    projects: const [
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
    ],
  );
}
