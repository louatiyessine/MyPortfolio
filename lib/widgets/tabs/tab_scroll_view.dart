import 'package:flutter/material.dart';

/// Zone défilante commune aux trois onglets du portfolio.
///
/// Dans un `NestedScrollView` avec un en-tête épinglé, le contenu des
/// onglets passerait SOUS la barre d'onglets. Le `SliverOverlapInjector`
/// ajoute exactement l'espace mesuré par le `SliverOverlapAbsorber` de
/// l'en-tête (voir `PortfolioScreen`). Écrit une seule fois ici, utilisé
/// par les trois onglets.
class TabScrollView extends StatelessWidget {
  const TabScrollView({
    super.key,
    required this.storageKey,
    this.children = const [],
    this.emptyState,
  });

  /// Clé de sauvegarde : chaque onglet garde sa position de défilement.
  final String storageKey;
  final List<Widget> children;

  /// Si fourni, affiché centré dans l'espace restant (liste vide).
  final Widget? emptyState;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey(storageKey),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        if (emptyState != null)
          SliverFillRemaining(hasScrollBody: false, child: emptyState)
        else
          SliverPadding(
            // Marge basse : le dernier élément n'est pas caché par le bouton.
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            sliver: SliverList.list(children: children),
          ),
      ],
    );
  }
}
