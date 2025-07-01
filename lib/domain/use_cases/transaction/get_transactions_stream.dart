import 'package:expenses_app/domain/entities/transaction.dart';
import 'package:expenses_app/domain/repositories/i_transaction_repository.dart';

/// Caso de uso para obtener transacciones como stream.
class GetTransactionsStream {
  final ITransactionRepository _repository;

  /// Crea una instancia de [GetTransactionsStream].
  GetTransactionsStream(this._repository);

  /// Ejecuta el caso de uso para obtener un stream de transacciones.
  /// 
  /// Opcionalmente puede filtrar por rango de fechas.
  Stream<List<Transaction>> execute({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _repository.getTransactionsStream(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
