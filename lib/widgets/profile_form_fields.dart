import 'package:flutter/material.dart';

import '../utils/profile_controllers.dart';
import '../utils/validators.dart';
import 'app_text_field.dart';
import 'section_title.dart';

/// Les champs du formulaire de profil, en trois sections :
/// Identité, Coordonnées et Formation.
class ProfileFormFields extends StatelessWidget {
  const ProfileFormFields({super.key, required this.controllers});

  final ProfileControllers controllers;

  @override
  Widget build(BuildContext context) {
    final c = controllers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ..._section('Identité', Icons.person_outline_rounded),
        AppTextField(
          controller: c.fullName,
          label: 'Nom complet',
          icon: Icons.badge_outlined,
          validator: Validators.required('Le nom', max: 50),
        ),
        AppTextField(
          controller: c.title,
          label: 'Titre',
          hint: 'ex. Développeur Full Stack',
          icon: Icons.work_outline_rounded,
          validator: Validators.required('Le titre', max: 60),
        ),
        AppTextField(
          controller: c.bio,
          label: 'À propos',
          icon: Icons.notes_rounded,
          maxLines: 6,
          maxLength: 500,
          validator: Validators.minLength('La présentation', 20),
        ),
        ..._section('Coordonnées', Icons.alternate_email_rounded),
        AppTextField(
          controller: c.email,
          label: 'E-mail',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
        ),
        AppTextField(
          controller: c.phone,
          label: 'Téléphone',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: Validators.phone,
        ),
        AppTextField(
          controller: c.city,
          label: 'Ville',
          icon: Icons.place_outlined,
          validator: Validators.required('La ville', max: 40),
        ),
        AppTextField(
          controller: c.github,
          label: 'Identifiant GitHub',
          hint: 'ex. louatiyessine',
          helper: "Sert à afficher tes dépôts via l'API GitHub.",
          icon: Icons.terminal_rounded,
          validator: Validators.optionalGithubLogin,
        ),
        AppTextField(
          controller: c.linkedin,
          label: 'Lien LinkedIn (facultatif)',
          icon: Icons.link_rounded,
          keyboardType: TextInputType.url,
          validator: Validators.optionalUrl,
        ),
        ..._section('Formation', Icons.school_outlined),
        AppTextField(
          controller: c.school,
          label: 'Établissement',
          icon: Icons.account_balance_outlined,
          validator: Validators.required("L'établissement"),
        ),
        AppTextField(
          controller: c.program,
          label: 'Formation',
          icon: Icons.menu_book_outlined,
          validator: Validators.required('La formation'),
        ),
        AppTextField(
          controller: c.diploma,
          label: 'Diplôme',
          icon: Icons.workspace_premium_outlined,
          validator: Validators.required('Le diplôme'),
        ),
        AppTextField(
          controller: c.period,
          label: 'Période',
          hint: 'ex. 2024 – 2027',
          icon: Icons.date_range_outlined,
          validator: Validators.required('La période', max: 40),
        ),
      ],
    );
  }

  /// Titre de section précédé d'un espace (évite de répéter 3 lignes).
  List<Widget> _section(String title, IconData icon) => [
    const SizedBox(height: 28),
    SectionTitle(title, icon: icon),
    const SizedBox(height: 16),
  ];
}
