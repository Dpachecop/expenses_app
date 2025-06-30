import 'package:get_it/get_it.dart';
import 'package:expenses_app/domain/repositories/i_category_repository.dart';
import 'package:expenses_app/domain/repositories/i_transaction_repository.dart';
import 'package:expenses_app/infrastructure/datasources/isar_datasource.dart';
import 'package:expenses_app/infrastructure/repositories/category_repository_impl.dart';
import 'package:expenses_app/infrastructure/repositories/transaction_repository_impl.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Datasource
  getIt.registerSingleton<IsarDatasource>(IsarDatasource());

  // Repositories
  getIt.registerSingleton<ICategoryRepository>(
    CategoryRepositoryImpl(getIt<IsarDatasource>()),
  );
  getIt.registerSingleton<ITransactionRepository>(
    TransactionRepositoryImpl(getIt<IsarDatasource>()),
  );
}
