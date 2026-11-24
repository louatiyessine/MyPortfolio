import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportfolio/main.dart';
import 'package:myportfolio/providers/portfolio_provider.dart';
import 'package:myportfolio/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests « comme un utilisateur » : on touche l'écran et on vérifie ce qui
/// s'affiche (navigation, formulaire, validation, confirmation, SnackBar).
void main() {
  /// Lance l'application avec un stockage vide et un écran de téléphone.
  Future<void> startApp(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    // runAsync : la lecture du fichier JSON est une vraie lecture disque,
    // que l'horloge simulée des tests de widgets ne ferait pas avancer.
    final provider = PortfolioProvider(StorageService());
    await tester.runAsync(provider.load);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MyPortfolioApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Fait défiler [scrollView] jusqu'à ce que [finder] soit réellement
  /// touchable (ni hors écran, ni caché par l'en-tête ou le bouton
  /// flottant), puis le touche.
  Future<void> scrollAndTap(
    WidgetTester tester,
    Finder finder, {
    required Finder scrollView,
  }) async {
    await tester.scrollUntilVisible(
      finder.hitTestable(),
      120,
      scrollable: find
          .descendant(of: scrollView, matching: find.byType(Scrollable))
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Ouvre le portfolio d'un étudiant puis l'onglet demandé.
  Future<void> openTab(WidgetTester tester, String student, String tab) async {
    await scrollAndTap(
      tester,
      find.text(student),
      scrollView: find.byType(ListView),
    );
    await tester.tap(find.text(tab));
    await tester.pumpAndSettle();
  }

  testWidgets("L'accueil affiche les deux portfolios", (tester) async {
    await startApp(tester);
    expect(find.text('Mouhamed Yessine Louati'), findsOneWidget);
    expect(find.text('Mohamed Chaabouni'), findsOneWidget);
  });

  testWidgets('Ajouter une compétence : validation puis succès', (
    tester,
  ) async {
    await startApp(tester);
    await openTab(tester, 'Mohamed Chaabouni', 'Compétences');

    // Le bouton flottant de l'onglet Compétences ouvre le formulaire.
    await tester.tap(find.text('Compétence'));
    await tester.pumpAndSettle();
    expect(find.text('Nouvelle compétence'), findsOneWidget);

    // Envoi à vide : le validator affiche une erreur.
    await tester.tap(find.text('Ajouter la compétence'));
    await tester.pumpAndSettle();
    expect(find.text('Le nom est obligatoire.'), findsOneWidget);

    // Doublon refusé (JavaFX existe déjà chez Mohamed).
    await tester.enterText(find.byType(TextFormField), 'javafx');
    await tester.tap(find.text('Ajouter la compétence'));
    await tester.pumpAndSettle();
    expect(find.text('Cette compétence existe déjà.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Flutter');
    await tester.tap(find.text('Mobile & Desktop'));
    await tester.tap(find.text('Ajouter la compétence'));
    await tester.pumpAndSettle();

    // Retour au portfolio, SnackBar de confirmation et nouvelle pastille.
    expect(find.text('Nouvelle compétence'), findsNothing);
    expect(find.text('Compétence « Flutter » ajoutée'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
  });

  // Le premier projet de Mohamed est visible sans défiler.
  final firstProjectActions = find.byTooltip(
    'Actions sur « Migration Boomi → n8n »',
  );

  testWidgets('Supprimer un projet après confirmation', (tester) async {
    await startApp(tester);
    await openTab(tester, 'Mohamed Chaabouni', 'Projets');

    await tester.tap(firstProjectActions);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supprimer'));
    await tester.pumpAndSettle();

    // La boîte de dialogue demande confirmation.
    expect(find.text('Supprimer ce projet ?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Supprimer'));
    await tester.pumpAndSettle();

    expect(
      find.text('Projet « Migration Boomi → n8n » supprimé'),
      findsOneWidget,
    );
    expect(firstProjectActions, findsNothing);
  });

  testWidgets('Annuler la suppression ne supprime rien', (tester) async {
    await startApp(tester);
    await openTab(tester, 'Mohamed Chaabouni', 'Projets');

    await tester.tap(firstProjectActions);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supprimer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    expect(firstProjectActions, findsOneWidget);
  });
}
