/// Arguments passés aux formulaires de compétence et de projet via
/// `Navigator.pushNamed(context, route, arguments: ItemFormArgs(...))`.
///
/// Une seule classe générique sert aux deux formulaires :
///   - `item == null`  -> mode AJOUT
///   - `item != null`  -> mode MODIFICATION (le formulaire est pré-rempli)
class ItemFormArgs<T> {
  const ItemFormArgs({required this.studentId, this.item});

  /// Portfolio concerné (les deux portfolios sont indépendants).
  final String studentId;

  /// Élément à modifier, ou `null` pour en créer un nouveau.
  final T? item;

  bool get isEditing => item != null;
}
