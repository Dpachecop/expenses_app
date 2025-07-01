import 'package:expenses_app/domain/entities/transaction.dart';
import 'package:expenses_app/domain/repositories/i_transaction_repository.dart';

/// Caso de uso para agregar una nueva transacción.
class AddTransaction {
  final ITransactionRepository _repository;

  /// Crea una instancia de [AddTransaction].
  AddTransaction(this._repository);

  /// Ejecuta el caso de uso para agregar una transacción.
  Future<void> execute(Transaction transaction) {
    return _repository.addTransaction(transaction);
  }
}
