import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/skill.dart';
import '../../models/student.dart';
import '../../providers/portfolio_provider.dart';
import '../../routes/app_routes.dart';
import '../../routes/item_form_args.dart';
import '../../theme/category_icons.dart';
import '../empty_state.dart';
import '../item_actions_sheet.dart';
import '../section_title.dart';
import '../skill_chip.dart';
import 'tab_scroll_view.dart';

/// Onglet « Compétences » : compétences regroupées par catégorie.
/// Lecture (R), modification (U) et suppression (D) du CRUD.
class SkillsTab extends StatelessWidget {
  const SkillsTab({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (student.skills.isEmpty) {
      return TabScrollView(
        storageKey: 'skills-tab',
        emptyState: EmptyState(
          icon: Icons.auto_awesome_outlined,
          title: 'Aucune compétence',
          message: 'Ajoute ta première compétence pour la mettre en valeur.',
          actionLabel: 'Ajouter une compétence',
          onAction: () => _openForm(context),
        ),
      );
    }

    // Regroupe les compétences par catégorie, dans l'ordre de l'enum,
    // en ignorant les catégories vides.
    final groups = {
      for (final category in SkillCategory.values)
        category: student.skills.where((s) => s.category == category).toList(),
    }..removeWhere((_, skills) => skills.isEmpty);

    return TabScrollView(
      storageKey: 'skills-tab',
      children: [
        Text(
          '${student.skills.length} compétences · ${groups.length} domaines',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Touche une compétence pour la modifier ou la supprimer.',
          style: textTheme.bodySmall,
        ),
        for (final entry in groups.entries) ...[
          const SizedBox(height: 28),
          SectionTitle(
            entry.key.label,
            icon: entry.key.icon,
            trailing: Text(
              '${entry.value.length}',
              style: textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in entry.value)
                SkillChip(
                  skill: skill,
                  onTap: () => _showActions(context, skill),
                ),
            ],
          ),
        ],
      ],
    );
  }

  /// Ouvre le formulaire : ajout si [skill] est null, sinon modification.
  void _openForm(BuildContext context, [Skill? skill]) {
    Navigator.pushNamed(
      context,
      AppRoutes.skillForm,
      arguments: ItemFormArgs<Skill>(studentId: student.id, item: skill),
    );
  }

  /// Modifier ou supprimer (avec confirmation) : voir [showItemActions].
  void _showActions(BuildContext context, Skill skill) {
    showItemActions(
      context,
      title: skill.name,
      subtitle: skill.category.label,
      onEdit: () => _openForm(context, skill),
      confirmTitle: 'Supprimer cette compétence ?',
      confirmMessage:
          '« ${skill.name} » sera retirée du portfolio de '
          '${student.firstName}.',
      onDelete: () =>
          context.read<PortfolioProvider>().deleteSkill(student.id, skill.id),
      deletedMessage: 'Compétence « ${skill.name} » supprimée',
    );
  }
}
