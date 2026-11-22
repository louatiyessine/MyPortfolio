import 'package:flutter/material.dart';

import '../models/student.dart';
import '../routes/app_routes.dart';
import '../utils/link_opener.dart';
import 'info_tile.dart';

/// Carte des coordonnées. Chaque ligne ouvre l'application adaptée :
/// e-mail -> messagerie, téléphone -> composeur, LinkedIn -> navigateur,
/// GitHub -> l'écran des dépôts (appel API REST).
class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      InfoTile(
        icon: Icons.mail_outline_rounded,
        label: 'E-mail',
        value: student.email,
        onTap: () =>
            openLink(context, Uri(scheme: 'mailto', path: student.email)),
      ),
      InfoTile(
        icon: Icons.phone_outlined,
        label: 'Téléphone',
        value: student.phone,
        onTap: () => openLink(
          context,
          // Les espaces sont retirés pour former un numéro valide.
          Uri(scheme: 'tel', path: student.phone.replaceAll(' ', '')),
        ),
      ),
      InfoTile(
        icon: Icons.place_outlined,
        label: 'Ville',
        value: student.city,
      ),
      if (student.linkedinUrl.isNotEmpty)
        InfoTile(
          icon: Icons.work_outline_rounded,
          label: 'LinkedIn',
          value: student.linkedinUrl.replaceFirst(
            RegExp(r'^https?://(www\.)?'),
            '',
          ),
          onTap: () => openLink(context, Uri.parse(student.linkedinUrl)),
        ),
      if (student.githubLogin.isNotEmpty)
        InfoTile(
          icon: Icons.terminal_rounded,
          label: 'GitHub',
          value: '@${student.githubLogin}',
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.githubRepos,
            arguments: student.id,
          ),
        ),
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) const Divider(indent: 70),
            tiles[i],
          ],
        ],
      ),
    );
  }
}
