import 'package:isar/isar.dart';
import 'package:expenses_app/infrastructure/models/category_model.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {
  Id id = Isar.autoIncrement;

  late String name;
  String? description;
  late double amount;

  @Enumerated(EnumType.name)
  late TransactionTypeModel type;

  late DateTime date;

  final category = IsarLink<CategoryModel>();
}

enum TransactionTypeModel { income, expense }
