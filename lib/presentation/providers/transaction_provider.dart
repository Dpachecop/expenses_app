import 'package:flutter/material.dart';
import 'package:expenses_app/domain/entities/transaction.dart';
import 'package:expenses_app/domain/repositories/i_transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final ITransactionRepository _transactionRepository;

  TransactionProvider(this._transactionRepository);

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionRepository.addTransaction(transaction);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _transactionRepository.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(int transactionId) async {
    await _transactionRepository.deleteTransaction(transactionId);
  }
}
