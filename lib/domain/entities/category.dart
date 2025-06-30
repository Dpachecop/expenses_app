/// Representa una categoría para clasificar las transacciones.
class Category {
  /// Identificador único de la categoría.
  final int id;

  /// Nombre de la categoría (ej: "Comida", "Salario").
  final String name;

  /// El `codePoint` de un `IconData` para su representación visual.
  final int iconCodePoint;

  /// El valor entero ARGB de un color para la categoría.
  final int colorValue;

  /// Crea una instancia de [Category].
  Category({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
  });

  /// Crea una copia de la instancia actual de [Category] con los campos proporcionados.
  Category copyWith({
    int? id,
    String? name,
    int? iconCodePoint,
    int? colorValue,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
