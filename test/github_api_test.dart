import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportfolio/providers/portfolio_provider.dart';
import 'package:myportfolio/screens/github_repos_screen.dart';
import 'package:myportfolio/services/github_api_service.dart';
import 'package:myportfolio/services/storage_service.dart';
import 'package:myportfolio/utils/time_ago.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Faux dépôt au format exact de l'API GitHub.
Map<String, dynamic> fakeRepo(String name, {String? language}) => {
  'name': name,
  'description': 'Description de $name',
  'language': language,
  'stargazers_count': 3,
  'forks_count': 1,
  'html_url': 'https://github.com/demo/$name',
  'updated_at': '2026-11-01T10:00:00Z',
  'fork': false,
};

/// Service branché sur un faux serveur : aucune vraie requête réseau.
GithubApiService serviceReturning(int status, Object body) => GithubApiService(
  client: MockClient(
    (request) async => http.Response(jsonEncode(body), status),
  ),
);

void main() {
  group('GithubApiService', () {
    test('200 : le JSON est converti en objets GithubRepo', () async {
      final service = serviceReturning(200, [
        fakeRepo('alpha', language: 'Dart'),
        fakeRepo('beta'),
      ]);
      final repos = await service.fetchRepos('demo');
      expect(repos.length, 2);
      expect(repos.first.name, 'alpha');
      expect(repos.first.language, 'Dart');
      expect(repos.first.stars, 3);
      expect(repos.last.language, isNull);
    });

    test('404 : compte inconnu', () async {
      final service = serviceReturning(404, {'message': 'Not Found'});
      expect(
        () => service.fetchRepos('inconnu'),
        throwsA(
          isA<GithubApiException>().having(
            (e) => e.message,
            'message',
            contains('Aucun compte GitHub'),
          ),
        ),
      );
    });

    test('403 : limite de requêtes atteinte', () async {
      final service = serviceReturning(403, {'message': 'rate limit'});
      expect(
        () => service.fetchRepos('demo'),
        throwsA(
          isA<GithubApiException>().having(
            (e) => e.message,
            'message',
            contains('Limite'),
          ),
        ),
      );
    });

    test('Pas de réseau : message clair', () async {
      final service = GithubApiService(
        client: MockClient((_) async => throw http.ClientException('offline')),
      );
      expect(
        () => service.fetchRepos('demo'),
        throwsA(
          isA<GithubApiException>().having(
            (e) => e.message,
            'message',
            contains('Pas de connexion'),
          ),
        ),
      );
    });
  });

  test('timeAgo', () {
    final now = DateTime(2026, 11, 22);
    expect(timeAgo(DateTime(2026, 11, 19), now: now), 'il y a 3 jours');
    expect(timeAgo(DateTime(2026, 8, 22), now: now), 'il y a 3 mois');
    expect(timeAgo(DateTime(2024, 11, 1), now: now), 'il y a 2 ans');
  });

  testWidgets('Écran GitHub : erreur, Réessayer, puis données', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final provider = PortfolioProvider(StorageService());
    await provider.load();

    // 1er appel : pas de réseau. 2e appel : succès.
    var calls = 0;
    final api = GithubApiService(
      client: MockClient((_) async {
        calls++;
        if (calls == 1) throw http.ClientException('offline');
        return http.Response(jsonEncode([fakeRepo('MyPortfolio')]), 200);
      }),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          home: GithubReposScreen(studentId: 'yessine', api: api),
        ),
      ),
    );

    // État 1 : chargement.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // État 2 : erreur avec bouton Réessayer.
    await tester.pumpAndSettle();
    expect(find.textContaining('Pas de connexion'), findsOneWidget);
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    // État 3 : données affichées.
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('@louatiyessine'), findsOneWidget);
  });

  testWidgets('Sans identifiant GitHub : invitation à compléter le profil', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final provider = PortfolioProvider(StorageService());
    await provider.load();
    await provider.updateProfile(
      provider.studentById('mohamed')!.copyWith(githubLogin: ''),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: GithubReposScreen(studentId: 'mohamed')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Aucun identifiant GitHub'), findsOneWidget);
  });
}
