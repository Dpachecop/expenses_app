import 'package:expenses_app/domain/entities/category.dart';
import 'package:expenses_app/domain/repositories/i_category_repository.dart';

/// Caso de uso para agregar una nueva categoría.
class AddCategory {
  final ICategoryRepository _repository;

  /// Crea una instancia de [AddCategory].
  AddCategory(this._repository);

  /// Ejecuta el caso de uso para agregar una categoría.
  Future<void> execute(Category category) {
    return _repository.addCategory(category);
  }
}
