import 'dart:async';
import 'package:flutter/material.dart';
import 'package:expenses_app/domain/entities/category.dart';
import 'package:expenses_app/domain/repositories/i_category_repository.dart';

/// Provider para gestionar el estado de las categorías.
class CategoryProvider extends ChangeNotifier {
  final ICategoryRepository _categoryRepository;
  StreamSubscription<List<Category>>? _categoriesSubscription;
  bool _isDisposed = false;
  
  List<Category> categories = [];
  bool isLoading = true;

  CategoryProvider(this._categoryRepository) {
    _loadCategories();
  }

  void _loadCategories() {
    _categoriesSubscription?.cancel();
    _categoriesSubscription = _categoryRepository.getAllCategoriesStream().listen((categoryList) {
      if (_isDisposed) return; // Evitar actualizar si el provider ya fue disposed
      
      categories = categoryList;
      isLoading = false;
      notifyListeners();
    });
  }

  /// Agrega una nueva categoría.
  Future<void> addCategory(Category category) async {
    await _categoryRepository.addCategory(category);
  }

  /// Actualiza una categoría existente.
  Future<void> updateCategory(Category category) async {
    await _categoryRepository.updateCategory(category);
  }

  /// Elimina una categoría por su ID.
  Future<void> deleteCategory(int categoryId) async {
    await _categoryRepository.deleteCategory(categoryId);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _categoriesSubscription?.cancel();
    super.dispose();
  }
}
