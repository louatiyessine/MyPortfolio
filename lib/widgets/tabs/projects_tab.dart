import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project.dart';
import '../../models/student.dart';
import '../../providers/portfolio_provider.dart';
import '../../routes/app_routes.dart';
import '../../routes/item_form_args.dart';
import '../app_snackbar.dart';
import '../confirm_dialog.dart';
import '../empty_state.dart';
import '../item_actions_sheet.dart';
import '../project_card.dart';
import 'tab_scroll_view.dart';

/// Onglet « Projets » : liste des projets, du plus récent au plus ancien
/// (ordre de la liste). Lecture, modification et suppression.
class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    if (student.projects.isEmpty) {
      return TabScrollView(
        storageKey: 'projects-tab',
        emptyState: EmptyState(
          icon: Icons.rocket_launch_outlined,
          title: 'Aucun projet',
          message:
              'Présente ton premier projet : titre, description et '
              'technologies.',
          actionLabel: 'Ajouter un projet',
          onAction: () => _openForm(context),
        ),
      );
    }

    return TabScrollView(
      storageKey: 'projects-tab',
      children: [
        for (final project in student.projects)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: ProjectCard(
              project: project,
              onMore: () => _showActions(context, project),
            ),
          ),
      ],
    );
  }

  /// Ouvre le formulaire : ajout si [project] est null, sinon modification.
  void _openForm(BuildContext context, [Project? project]) {
    Navigator.pushNamed(
      context,
      AppRoutes.projectForm,
      arguments: ItemFormArgs<Project>(studentId: student.id, item: project),
    );
  }

  Future<void> _showActions(BuildContext context, Project project) async {
    final action = await showItemActionsSheet(
      context,
      title: project.title,
      subtitle: '${project.year} · ${project.technologies.join(', ')}',
    );
    if (!context.mounted) return;
    switch (action) {
      case ItemAction.edit:
        _openForm(context, project);
      case ItemAction.delete:
        await _confirmDelete(context, project);
      case null:
        break;
    }
  }

  Future<void> _confirmDelete(BuildContext context, Project project) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Supprimer ce projet ?',
      message:
          '« ${project.title} » sera définitivement retiré du portfolio '
          'de ${student.firstName}.',
    );
    if (!confirmed || !context.mounted) return;

    await context.read<PortfolioProvider>().deleteProject(
      student.id,
      project.id,
    );
    if (context.mounted) {
      showAppSnackBar(context, 'Projet « ${project.title} » supprimé');
    }
  }
}
