import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Nuancier pour choisir la couleur personnelle de son portfolio.
class AccentPicker extends StatelessWidget {
  const AccentPicker({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall;

    return Wrap(
      spacing: 8,
      runSpacing: 14,
      children: [
        for (var i = 0; i < AppColors.accents.length; i++)
          Semantics(
            button: true,
            selected: i == selectedIndex,
            label: 'Couleur ${AppColors.accents[i].name}',
            child: InkWell(
              onTap: () => onChanged(i),
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 74,
                child: Column(
                  children: [
                    // AnimatedContainer : l'anneau apparaît en douceur.
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accents[i].color,
                        border: Border.all(
                          color: i == selectedIndex
                              ? AppColors.parchment
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: i == selectedIndex
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.ink,
                            )
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppColors.accents[i].name,
                      style: labelStyle?.copyWith(letterSpacing: 0.2),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
