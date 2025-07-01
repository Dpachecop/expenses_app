import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app/config/di/service_locator.dart';
import 'package:expenses_app/domain/entities/category.dart';
import 'package:expenses_app/domain/repositories/i_category_repository.dart';
import 'package:expenses_app/presentation/providers/category_provider.dart';

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryProvider(getIt<ICategoryRepository>()),
      child: const _CategoryManagementView(),
    );
  }
}

class _CategoryManagementView extends StatelessWidget {
  const _CategoryManagementView();

  void _showEditCategoryDialog(BuildContext context, Category category) {
    final controller = TextEditingController(text: category.name);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final categoryProvider = context.read<CategoryProvider>();

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            title: const Text('Edit Category'),
            content: SizedBox(
              width: screenWidth,
              child: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'New name',
                  filled: true,
                  // ignore: deprecated_member_use
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    final newCategory = category.copyWith(
                      name: controller.text,
                    );
                    categoryProvider.updateCategory(newCategory);
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body:
          categoryProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _AddCategoryForm(),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: categoryProvider.categories.length,
                      separatorBuilder: (_, __) => const SizedBox.shrink(),
                      itemBuilder: (context, index) {
                        final category = categoryProvider.categories[index];
                        return Dismissible(
                          key: ValueKey(category.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          secondaryBackground: Container(
                            color: Theme.of(context).colorScheme.primary,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              // Eliminar
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (dialogContext) => AlertDialog(
                                      title: const Text('Eliminar categoría'),
                                      content: const Text(
                                        '¿Estás seguro de que deseas eliminar esta categoría?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                dialogContext,
                                              ).pop(false),
                                          child: const Text('Cancelar'),
                                        ),
                                        FilledButton(
                                          onPressed:
                                              () => Navigator.of(
                                                dialogContext,
                                              ).pop(true),
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    ),
                              );
                              if (confirm == true) {
                                await categoryProvider.deleteCategory(
                                  category.id,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Categoría eliminada'),
                                  ),
                                );
                                return true;
                              }
                              return false;
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              // Editar
                              _showEditCategoryDialog(context, category);
                              return false;
                            }
                            return false;
                          },
                          child: ListTile(
                            leading: Icon(
                              IconData(
                                category.iconCodePoint,
                                fontFamily: 'MaterialIcons',
                              ),
                            ),
                            title: Text(
                              category.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () {
                                    _showEditCategoryDialog(context, category);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (dialogContext) => AlertDialog(
                                            title: const Text(
                                              'Eliminar categoría',
                                            ),
                                            content: const Text(
                                              '¿Estás seguro de que deseas eliminar esta categoría?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.of(
                                                      dialogContext,
                                                    ).pop(false),
                                                child: const Text('Cancelar'),
                                              ),
                                              FilledButton(
                                                onPressed:
                                                    () => Navigator.of(
                                                      dialogContext,
                                                    ).pop(true),
                                                child: const Text('Eliminar'),
                                              ),
                                            ],
                                          ),
                                    );
                                    if (confirm == true) {
                                      await categoryProvider.deleteCategory(
                                        category.id,
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Categoría eliminada'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}

class _AddCategoryForm extends StatefulWidget {
  @override
  __AddCategoryFormState createState() => __AddCategoryFormState();
}

class __AddCategoryFormState extends State<_AddCategoryForm> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.read<CategoryProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'New Category',
              filled: true,
              fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          style: FilledButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              final newCategory = Category(
                id: 0, // Isar handles the ID
                name: _controller.text,
                iconCodePoint: Icons.label.codePoint,
                colorValue: Colors.blue.value,
              );
              categoryProvider.addCategory(newCategory);
              _controller.clear();
              FocusScope.of(context).unfocus();
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
