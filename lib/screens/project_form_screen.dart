import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../models/student.dart';
import '../providers/portfolio_provider.dart';
import '../routes/item_form_args.dart';
import '../theme/accent_theme.dart';
import '../utils/validators.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/app_text_field.dart';
import '../widgets/form_scaffold.dart';
import '../widgets/student_not_found.dart';
import '../widgets/tech_tag.dart';

/// Formulaire d'AJOUT ou de MODIFICATION d'un projet (C et U du CRUD).
class ProjectFormScreen extends StatefulWidget {
  const ProjectFormScreen({super.key, required this.args});

  final ItemFormArgs<Project> args;

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _year;
  late final TextEditingController _description;
  late final TextEditingController _technologies;
  late final TextEditingController _link;
  late bool _inProgress;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final project = widget.args.item;
    _title = TextEditingController(text: project?.title ?? '');
    _year = TextEditingController(
      text: '${project?.year ?? DateTime.now().year}',
    );
    _description = TextEditingController(text: project?.description ?? '');
    // La liste est éditée sous forme de texte séparé par des virgules.
    _technologies = TextEditingController(
      text: project?.technologies.join(', ') ?? '',
    );
    _link = TextEditingController(text: project?.link ?? '');
    _inProgress = project?.inProgress ?? false;
  }

  @override
  void dispose() {
    for (final controller in [
      _title,
      _year,
      _description,
      _technologies,
      _link,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  /// « Flutter, Dart ,  » -> ['Flutter', 'Dart'] (espaces et vides retirés).
  List<String> get _parsedTechnologies => _technologies.text
      .split(',')
      .map((t) => t.trim())
      .where((t) => t.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    final student = context.read<PortfolioProvider>().studentById(
      widget.args.studentId,
    );
    if (student == null) return const StudentNotFound();

    final isEditing = widget.args.isEditing;
    final technologies = _parsedTechnologies;

    return AccentTheme(
      accentIndex: student.accentIndex,
      child: FormScaffold(
        title: isEditing ? 'Modifier le projet' : 'Nouveau projet',
        subtitle: 'Portfolio de ${student.firstName}',
        formKey: _formKey,
        isSaving: _isSaving,
        submitLabel: isEditing ? 'Enregistrer' : 'Ajouter le projet',
        onSubmit: () => _submit(student),
        children: [
          AppTextField(
            controller: _title,
            label: 'Titre',
            hint: 'ex. MyPortfolio',
            icon: Icons.title_rounded,
            maxLength: 60,
            validator: Validators.required('Le titre', max: 60),
          ),
          AppTextField(
            controller: _year,
            label: 'Année',
            icon: Icons.calendar_today_outlined,
            keyboardType: TextInputType.number,
            validator: Validators.year,
          ),
          AppTextField(
            controller: _description,
            label: 'Description',
            hint: 'Le but du projet et ton rôle',
            icon: Icons.notes_rounded,
            maxLines: 5,
            maxLength: 400,
            validator: Validators.minLength('La description', 10),
          ),
          AppTextField(
            controller: _technologies,
            label: 'Technologies',
            hint: 'Flutter, Dart, Firebase',
            helper: 'Sépare les technologies par des virgules.',
            icon: Icons.layers_outlined,
            // Reconstruit l'écran pour mettre à jour l'aperçu des étiquettes.
            onChanged: (_) => setState(() {}),
            validator: (_) => _parsedTechnologies.isEmpty
                ? 'Indique au moins une technologie.'
                : null,
          ),
          if (technologies.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final tech in technologies) TechTag(tech)],
            ),
            const SizedBox(height: 20),
          ],
          AppTextField(
            controller: _link,
            label: 'Lien du code (facultatif)',
            hint: 'https://github.com/…',
            icon: Icons.link_rounded,
            keyboardType: TextInputType.url,
            validator: Validators.optionalUrl,
          ),
          SwitchListTile(
            value: _inProgress,
            onChanged: (value) => setState(() => _inProgress = value),
            contentPadding: EdgeInsets.zero,
            title: const Text('Projet en cours'),
            subtitle: const Text('Affiche un badge « En cours » sur la carte'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _submit(Student student) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final provider = context.read<PortfolioProvider>();
    final existing = widget.args.item;
    final project = Project(
      // En modification, on garde le même id pour remplacer le bon projet.
      id: existing?.id ?? PortfolioProvider.newId(),
      title: _title.text.trim(),
      description: _description.text.trim(),
      technologies: _parsedTechnologies,
      year: int.parse(_year.text.trim()),
      link: _link.text.trim(),
      inProgress: _inProgress,
    );

    if (existing == null) {
      await provider.addProject(student.id, project);
    } else {
      await provider.updateProject(student.id, project);
    }

    if (!mounted) return;
    showAppSnackBar(
      context,
      existing == null
          ? 'Projet « ${project.title} » ajouté'
          : 'Projet « ${project.title} » modifié',
    );
    Navigator.pop(context);
  }
}
