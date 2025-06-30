import 'package:expenses_app/domain/entities/category.dart';
import 'package:expenses_app/domain/enums/transaction_type.dart';

/// Representa una transacción financiera, que puede ser un ingreso o un gasto.
class Transaction {
  /// Identificador único de la transacción.
  final int id;

  /// Nombre o título de la transacción (ej: "Supermercado").
  final String name;

  /// Detalles adicionales sobre la transacción (opcional).
  final String? description;

  /// El valor monetario de la transacción, siempre positivo.
  final double amount;

  /// El tipo de transacción (ingreso o gasto).
  final TransactionType type;

  /// La fecha y hora en que se realizó la transacción.
  final DateTime date;

  /// La categoría asociada a la transacción.
  final Category category;

  /// Crea una instancia de [Transaction].
  Transaction({
    required this.id,
    required this.name,
    this.description,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });
}
