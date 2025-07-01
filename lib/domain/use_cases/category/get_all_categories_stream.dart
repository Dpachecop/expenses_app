import 'package:expenses_app/domain/entities/category.dart';
import 'package:expenses_app/domain/repositories/i_category_repository.dart';

/// Caso de uso para obtener todas las categorías como stream.
class GetAllCategoriesStream {
  final ICategoryRepository _repository;

  /// Crea una instancia de [GetAllCategoriesStream].
  GetAllCategoriesStream(this._repository);

  /// Ejecuta el caso de uso para obtener un stream de todas las categorías.
  Stream<List<Category>> execute() {
    return _repository.getAllCategoriesStream();
  }
}
