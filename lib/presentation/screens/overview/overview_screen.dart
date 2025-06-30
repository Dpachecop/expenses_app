import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app/config/di/service_locator.dart';
import 'package:expenses_app/domain/repositories/i_transaction_repository.dart';
import 'package:expenses_app/presentation/providers/overview_provider.dart';
import 'package:expenses_app/presentation/providers/theme_provider.dart';
import 'package:expenses_app/presentation/screens/transactions/transaction_form_screen.dart';
import 'package:expenses_app/presentation/widgets/overview/summary_card.dart';
import 'package:expenses_app/presentation/widgets/shared/transaction_list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OverviewProvider(getIt<ITransactionRepository>()),
      child: const _OverviewView(),
    );
  }
}

class _OverviewView extends StatelessWidget {
  const _OverviewView();

  @override
  Widget build(BuildContext context) {
    final overviewProvider = context.watch<OverviewProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add_outlined),
            onPressed: () => context.push('/categories'),
          ),
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body:
          overviewProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _Body(overviewProvider: overviewProvider, textTheme: textTheme),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const TransactionFormScreen(),
          );
        },
        label: const Text('Add Transaction'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.overviewProvider, required this.textTheme});

  final OverviewProvider overviewProvider;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(
      locale: 'es_CO',
      symbol: 'COP ',
      decimalDigits: 0,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      children: [
        Text(
          'Total Balance',
          style: textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          format.format(overviewProvider.totalBalance),
          style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Text('This Month', style: textTheme.titleLarge),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 380) {
              return Column(
                children: [
                  SummaryCard(
                    title: 'Income (COP)',
                    amount: overviewProvider.totalIncome,
                  ),
                  const SizedBox(height: 12),
                  SummaryCard(
                    title: 'Expenses (COP)',
                    amount: overviewProvider.totalExpense,
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Income (COP)',
                    amount: overviewProvider.totalIncome,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    title: 'Expenses (COP)',
                    amount: overviewProvider.totalExpense,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        Text('Recent Transactions', style: textTheme.titleLarge),
        const SizedBox(height: 8),
        _FilterChips(overviewProvider: overviewProvider),
        const SizedBox(height: 16),
        if (overviewProvider.visibleTransactions.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text('No transactions in this period.'),
            ),
          )
        else
          ...overviewProvider.visibleTransactions.map(
            (tx) => TransactionListItem(transaction: tx),
          ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.overviewProvider});

  final OverviewProvider overviewProvider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Week'),
            selected: overviewProvider.selectedFilter == TimeFilter.week,
            onSelected: (selected) {
              if (selected) overviewProvider.setFilter(TimeFilter.week);
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Month'),
            selected: overviewProvider.selectedFilter == TimeFilter.month,
            onSelected: (selected) {
              if (selected) overviewProvider.setFilter(TimeFilter.month);
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Custom'),
            selected: overviewProvider.selectedFilter == TimeFilter.custom,
            onSelected: (selected) async {
              if (selected) {
                final dateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (dateRange != null) {
                  overviewProvider.setCustomDateRange(
                    dateRange.start,
                    dateRange.end,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
