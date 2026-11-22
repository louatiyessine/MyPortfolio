import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../models/skill.dart';
import '../models/student.dart';
import '../providers/portfolio_provider.dart';
import '../routes/app_routes.dart';
import '../routes/item_form_args.dart';
import '../theme/app_colors.dart';
import '../theme/student_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/tabs/profile_tab.dart';
import '../widgets/tabs/projects_tab.dart';
import '../widgets/tabs/skills_tab.dart';

/// Portfolio d'UN étudiant, organisé en trois onglets :
/// Profil, Compétences et Projets.
///
/// StatefulWidget car il garde un état local : l'onglet actif, qui
/// détermine le bouton flottant affiché (modifier le profil, ajouter une
/// compétence ou ajouter un projet).
class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key, required this.studentId});

  final String studentId;

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  /// Reconstruit l'écran seulement quand l'onglet change vraiment.
  void _onTabChanged() {
    if (_tabController.index != _currentTab) {
      setState(() => _currentTab = _tabController.index);
    }
  }

  @override
  void dispose() {
    // Toujours libérer un controller pour éviter les fuites de mémoire.
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student =
        context.watch<PortfolioProvider>().studentById(widget.studentId);

    if (student == null) {
      return const Scaffold(
        body: EmptyState(
          icon: Icons.person_off_outlined,
          title: 'Portfolio introuvable',
          message: "Cet étudiant n'existe pas ou plus.",
        ),
      );
    }

    return StudentTheme(
      student: student,
      child: Scaffold(
        body: NestedScrollView(
          // L'absorber mesure la partie de l'en-tête qui reste épinglée ;
          // chaque onglet la réinjecte (voir TabScrollView).
          headerSliverBuilder: (context, _) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: _buildAppBar(context, student),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              ProfileTab(student: student),
              SkillsTab(student: student),
              ProjectsTab(student: student),
            ],
          ),
        ),
        floatingActionButton: _buildFab(student),
      ),
    );
  }

  /// En-tête repliable + barre d'onglets qui reste visible (pinned).
  Widget _buildAppBar(BuildContext context, Student student) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 310,
      backgroundColor: AppColors.ink,
      actions: [
        IconButton(
          tooltip: 'Dépôts GitHub',
          icon: const Icon(Icons.terminal_rounded),
          onPressed: () => Navigator.pushNamed(
            context,
            AppRoutes.githubRepos,
            arguments: student.id,
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: ProfileHeader(student: student),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(ProfileHeader.tabBarSpace),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.night,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.line),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Profil', height: 38),
              Tab(text: 'Compétences', height: 38),
              Tab(text: 'Projets', height: 38),
            ],
          ),
        ),
      ),
    );
  }

  /// Bouton flottant adapté à l'onglet actif.
  /// Un « record » Dart regroupe les trois infos dont on a besoin.
  Widget _buildFab(Student student) {
    final (IconData icon, String label, String route, Object args) =
        switch (_currentTab) {
      0 => (Icons.edit_outlined, 'Modifier le profil', AppRoutes.profileForm,
          student.id),
      1 => (Icons.add_rounded, 'Compétence', AppRoutes.skillForm,
          ItemFormArgs<Skill>(studentId: student.id)),
      _ => (Icons.add_rounded, 'Projet', AppRoutes.projectForm,
          ItemFormArgs<Project>(studentId: student.id)),
    };

    return FloatingActionButton.extended(
      // Une clé différente par onglet déclenche l'animation de changement.
      key: ValueKey(_currentTab),
      onPressed: () => Navigator.pushNamed(context, route, arguments: args),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
