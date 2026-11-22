import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Grand titre de l'accueil : « My » puis « Portfolio. » en dégradé.
///
/// Le dégradé va de la couleur du 1er étudiant à celle du 2e : si l'un
/// d'eux change sa couleur dans son profil, le titre change aussi.
class HomeHero extends StatelessWidget {
  const HomeHero({super.key, required this.gradientColors});

  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.displaySmall?.copyWith(fontSize: 56);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My', style: titleStyle),
        // ShaderMask peint le texte avec un dégradé au lieu d'une couleur.
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) =>
              LinearGradient(colors: gradientColors).createShader(bounds),
          child: Text(
            'Portfolio.',
            style: titleStyle?.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Deux parcours, une seule app.\n'),
              TextSpan(
                text: "Choisis un portfolio pour l'explorer.",
                style: textTheme.bodyLarge?.copyWith(color: AppColors.sand),
              ),
            ],
          ),
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}
