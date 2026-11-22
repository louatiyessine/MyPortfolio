/// Transforme une date en texte relatif : « il y a 3 jours », « il y a 2 mois ».
/// [now] est paramétrable pour pouvoir tester la fonction.
String timeAgo(DateTime date, {DateTime? now}) {
  final diff = (now ?? DateTime.now()).difference(date);

  if (diff.inDays >= 365) {
    final years = diff.inDays ~/ 365;
    return 'il y a $years an${years > 1 ? 's' : ''}';
  }
  if (diff.inDays >= 30) return 'il y a ${diff.inDays ~/ 30} mois';
  if (diff.inDays >= 1) {
    return 'il y a ${diff.inDays} jour${diff.inDays > 1 ? 's' : ''}';
  }
  if (diff.inHours >= 1) return 'il y a ${diff.inHours} h';
  return "à l'instant";
}
