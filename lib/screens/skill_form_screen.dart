import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/skill.dart';
import '../models/student.dart';
import '../providers/portfolio_provider.dart';
import '../routes/item_form_args.dart';
import '../theme/accent_theme.dart';
import '../utils/validators.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/app_text_field.dart';
import '../widgets/category_picker.dart';
import '../widgets/form_scaffold.dart';
import '../widgets/section_title.dart';
import '../widgets/student_not_found.dart';

/// Formulaire d'AJOUT ou de MODIFICATION d'une compétence (C et U du CRUD).
/// Le mode dépend de `args.item` : null = ajout, sinon modification.
class SkillFormScreen extends StatefulWidget {
  const SkillFormScreen({super.key, required this.args});

  final ItemFormArgs<Skill> args;

  @override
  State<SkillFormScreen> createState() => _SkillFormScreenState();
}

class _SkillFormScreenState extends State<SkillFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late SkillCategory _category;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Pré-remplissage en mode modification.
    final skill = widget.args.item;
    _nameController = TextEditingController(text: skill?.name ?? '');
    _category = skill?.category ?? SkillCategory.languages;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = context.read<PortfolioProvider>().studentById(
      widget.args.studentId,
    );
    if (student == null) return const StudentNotFound();

    final isEditing = widget.args.isEditing;

    return AccentTheme(
      accentIndex: student.accentIndex,
      child: FormScaffold(
        title: isEditing ? 'Modifier la compétence' : 'Nouvelle compétence',
        subtitle: 'Portfolio de ${student.firstName}',
        formKey: _formKey,
        isSaving: _isSaving,
        submitLabel: isEditing ? 'Enregistrer' : 'Ajouter la compétence',
        onSubmit: () => _submit(student),
        children: [
          AppTextField(
            controller: _nameController,
            label: 'Nom de la compétence',
            hint: 'ex. Flutter, Docker, Figma…',
            icon: Icons.bolt_rounded,
            maxLength: 30,
            validator: (value) => _validateName(value, student),
          ),
          const SizedBox(height: 8),
          const SectionTitle('Catégorie', icon: Icons.category_outlined),
          const SizedBox(height: 14),
          CategoryPicker(
            selected: _category,
            onChanged: (category) => setState(() => _category = category),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  /// Obligatoire, 30 caractères max, et pas de doublon dans CE portfolio.
  String? _validateName(String? value, Student student) {
    final error = Validators.required('Le nom', max: 30)(value);
    if (error != null) return error;

    final name = value!.trim().toLowerCase();
    final duplicate = student.skills.any(
      (s) => s.name.toLowerCase() == name && s.id != widget.args.item?.id,
    );
    return duplicate ? 'Cette compétence existe déjà.' : null;
  }

  /// Valide le formulaire, enregistre via le provider puis revient en
  /// arrière avec un message de confirmation.
  Future<void> _submit(Student student) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final provider = context.read<PortfolioProvider>();
    final name = _nameController.text.trim();
    final existing = widget.args.item;

    if (existing == null) {
      final skill = Skill(
        id: PortfolioProvider.newId(),
        name: name,
        category: _category,
      );
      await provider.addSkill(student.id, skill);
    } else {
      final updated = existing.copyWith(name: name, category: _category);
      await provider.updateSkill(student.id, updated);
    }

    if (!mounted) return;
    showAppSnackBar(
      context,
      existing == null
          ? 'Compétence « $name » ajoutée'
          : 'Compétence « $name » modifiée',
    );
    Navigator.pop(context);
  }
}
