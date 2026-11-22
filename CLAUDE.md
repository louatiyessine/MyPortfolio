# MyPortfolio — contexte pour Claude Code

App Flutter du DS Dev Mobile (GLSI 3, IIT Sfax) : deux portfolios indépendants
(Yessine Louati, Mohamed Chaabouni) dans une seule app. Voir README.md pour le barème
et l'architecture.

## Conventions
- Répondre et commenter en français ; termes techniques en anglais.
- Stack imposée : `provider`, `shared_preferences` + JSON, `http` (API GitHub),
  routes nommées dans `AppRoutes`. Pas de Bloc/Riverpod.
- Un fichier = une responsabilité ; widgets < ~150 lignes ; commentaires « pourquoi ».
- Tout CRUD passe par `PortfolioProvider._updateStudent` (modifie, sauvegarde, notifie).
- Après chaque changement : `dart format lib test`, `flutter analyze` (0 issue), `flutter test`.

## Pièges connus
- Ne jamais modifier un fichier avec `Get-Content`/`Set-Content` de PowerShell 5.1 :
  il corrompt les accents (lecture ANSI). Utiliser les outils d'édition.
- Les onglets du portfolio utilisent `SliverOverlapAbsorber`/`Injector` (voir
  `TabScrollView`) : sinon le contenu passe sous la barre d'onglets.
- `setState(() { ... })` avec accolades quand on affecte un Future.
