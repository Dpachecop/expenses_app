import 'dart:async';
import 'package:flutter/material.dart';
import 'package:expenses_app/domain/entities/transaction.dart';
import 'package:expenses_app/domain/enums/transaction_type.dart';
import 'package:expenses_app/domain/repositories/i_transaction_repository.dart';

enum TimeFilter { week, month, custom }

/// Provider para gestionar el estado de la vista de resumen.
class OverviewProvider extends ChangeNotifier {
  final ITransactionRepository _transactionRepository;
  StreamSubscription? _transactionsSubscription;
  bool _isDisposed = false;

  List<Transaction> _allTransactions = [];
  List<Transaction> visibleTransactions = [];

  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;

  TimeFilter _selectedFilter = TimeFilter.week;
  TimeFilter get selectedFilter => _selectedFilter;

  DateTime? _customStartDate;
  DateTime? _customEndDate;

  bool isLoading = true;

  OverviewProvider(this._transactionRepository) {
    _init();
  }

  void _init() {
    _transactionsSubscription?.cancel();
    _transactionsSubscription = _transactionRepository
        .getTransactionsStream()
        .listen((transactions) {
          if (_isDisposed) return; // Evitar actualizar si el provider ya fue disposed
          
          _allTransactions = transactions;
          _calculateTotalBalance();
          _applyFilter();
          isLoading = false;
          notifyListeners();
        });
  }

  void _calculateTotalBalance() {
    totalBalance = _allTransactions.fold(0, (sum, transaction) {
      return sum +
          (transaction.type == TransactionType.income
              ? transaction.amount
              : -transaction.amount);
    });
  }

  void _applyFilter() {
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    if (_selectedFilter == TimeFilter.week) {
      startDate = now.subtract(const Duration(days: 6));
    } else if (_selectedFilter == TimeFilter.month) {
      startDate = DateTime(now.year, now.month, 1);
    } else {
      startDate = _customStartDate ?? now.subtract(const Duration(days: 30));
      endDate = _customEndDate ?? now;
    }

    visibleTransactions =
        _allTransactions.where((t) {
          return t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              t.date.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();

    totalIncome = visibleTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, item) => sum + item.amount);

    totalExpense = visibleTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, item) => sum + item.amount);

    if (!_isDisposed) {
      notifyListeners();
    }
  }

  /// Establece el filtro de tiempo.
  void setFilter(TimeFilter filter) {
    _selectedFilter = filter;
    _applyFilter();
  }

  /// Establece un rango de fechas personalizado.
  void setCustomDateRange(DateTime start, DateTime end) {
    _customStartDate = start;
    _customEndDate = end;
    _selectedFilter = TimeFilter.custom;
    _applyFilter();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _transactionsSubscription?.cancel();
    super.dispose();
  }
}
