import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/github_repo.dart';

/// Erreur « lisible » destinée à être affichée telle quelle à l'utilisateur.
class GithubApiException implements Exception {
  const GithubApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Accès à l'API REST publique de GitHub (sans clé, 60 requêtes / heure).
///
/// Requête : GET https://api.github.com/users/{login}/repos
/// Réponse : un tableau JSON de dépôts, converti en objets [GithubRepo].
class GithubApiService {
  /// Le [client] peut être remplacé par un faux client dans les tests.
  GithubApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'https://api.github.com';
  static const Duration _timeout = Duration(seconds: 10);

  /// Récupère les dépôts publics de [login], du plus récent au plus ancien.
  ///
  /// Lève une [GithubApiException] avec un message clair en cas de
  /// problème : pas de réseau, délai dépassé, compte inconnu, limite
  /// atteinte ou réponse inattendue.
  Future<List<GithubRepo>> fetchRepos(String login) async {
    final uri = Uri.parse(
      '$_baseUrl/users/$login/repos',
    ).replace(queryParameters: {'sort': 'updated', 'per_page': '30'});

    final http.Response response;
    try {
      response = await _client
          .get(uri, headers: {'Accept': 'application/vnd.github+json'})
          .timeout(_timeout);
    } on TimeoutException {
      throw const GithubApiException(
        'GitHub met trop de temps à répondre. Réessaie dans un instant.',
      );
    } on http.ClientException {
      // Levée par le package http quand le réseau est inaccessible.
      throw const GithubApiException(
        'Pas de connexion Internet. Vérifie ton réseau puis réessaie.',
      );
    }

    // Tout code différent de 200 est une erreur : on explique laquelle.
    switch (response.statusCode) {
      case 200:
        return _parseRepos(response.body);
      case 404:
        throw GithubApiException('Aucun compte GitHub « $login ».');
      case 403 || 429:
        throw const GithubApiException(
          'Limite de requêtes GitHub atteinte. Réessaie dans quelques minutes.',
        );
      default:
        throw GithubApiException(
          'Le serveur GitHub a répondu avec une erreur '
          '(code ${response.statusCode}).',
        );
    }
  }

  /// Convertit le texte JSON reçu en liste de [GithubRepo].
  List<GithubRepo> _parseRepos(String body) {
    try {
      final data = jsonDecode(body) as List;
      return data
          .map((item) => GithubRepo.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const GithubApiException('Réponse de GitHub inattendue.');
    }
  }
}
