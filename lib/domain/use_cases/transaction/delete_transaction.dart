import 'package:expenses_app/domain/repositories/i_transaction_repository.dart';

/// Caso de uso para eliminar una transacción.
class DeleteTransaction {
  final ITransactionRepository _repository;

  /// Crea una instancia de [DeleteTransaction].
  DeleteTransaction(this._repository);

  /// Ejecuta el caso de uso para eliminar una transacción por su ID.
  Future<void> execute(int transactionId) {
    return _repository.deleteTransaction(transactionId);
  }
}
