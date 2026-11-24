import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project.dart';
import '../../models/student.dart';
import '../../providers/portfolio_provider.dart';
import '../../routes/app_routes.dart';
import '../../routes/item_form_args.dart';
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
        // Chaque Project de la liste devient une ProjectCard (même idée
        // que `_devices.map(...)` de l'Atelier 7, écrite avec un `for`).
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

  /// Modifier ou supprimer (avec confirmation) : voir [showItemActions].
  void _showActions(BuildContext context, Project project) {
    showItemActions(
      context,
      title: project.title,
      subtitle: '${project.year} · ${project.technologies.join(', ')}',
      onEdit: () => _openForm(context, project),
      confirmTitle: 'Supprimer ce projet ?',
      confirmMessage:
          '« ${project.title} » sera définitivement retiré du portfolio '
          'de ${student.firstName}.',
      onDelete: () => context.read<PortfolioProvider>().deleteProject(
        student.id,
        project.id,
      ),
      deletedMessage: 'Projet « ${project.title} » supprimé',
    );
  }
}
