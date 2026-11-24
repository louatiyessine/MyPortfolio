import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/github_repo.dart';
import '../models/student.dart';
import '../providers/portfolio_provider.dart';
import '../routes/app_routes.dart';
import '../services/github_api_service.dart';
import '../theme/accent_theme.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/github_summary.dart';
import '../widgets/repo_card.dart';
import '../widgets/student_not_found.dart';

/// Dépôts GitHub d'un étudiant, récupérés en direct via l'API REST
/// (même principe que la météo de l'Atelier 7).
///
/// Le [FutureBuilder] gère les trois états :
///   1. waiting -> CircularProgressIndicator,
///   2. error   -> message clair + bouton « Réessayer »,
///   3. succès  -> résumé + liste des dépôts.
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

  /// La requête en cours, ou `null` si l'étudiant n'a pas d'identifiant.
  Future<List<GithubRepo>>? _reposFuture;

  /// Pourquoi initState() ? Si on lançait la requête dans build(), elle
  /// serait relancée à chaque reconstruction de l'écran.
  @override
  void initState() {
    super.initState();
    _reposFuture = _fetchRepos();
  }

  /// Envoie la requête GET avec l'identifiant GitHub ACTUEL de l'étudiant.
  Future<List<GithubRepo>>? _fetchRepos() {
    final login =
        context
            .read<PortfolioProvider>()
            .studentById(widget.studentId)
            ?.githubLogin ??
        '';
    return login.isEmpty ? null : _api.fetchRepos(login);
  }

  /// « Réessayer » et « Actualiser » : nouvelle requête.
  /// Accolades obligatoires : avec `=>`, la fonction donnée à setState
  /// renverrait le Future affecté, ce que Flutter interdit.
  void _reload() {
    setState(() {
      _reposFuture = _fetchRepos();
    });
  }

  /// Ouvre le profil pour saisir l'identifiant, puis recharge au retour.
  Future<void> _openProfileForm() async {
    await Navigator.pushNamed(
      context,
      AppRoutes.profileForm,
      arguments: widget.studentId,
    );
    if (mounted) _reload();
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
                onAction: _openProfileForm,
              )
            : FutureBuilder<List<GithubRepo>>(
                future: _reposFuture,
                builder: (context, snapshot) => _buildState(snapshot, student),
              ),
      ),
    );
  }

  /// Choisit l'affichage selon l'état de la requête.
  Widget _buildState(
    AsyncSnapshot<List<GithubRepo>> snapshot,
    Student student,
  ) {
    // 1. Chargement
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Erreur (pas de réseau, compte inconnu, code HTTP != 200...)
    if (snapshot.hasError) {
      final error = snapshot.error;
      return EmptyState(
        icon: Icons.cloud_off_rounded,
        color: AppColors.danger,
        title: 'Impossible de charger les dépôts',
        message: error is GithubApiException
            ? error.message
            : 'Une erreur inattendue est survenue.',
        actionLabel: 'Réessayer',
        onAction: _reload,
      );
    }

    // 3. Succès
    final repos = snapshot.data ?? [];
    if (repos.isEmpty) {
      return const EmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'Aucun dépôt public',
        message: "Ce compte GitHub n'a pas encore de dépôt public.",
      );
    }

    // ListView.builder : crée les cartes à partir de la liste.
    // L'élément 0 est le résumé, les suivants sont les dépôts.
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      itemCount: repos.length + 1,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: index == 0
            ? GithubSummary(login: student.githubLogin, repos: repos)
            : RepoCard(repo: repos[index - 1]),
      ),
    );
  }
}
