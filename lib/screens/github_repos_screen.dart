import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/github_repo.dart';
import '../providers/portfolio_provider.dart';
import '../routes/app_routes.dart';
import '../services/github_api_service.dart';
import '../theme/accent_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_view.dart';
import '../widgets/github_summary.dart';
import '../widgets/loading_view.dart';
import '../widgets/repo_card.dart';
import '../widgets/student_not_found.dart';

/// Dépôts GitHub d'un étudiant, récupérés en direct via l'API REST.
///
/// Le [FutureBuilder] gère les trois états demandés :
///   1. chargement -> indicateur circulaire,
///   2. erreur     -> message clair + bouton « Réessayer »,
///   3. données    -> résumé + liste des dépôts.
class GithubReposScreen extends StatefulWidget {
  const GithubReposScreen({super.key, required this.studentId, this.api});

  final String studentId;

  /// Service injectable : les tests passent un faux service.
  final GithubApiService? api;

  @override
  State<GithubReposScreen> createState() => _GithubReposScreenState();
}

class _GithubReposScreenState extends State<GithubReposScreen> {
  late final GithubApiService _api = widget.api ?? GithubApiService();

  /// La requête en cours. Elle est créée UNE fois (pas dans build), sinon
  /// chaque reconstruction de l'écran relancerait un appel réseau.
  Future<List<GithubRepo>>? _reposFuture;

  /// Login utilisé pour la dernière requête.
  String? _login;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Appelé à l'ouverture ET quand le provider change : si l'identifiant
    // GitHub a été modifié dans le profil, on relance la requête.
    final student = Provider.of<PortfolioProvider>(
      context,
    ).studentById(widget.studentId);
    final login = student?.githubLogin ?? '';
    if (login != _login) {
      _login = login;
      _reposFuture = login.isEmpty ? null : _api.fetchRepos(login);
    }
  }

  /// Bouton « Réessayer » et tirer pour rafraîchir : nouvelle requête.
  ///
  /// Accolades obligatoires : avec `=>`, la fonction donnée à setState
  /// renverrait le Future affecté, ce que Flutter interdit.
  void _reload() {
    setState(() {
      _reposFuture = _api.fetchRepos(_login!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = context.watch<PortfolioProvider>().studentById(
      widget.studentId,
    );
    if (student == null) return const StudentNotFound();

    return AccentTheme(
      accentIndex: student.accentIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dépôts GitHub'),
          actions: [
            if (_reposFuture != null)
              IconButton(
                tooltip: 'Actualiser',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: _reload,
              ),
          ],
        ),
        body: _reposFuture == null
            ? EmptyState(
                icon: Icons.terminal_rounded,
                title: 'Aucun identifiant GitHub',
                message:
                    'Ajoute ton identifiant dans le profil pour afficher tes '
                    'dépôts publics.',
                actionLabel: 'Modifier le profil',
                onAction: () => Navigator.pushNamed(
                  context,
                  AppRoutes.profileForm,
                  arguments: student.id,
                ),
              )
            : FutureBuilder<List<GithubRepo>>(
                future: _reposFuture,
                builder: _buildState,
              ),
      ),
    );
  }

  /// Choisit l'affichage selon l'état de la requête.
  Widget _buildState(
    BuildContext context,
    AsyncSnapshot<List<GithubRepo>> snapshot,
  ) {
    // 1. Chargement
    if (snapshot.connectionState != ConnectionState.done) {
      return const LoadingView(message: 'Connexion à GitHub…');
    }

    // 2. Erreur
    if (snapshot.hasError) {
      final error = snapshot.error;
      return ErrorView(
        message: error is GithubApiException
            ? error.message
            : 'Une erreur inattendue est survenue.',
        onRetry: _reload,
      );
    }

    // 3. Données
    final repos = snapshot.data ?? [];
    if (repos.isEmpty) {
      return const EmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'Aucun dépôt public',
        message: "Ce compte GitHub n'a pas encore de dépôt public.",
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _reload();
        try {
          await _reposFuture;
        } catch (_) {
          // L'erreur est déjà affichée par le FutureBuilder.
        }
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        itemCount: repos.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        // L'élément 0 est le résumé, les suivants sont les dépôts.
        itemBuilder: (context, index) => index == 0
            ? GithubSummary(login: _login!, repos: repos)
            : RepoCard(repo: repos[index - 1]),
      ),
    );
  }
}
