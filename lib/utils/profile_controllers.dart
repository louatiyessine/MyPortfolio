import 'package:flutter/widgets.dart';

import '../models/student.dart';

/// Les 12 champs texte du formulaire de profil, regroupés.
///
/// Cette classe fait trois choses, pour que l'écran reste court :
///   1. pré-remplir chaque champ avec la valeur actuelle de l'étudiant,
///   2. libérer tous les controllers (`dispose`),
///   3. construire l'étudiant modifié à partir des textes saisis.
class ProfileControllers {
  ProfileControllers(Student student)
    : fullName = TextEditingController(text: student.fullName),
      title = TextEditingController(text: student.title),
      bio = TextEditingController(text: student.bio),
      email = TextEditingController(text: student.email),
      phone = TextEditingController(text: student.phone),
      city = TextEditingController(text: student.city),
      github = TextEditingController(text: student.githubLogin),
      linkedin = TextEditingController(text: student.linkedinUrl),
      school = TextEditingController(text: student.education.establishment),
      program = TextEditingController(text: student.education.program),
      diploma = TextEditingController(text: student.education.diploma),
      period = TextEditingController(text: student.education.period);

  // Informations personnelles
  final TextEditingController fullName;
  final TextEditingController title;
  final TextEditingController bio;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController city;
  final TextEditingController github;
  final TextEditingController linkedin;

  // Informations académiques
  final TextEditingController school;
  final TextEditingController program;
  final TextEditingController diploma;
  final TextEditingController period;

  List<TextEditingController> get _all => [
    fullName,
    title,
    bio,
    email,
    phone,
    city,
    github,
    linkedin,
    school,
    program,
    diploma,
    period,
  ];

  /// À appeler dans le `dispose()` de l'écran.
  void dispose() {
    for (final controller in _all) {
      controller.dispose();
    }
  }

  /// Retourne une copie de [student] avec les valeurs saisies (sans les
  /// espaces superflus) et la couleur choisie.
  Student applyTo(Student student, {required int accentIndex}) {
    return student.copyWith(
      fullName: fullName.text.trim(),
      title: title.text.trim(),
      bio: bio.text.trim(),
      email: email.text.trim(),
      phone: phone.text.trim(),
      city: city.text.trim(),
      githubLogin: github.text.trim(),
      linkedinUrl: linkedin.text.trim(),
      accentIndex: accentIndex,
      education: student.education.copyWith(
        establishment: school.text.trim(),
        program: program.text.trim(),
        diploma: diploma.text.trim(),
        period: period.text.trim(),
      ),
    );
  }
}
