import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app/config/di/service_locator.dart';
import 'package:expenses_app/domain/entities/transaction.dart';
import 'package:expenses_app/domain/enums/transaction_type.dart';
import 'package:expenses_app/domain/repositories/i_transaction_repository.dart';
import 'package:expenses_app/presentation/providers/transaction_provider.dart';
import 'package:expenses_app/presentation/screens/transactions/transaction_detail_screen.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final isIncome = transaction.type == TransactionType.income;
    final format = NumberFormat.currency(
      locale: 'es_CO',
      symbol: 'COP ',
      decimalDigits: 0,
    );
    final amountText = format.format(transaction.amount);

    final amountColor = isIncome ? Colors.green.shade600 : Colors.red.shade700;
    final iconData = isIncome ? Icons.north_east : Icons.south_west;

    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(iconData, size: 20, color: amountColor),
      ),
      title: Text(
        transaction.name,
        style: textTheme.bodyLarge,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(transaction.category.name),
      trailing: Text(
        '${isIncome ? '+' : '-'}$amountText',
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: amountColor,
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder:
              (_) => ChangeNotifierProvider(
                create:
                    (_) => TransactionProvider(getIt<ITransactionRepository>()),
                child: TransactionDetailScreen(transaction: transaction),
              ),
        );
      },
    );
  }
}
