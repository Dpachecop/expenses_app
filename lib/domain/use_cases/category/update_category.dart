import 'package:expenses_app/domain/entities/category.dart';
import 'package:expenses_app/domain/repositories/i_category_repository.dart';

/// Caso de uso para actualizar una categoría existente.
class UpdateCategory {
  final ICategoryRepository _repository;

  /// Crea una instancia de [UpdateCategory].
  UpdateCategory(this._repository);

  /// Ejecuta el caso de uso.
  Future<void> execute(Category category) {
    return _repository.updateCategory(category);
  }
}
