import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/portfolio_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/home_hero.dart';
import '../widgets/mosaic_background.dart';
import '../widgets/section_title.dart';
import '../widgets/student_card.dart';

/// Écran d'accueil : présente le binôme et donne accès aux deux portfolios.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // `watch` : l'écran se reconstruit quand le provider change
    // (fin du chargement, compteurs modifiés...).
    final provider = context.watch<PortfolioProvider>();
    final students = provider.students;

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final accents = [
      for (final s in students) AppColors.accentAt(s.accentIndex),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 460,
            child: MosaicBackground(color: accents.first, opacity: 0.09),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Row(
                  children: [
                    const Eyebrow('GLSI 3 · IIT Sfax · 2026'),
                    const Spacer(),
                    _MoreMenu(onReset: () => _resetData(context)),
                  ],
                ),
                const SizedBox(height: 28),
                HomeHero(
                  gradientColors: accents.length > 1
                      ? accents
                      : [...accents, ...accents],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    const Eyebrow('Le binôme'),
                    const Spacer(),
                    Eyebrow(students.length.toString().padLeft(2, '0')),
                  ],
                ),
                const SizedBox(height: 14),
                for (var i = 0; i < students.length; i++) ...[
                  StudentCard(student: students[i], index: i + 1),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 12),
                const Center(
                  child: Eyebrow('Projet DS · Développement mobile'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Remet les données des CV après confirmation (pratique pour une démo).
  Future<void> _resetData(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Réinitialiser les portfolios ?',
      message:
          'Toutes les modifications seront effacées et les données '
          'des CV seront restaurées.',
      confirmLabel: 'Réinitialiser',
    );
    if (!confirmed || !context.mounted) return;
    await context.read<PortfolioProvider>().resetToDefaults();
    if (context.mounted) showAppSnackBar(context, 'Portfolios réinitialisés');
  }
}

/// Menu « ⋮ » en haut à droite de l'accueil.
class _MoreMenu extends StatelessWidget {
  const _MoreMenu({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<void>(
      tooltip: 'Options',
      icon: const Icon(Icons.more_vert_rounded, color: AppColors.sand),
      color: AppColors.night,
      itemBuilder: (_) => [
        PopupMenuItem(
          onTap: onReset,
          child: const Row(
            children: [
              Icon(Icons.restart_alt_rounded, color: AppColors.sand),
              SizedBox(width: 12),
              Text('Réinitialiser les données'),
            ],
          ),
        ),
      ],
    );
  }
}
