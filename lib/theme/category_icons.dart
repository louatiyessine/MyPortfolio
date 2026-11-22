import 'package:flutter/material.dart';

import '../models/skill.dart';

/// Associe une icône à chaque catégorie de compétence.
///
/// C'est une « extension » : on ajoute la propriété `icon` à l'enum
/// [SkillCategory] sans mettre de code d'interface dans le modèle.
extension SkillCategoryIcon on SkillCategory {
  IconData get icon => switch (this) {
    SkillCategory.languages => Icons.code_rounded,
    SkillCategory.web => Icons.language_rounded,
    SkillCategory.mobileDesktop => Icons.devices_rounded,
    SkillCategory.data => Icons.storage_rounded,
    SkillCategory.automation => Icons.auto_awesome_rounded,
    SkillCategory.tools => Icons.handyman_rounded,
  };
}
