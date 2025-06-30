import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app/config/di/service_locator.dart';
import 'package:expenses_app/domain/entities/category.dart';
import 'package:expenses_app/domain/entities/transaction.dart';
import 'package:expenses_app/domain/enums/transaction_type.dart';
import 'package:expenses_app/domain/repositories/i_category_repository.dart';
import 'package:expenses_app/domain/repositories/i_transaction_repository.dart';
import 'package:expenses_app/presentation/providers/category_provider.dart';
import 'package:expenses_app/presentation/providers/transaction_provider.dart';

// TODO: Refactor to accept an optional Transaction to edit

class TransactionFormScreen extends StatelessWidget {
  final Transaction? transaction;
  const TransactionFormScreen({super.key, this.transaction});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(getIt<ICategoryRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(getIt<ITransactionRepository>()),
        ),
      ],
      child: _TransactionFormView(transaction: transaction),
    );
  }
}

class _TransactionFormView extends StatefulWidget {
  final Transaction? transaction;
  const _TransactionFormView({this.transaction});

  @override
  State<_TransactionFormView> createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<_TransactionFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  bool get isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final tx = widget.transaction!;
      _nameController.text = tx.name;
      _descriptionController.text = tx.description ?? '';
      _amountController.text = tx.amount.toString();
      _selectedType = tx.type;
      _selectedCategory = tx.category;
      _selectedDate = tx.date;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final transactionProvider = context.read<TransactionProvider>();
    final categories = categoryProvider.categories;

    if (!isEditing && _selectedCategory == null && categories.isNotEmpty) {
      _selectedCategory = categories.first;
    }

    if (isEditing && _selectedCategory != null && categories.isNotEmpty) {
      final categoryExists = categories.any(
        (c) => c.id == _selectedCategory!.id,
      );
      if (categoryExists) {
        _selectedCategory = categories.firstWhere(
          (c) => c.id == _selectedCategory!.id,
        );
      }
    }

    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditing
                    ? 'Edit Transaction'
                    : (_selectedType == TransactionType.expense
                        ? 'New Expense'
                        : 'New Income'),
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _TypeToggle(
                selectedType: _selectedType,
                onTypeChanged: (type) => setState(() => _selectedType = type),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: inputDecoration.copyWith(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: inputDecoration.copyWith(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: inputDecoration.copyWith(labelText: 'Category'),
                items:
                    categories
                        .map(
                          (c) =>
                              DropdownMenuItem(value: c, child: Text(c.name)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                isExpanded: true,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => context.push('/categories'),
                  child: const Text('Create new category'),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Date'),
                trailing: Text(DateFormat.yMMMd().format(_selectedDate)),
                onTap: _pickDate,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration.copyWith(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      final isValid =
                          _formKey.currentState?.validate() ?? false;
                      if (!isValid) return;

                      final transaction = Transaction(
                        id: widget.transaction?.id ?? 0,
                        name: _nameController.text,
                        description: _descriptionController.text,
                        amount: double.tryParse(_amountController.text) ?? 0,
                        type: _selectedType,
                        date: _selectedDate,
                        category: _selectedCategory!,
                      );

                      if (isEditing) {
                        transactionProvider.updateTransaction(transaction);
                      } else {
                        transactionProvider.addTransaction(transaction);
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}

class _TypeToggle extends StatelessWidget {
  final TransactionType selectedType;
  final ValueChanged<TransactionType> onTypeChanged;

  const _TypeToggle({required this.selectedType, required this.onTypeChanged});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ToggleButtons(
            isSelected: [
              selectedType == TransactionType.expense,
              selectedType == TransactionType.income,
            ],
            onPressed: (index) {
              onTypeChanged(
                index == 0 ? TransactionType.expense : TransactionType.income,
              );
            },
            borderRadius: BorderRadius.circular(12),
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            selectedColor: Theme.of(context).colorScheme.primary,
            renderBorder: false,
            constraints: BoxConstraints.expand(
              width: (constraints.maxWidth / 2) - 2, // -2 for a small gap
              height: 40,
            ),
            children: const [Text('Expense'), Text('Income')],
          ),
        );
      },
    );
  }
}
