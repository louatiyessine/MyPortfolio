import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/portfolio_provider.dart';
import 'routes/app_routes.dart';
import 'services/storage_service.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

/// Point d'entrée de l'application.
void main() {
  // Nécessaire avant d'utiliser les services de la plateforme.
  WidgetsFlutterBinding.ensureInitialized();

  // Icônes claires dans la barre d'état (fond sombre).
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(
    // Le provider est placé AU-DESSUS de MaterialApp : tous les écrans
    // (toutes les routes) y ont accès. `..load()` lance le chargement des
    // données enregistrées dès la création.
    ChangeNotifierProvider(
      create: (_) => PortfolioProvider(StorageService())..load(),
      child: const MyPortfolioApp(),
    ),
  );
}

/// Racine de l'interface : thème global et table des routes nommées.
class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(AppColors.accents.first.color),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
