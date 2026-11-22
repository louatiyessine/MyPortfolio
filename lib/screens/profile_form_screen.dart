import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../providers/portfolio_provider.dart';
import '../theme/accent_theme.dart';
import '../utils/validators.dart';
import '../widgets/accent_picker.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/app_text_field.dart';
import '../widgets/form_scaffold.dart';
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
  Student? _student;
  int _accentIndex = 0;
  bool _isSaving = false;

  // `late` : chaque controller est créé au premier usage, pré-rempli avec
  // la valeur actuelle de l'étudiant.
  late final _fullName = TextEditingController(text: _student?.fullName);
  late final _title = TextEditingController(text: _student?.title);
  late final _bio = TextEditingController(text: _student?.bio);
  late final _email = TextEditingController(text: _student?.email);
  late final _phone = TextEditingController(text: _student?.phone);
  late final _city = TextEditingController(text: _student?.city);
  late final _github = TextEditingController(text: _student?.githubLogin);
  late final _linkedin = TextEditingController(text: _student?.linkedinUrl);
  late final _school = TextEditingController(
    text: _student?.education.establishment,
  );
  late final _program = TextEditingController(
    text: _student?.education.program,
  );
  late final _diploma = TextEditingController(
    text: _student?.education.diploma,
  );
  late final _period = TextEditingController(text: _student?.education.period);

  @override
  void initState() {
    super.initState();
    // Lecture unique (read) : le formulaire travaille sur une copie locale.
    _student = context.read<PortfolioProvider>().studentById(widget.studentId);
    _accentIndex = _student?.accentIndex ?? 0;
  }

  @override
  void dispose() {
    for (final controller in [
      _fullName,
      _title,
      _bio,
      _email,
      _phone,
      _city,
      _github,
      _linkedin,
      _school,
      _program,
      _diploma,
      _period,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = _student;
    if (student == null) return const StudentNotFound();

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
        onSubmit: () => _submit(student),
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
          ..._section('Identité', Icons.person_outline_rounded),
          AppTextField(
            controller: _fullName,
            label: 'Nom complet',
            icon: Icons.badge_outlined,
            validator: Validators.required('Le nom', max: 50),
          ),
          AppTextField(
            controller: _title,
            label: 'Titre',
            hint: 'ex. Développeur Full Stack',
            icon: Icons.work_outline_rounded,
            validator: Validators.required('Le titre', max: 60),
          ),
          AppTextField(
            controller: _bio,
            label: 'À propos',
            icon: Icons.notes_rounded,
            maxLines: 6,
            maxLength: 500,
            validator: Validators.minLength('La présentation', 20),
          ),
          ..._section('Coordonnées', Icons.alternate_email_rounded),
          AppTextField(
            controller: _email,
            label: 'E-mail',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          AppTextField(
            controller: _phone,
            label: 'Téléphone',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: Validators.phone,
          ),
          AppTextField(
            controller: _city,
            label: 'Ville',
            icon: Icons.place_outlined,
            validator: Validators.required('La ville', max: 40),
          ),
          AppTextField(
            controller: _github,
            label: 'Identifiant GitHub',
            hint: 'ex. louatiyessine',
            helper: "Sert à afficher tes dépôts via l'API GitHub.",
            icon: Icons.terminal_rounded,
            validator: Validators.optionalGithubLogin,
          ),
          AppTextField(
            controller: _linkedin,
            label: 'Lien LinkedIn (facultatif)',
            icon: Icons.link_rounded,
            keyboardType: TextInputType.url,
            validator: Validators.optionalUrl,
          ),
          ..._section('Formation', Icons.school_outlined),
          AppTextField(
            controller: _school,
            label: 'Établissement',
            icon: Icons.account_balance_outlined,
            validator: Validators.required("L'établissement"),
          ),
          AppTextField(
            controller: _program,
            label: 'Formation',
            icon: Icons.menu_book_outlined,
            validator: Validators.required('La formation'),
          ),
          AppTextField(
            controller: _diploma,
            label: 'Diplôme',
            icon: Icons.workspace_premium_outlined,
            validator: Validators.required('Le diplôme'),
          ),
          AppTextField(
            controller: _period,
            label: 'Période',
            hint: 'ex. 2024 – 2027',
            icon: Icons.date_range_outlined,
            validator: Validators.required('La période', max: 40),
          ),
        ],
      ),
    );
  }

  /// Titre de section précédé d'un espace (évite de répéter 3 lignes).
  List<Widget> _section(String title, IconData icon) => [
    const SizedBox(height: 28),
    SectionTitle(title, icon: icon),
    const SizedBox(height: 16),
  ];

  Future<void> _submit(Student student) async {
    if (!_formKey.currentState!.validate()) {
      showAppSnackBar(context, 'Corrige les champs en rouge.', isError: true);
      return;
    }
    setState(() => _isSaving = true);

    final updated = student.copyWith(
      fullName: _fullName.text.trim(),
      title: _title.text.trim(),
      bio: _bio.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      city: _city.text.trim(),
      githubLogin: _github.text.trim(),
      linkedinUrl: _linkedin.text.trim(),
      accentIndex: _accentIndex,
      education: student.education.copyWith(
        establishment: _school.text.trim(),
        program: _program.text.trim(),
        diploma: _diploma.text.trim(),
        period: _period.text.trim(),
      ),
    );
    await context.read<PortfolioProvider>().updateProfile(updated);

    if (!mounted) return;
    showAppSnackBar(context, 'Profil mis à jour');
    Navigator.pop(context);
  }
}
