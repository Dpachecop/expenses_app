import 'package:flutter/material.dart';
import 'package:expenses_app/domain/entities/category.dart';
import 'package:expenses_app/domain/repositories/i_category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final ICategoryRepository _categoryRepository;
  List<Category> categories = [];
  bool isLoading = true;

  CategoryProvider(this._categoryRepository) {
    _loadCategories();
  }

  void _loadCategories() {
    _categoryRepository.getAllCategoriesStream().listen((categoryList) {
      categories = categoryList;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addCategory(Category category) async {
    await _categoryRepository.addCategory(category);
  }

  Future<void> updateCategory(Category category) async {
    await _categoryRepository.updateCategory(category);
  }

  Future<void> deleteCategory(int categoryId) async {
    await _categoryRepository.deleteCategory(categoryId);
  }
}
