import 'package:expenses_app/domain/entities/transaction.dart';

/// Define el contrato para la gestión de datos de las transacciones.
///
/// Esta interfaz abstrae la fuente de datos y permite filtrar transacciones por fecha.
abstract class ITransactionRepository {
  /// Agrega una nueva transacción.
  Future<void> addTransaction(Transaction transaction);

  /// Actualiza una transacción existente.
  Future<void> updateTransaction(Transaction transaction);

  /// Elimina una transacción por su [transactionId].
  Future<void> deleteTransaction(int transactionId);

  /// Obtiene un `Stream` con la lista de transacciones.
  ///
  /// Opcionalmente, puede filtrar por un rango de fechas ([startDate], [endDate]).
  /// Si no se proveen fechas, retorna todas las transacciones.
  Stream<List<Transaction>> getTransactionsStream({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Obtiene una transacción específica por su [transactionId].
  ///
  /// Retorna `null` si la transacción no se encuentra.
  Future<Transaction?> getTransactionById(int transactionId);
}
