import 'chaabouni_portfolio.dart';
import 'portfolio.dart';
import 'yessine_portfolio.dart';

/// Tous les portfolios de l'application, vus à travers l'interface
/// [Portfolio] (polymorphisme : la liste ne contient que le type commun).
///
/// Ajouter un étudiant = créer sa classe `extends Portfolio` puis l'ajouter
/// ici. Aucun écran n'est à modifier.
const List<Portfolio> allPortfolios = [
  YessinePortfolio(),
  ChaabouniPortfolio(),
];
