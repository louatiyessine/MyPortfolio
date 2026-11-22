import 'package:flutter/material.dart';

import '../../models/student.dart';
import '../contact_card.dart';
import '../education_card.dart';
import '../experience_tile.dart';
import '../github_cta_card.dart';
import '../section_title.dart';
import '../stats_strip.dart';
import 'tab_scroll_view.dart';

/// Onglet « Profil » : informations personnelles, académiques et parcours.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final experiences = student.experiences;

    return TabScrollView(
      storageKey: 'profile-tab',
      children: [
        StatsStrip(student: student),
        const SizedBox(height: 28),
        const SectionTitle('À propos', icon: Icons.person_outline_rounded),
        const SizedBox(height: 12),
        Text(student.bio, style: textTheme.bodyLarge),
        const SizedBox(height: 32),
        const SectionTitle('Coordonnées', icon: Icons.alternate_email_rounded),
        const SizedBox(height: 14),
        ContactCard(student: student),
        const SizedBox(height: 32),
        const SectionTitle('Formation', icon: Icons.school_outlined),
        const SizedBox(height: 14),
        EducationCard(education: student.education),
        if (experiences.isNotEmpty) ...[
          const SizedBox(height: 32),
          const SectionTitle('Parcours', icon: Icons.timeline_rounded),
          const SizedBox(height: 18),
          for (var i = 0; i < experiences.length; i++)
            ExperienceTile(
              experience: experiences[i],
              isLast: i == experiences.length - 1,
            ),
        ],
        const SizedBox(height: 32),
        GithubCtaCard(student: student),
      ],
    );
  }
}
