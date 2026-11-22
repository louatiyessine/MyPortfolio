import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../providers/portfolio_provider.dart';
import '../theme/accent_theme.dart';
import '../utils/profile_controllers.dart';
import '../widgets/accent_picker.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/form_scaffold.dart';
import '../widgets/profile_form_fields.dart';
import '../widgets/section_title.dart';
import '../widgets/student_not_found.dart';

/// Modification des informations personnelles et académiques (U du CRUD),
/// et choix de la couleur du portfolio (aperçu en direct).
class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key, required this.studentId});

  final String studentId;

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();

  /// Étudiant au moment de l'ouverture (null s'il n'existe pas).
  Student? _student;

  /// Champs texte pré-remplis (voir ProfileControllers).
  ProfileControllers? _controllers;
  int _accentIndex = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Lecture unique (read) : le formulaire travaille sur une copie locale.
    final student = context.read<PortfolioProvider>().studentById(
      widget.studentId,
    );
    if (student != null) {
      _student = student;
      _controllers = ProfileControllers(student);
      _accentIndex = student.accentIndex;
    }
  }

  @override
  void dispose() {
    _controllers?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = _student;
    final controllers = _controllers;
    if (student == null || controllers == null) return const StudentNotFound();

    // AccentTheme avec la couleur CHOISIE (pas encore enregistrée) :
    // le formulaire change de couleur en direct.
    return AccentTheme(
      accentIndex: _accentIndex,
      child: FormScaffold(
        title: 'Modifier le profil',
        subtitle: 'Portfolio de ${student.firstName}',
        formKey: _formKey,
        isSaving: _isSaving,
        submitLabel: 'Enregistrer le profil',
        onSubmit: () => _submit(student, controllers),
        children: [
          const SectionTitle(
            'Couleur du portfolio',
            icon: Icons.palette_outlined,
          ),
          const SizedBox(height: 16),
          AccentPicker(
            selectedIndex: _accentIndex,
            onChanged: (index) => setState(() => _accentIndex = index),
          ),
          ProfileFormFields(controllers: controllers),
        ],
      ),
    );
  }

  /// Valide, enregistre via le provider, puis revient au portfolio.
  Future<void> _submit(Student student, ProfileControllers controllers) async {
    if (!_formKey.currentState!.validate()) {
      showAppSnackBar(context, 'Corrige les champs en rouge.', isError: true);
      return;
    }
    setState(() => _isSaving = true);

    final updated = controllers.applyTo(student, accentIndex: _accentIndex);
    await context.read<PortfolioProvider>().updateProfile(updated);

    if (!mounted) return;
    showAppSnackBar(context, 'Profil mis à jour');
    Navigator.pop(context);
  }
}
