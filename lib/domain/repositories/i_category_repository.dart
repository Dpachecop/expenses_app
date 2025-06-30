import 'package:expenses_app/domain/entities/category.dart';

/// Define el contrato para la gestión de datos de las categorías.
///
/// Esta interfaz abstrae la fuente de datos (local o remota) de la lógica de negocio.
abstract class ICategoryRepository {
  /// Agrega una nueva categoría.
  Future<void> addCategory(Category category);

  /// Actualiza una categoría existente.
  Future<void> updateCategory(Category category);

  /// Elimina una categoría por su [categoryId].
  Future<void> deleteCategory(int categoryId);

  /// Obtiene un `Stream` con la lista de todas las categorías.
  ///
  /// El `Stream` emite una nueva lista cada vez que los datos cambian.
  Stream<List<Category>> getAllCategoriesStream();

  /// Obtiene una categoría específica por su [categoryId].
  ///
  /// Retorna `null` si la categoría no se encuentra.
  Future<Category?> getCategoryById(int categoryId);
}
