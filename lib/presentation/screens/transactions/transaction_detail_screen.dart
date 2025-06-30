import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app/domain/entities/transaction.dart';
import 'package:expenses_app/domain/enums/transaction_type.dart';
import 'package:expenses_app/presentation/providers/transaction_provider.dart';
import 'package:expenses_app/presentation/screens/transactions/transaction_form_screen.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = transaction.type == TransactionType.income;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                isIncome ? Icons.north_east : Icons.south_west,
                size: 32,
                color: isIncome ? Colors.green.shade600 : colorScheme.error,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(transaction.name, style: textTheme.headlineSmall),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.of(context).pop(); // Close detail view
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder:
                          (_) =>
                              TransactionFormScreen(transaction: transaction),
                    );
                  } else if (value == 'delete') {
                    _showDeleteConfirmationDialog(context, transaction.id);
                  }
                },
                itemBuilder:
                    (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Edit'),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(
                            Icons.delete_outline,
                            color: colorScheme.error,
                          ),
                          title: Text(
                            'Delete',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ),
                    ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${isIncome ? '+' : '-'}\$${NumberFormat('#,##0', 'es_CO').format(transaction.amount)}',
            style: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.green.shade600 : null,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category', style: textTheme.labelLarge),
                const SizedBox(height: 4),
                Chip(
                  label: Text(transaction.category.name),
                  backgroundColor: colorScheme.secondaryContainer.withOpacity(
                    0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, MMM d, yyyy HH:mm').format(transaction.date),
            style: textTheme.labelLarge?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          if (transaction.description != null &&
              transaction.description!.isNotEmpty) ...[
            Text('Description', style: textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(transaction.description!),
            const SizedBox(height: 24),
          ],
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int transactionId) {
    final transactionProvider = context.read<TransactionProvider>();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
            'Are you sure you want to delete this transaction?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                transactionProvider.deleteTransaction(transactionId);
                Navigator.of(ctx).pop(); // Close dialog
                Navigator.of(context).pop(); // Close detail screen
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
