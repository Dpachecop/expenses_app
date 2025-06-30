import 'package:isar/isar.dart';
import 'package:expenses_app/domain/entities/category.dart';
import 'package:expenses_app/domain/entities/transaction.dart';
import 'package:expenses_app/domain/enums/transaction_type.dart';
import 'package:expenses_app/domain/repositories/i_transaction_repository.dart';
import 'package:expenses_app/infrastructure/datasources/isar_datasource.dart';
import 'package:expenses_app/infrastructure/models/category_model.dart';
import 'package:expenses_app/infrastructure/models/transaction_model.dart';

class TransactionRepositoryImpl implements ITransactionRepository {
  final IsarDatasource _datasource;

  TransactionRepositoryImpl(this._datasource);

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final isar = await _datasource.db;
    final transactionModel = await _toModel(transaction);

    await isar.writeTxn(() async {
      await isar.transactionModels.put(transactionModel);
      await transactionModel.category.save();
    });
  }

  @override
  Future<void> deleteTransaction(int transactionId) async {
    final isar = await _datasource.db;
    await isar.writeTxn(() => isar.transactionModels.delete(transactionId));
  }

  @override
  Future<Transaction?> getTransactionById(int transactionId) async {
    final isar = await _datasource.db;
    final model = await isar.transactionModels.get(transactionId);

    if (model == null) return null;
    return await _toEntity(model);
  }

  @override
  Stream<List<Transaction>> getTransactionsStream({
    DateTime? startDate,
    DateTime? endDate,
  }) async* {
    final isar = await _datasource.db;

    // Iniciar la query para observar todos los cambios en las transacciones.
    var query = isar.transactionModels.where().sortByDateDesc();

    // El watch observará la query base. El filtrado se hace en el lado del cliente (Dart).
    yield* query.watch(fireImmediately: true).asyncMap((models) async {
      List<TransactionModel> filteredModels = models;

      // Aplicar el filtro de fechas si es necesario
      if (startDate != null && endDate != null) {
        filteredModels =
            models
                .where(
                  (m) => m.date.isAfter(startDate) && m.date.isBefore(endDate),
                )
                .toList();
      } else if (startDate != null) {
        filteredModels =
            models.where((m) => m.date.isAfter(startDate)).toList();
      } else if (endDate != null) {
        filteredModels = models.where((m) => m.date.isBefore(endDate)).toList();
      }

      final transactions = <Transaction>[];
      for (var model in filteredModels) {
        final entity = await _toEntity(model);
        if (entity != null) {
          transactions.add(entity);
        }
      }
      return transactions;
    });
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final isar = await _datasource.db;
    final transactionModel = await _toModel(transaction);
    transactionModel.id = transaction.id;

    await isar.writeTxn(() async {
      await isar.transactionModels.put(transactionModel);
      await transactionModel.category.save();
    });
  }

  Future<TransactionModel> _toModel(Transaction transaction) async {
    final isar = await _datasource.db;
    final categoryModel = await isar.categoryModels.get(
      transaction.category.id,
    );

    return TransactionModel()
      ..name = transaction.name
      ..description = transaction.description
      ..amount = transaction.amount
      ..type =
          transaction.type == TransactionType.income
              ? TransactionTypeModel.income
              : TransactionTypeModel.expense
      ..date = transaction.date
      ..category.value = categoryModel;
  }

  Future<Transaction?> _toEntity(TransactionModel model) async {
    await model.category.load();
    final categoryModel = model.category.value;

    if (categoryModel == null) return null;

    return Transaction(
      id: model.id,
      name: model.name,
      description: model.description,
      amount: model.amount,
      type:
          model.type == TransactionTypeModel.income
              ? TransactionType.income
              : TransactionType.expense,
      date: model.date,
      category: Category(
        id: categoryModel.id,
        name: categoryModel.name,
        iconCodePoint: categoryModel.iconCodePoint,
        colorValue: categoryModel.colorValue,
      ),
    );
  }
}
