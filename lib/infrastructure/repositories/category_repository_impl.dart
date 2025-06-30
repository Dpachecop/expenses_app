import 'package:isar/isar.dart';
import 'package:expenses_app/domain/entities/category.dart';
import 'package:expenses_app/domain/repositories/i_category_repository.dart';
import 'package:expenses_app/infrastructure/datasources/isar_datasource.dart';
import 'package:expenses_app/infrastructure/models/category_model.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final IsarDatasource _datasource;

  CategoryRepositoryImpl(this._datasource);

  @override
  Future<void> addCategory(Category category) async {
    final isar = await _datasource.db;
    final categoryModel =
        CategoryModel()
          ..name = category.name
          ..iconCodePoint = category.iconCodePoint
          ..colorValue = category.colorValue;

    await isar.writeTxn(() => isar.categoryModels.put(categoryModel));
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    final isar = await _datasource.db;
    await isar.writeTxn(() => isar.categoryModels.delete(categoryId));
  }

  @override
  Stream<List<Category>> getAllCategoriesStream() async* {
    final isar = await _datasource.db;
    yield* isar.categoryModels
        .where()
        .watch(fireImmediately: true)
        .map(
          (models) =>
              models
                  .map(
                    (model) => Category(
                      id: model.id,
                      name: model.name,
                      iconCodePoint: model.iconCodePoint,
                      colorValue: model.colorValue,
                    ),
                  )
                  .toList(),
        );
  }

  @override
  Future<Category?> getCategoryById(int categoryId) async {
    final isar = await _datasource.db;
    final model = await isar.categoryModels.get(categoryId);
    if (model == null) return null;

    return Category(
      id: model.id,
      name: model.name,
      iconCodePoint: model.iconCodePoint,
      colorValue: model.colorValue,
    );
  }

  @override
  Future<void> updateCategory(Category category) async {
    final isar = await _datasource.db;
    final categoryModel =
        CategoryModel()
          ..id = category.id
          ..name = category.name
          ..iconCodePoint = category.iconCodePoint
          ..colorValue = category.colorValue;

    await isar.writeTxn(() => isar.categoryModels.put(categoryModel));
  }
}
