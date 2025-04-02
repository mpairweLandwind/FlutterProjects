import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_app/models/cashflowreport_model.dart';
import 'package:rent_app/models/expense_model.dart';
import 'package:rent_app/models/income_model.dart';

final cashFlowReportProvider = StateNotifierProvider<CashFlowReportNotifier, List<CashFlowReport>>((ref) {
  return CashFlowReportNotifier();
});

class CashFlowReportNotifier extends StateNotifier<List<CashFlowReport>> {
  CashFlowReportNotifier() : super([]);

  void generateReport(DateTime startDate, DateTime endDate, List<Income> incomes, List<Expense> expenses) {
    final totalIncome = incomes.where((income) => income.paidDate != null && income.paidDate!.isAfter(startDate) && income.paidDate!.isBefore(endDate)).fold(0.0, (sum, income) => sum + income.rentAmount);
    final totalExpenses = expenses.where((expense) => expense.date.isAfter(startDate) && expense.date.isBefore(endDate)).fold(0.0, (sum, expense) => sum + expense.amount);
    final netCashFlow = totalIncome - totalExpenses;

    final expenseBreakdown = ExpenseCategory.values.map((category) {
      final total = expenses.where((expense) => expense.category == category).fold(0.0, (sum, expense) => sum + expense.amount);
      return MapEntry(category, total);
    }).toList();

    final report = CashFlowReport(
      id: DateTime.now().toString(),
      startDate: startDate,
      endDate: endDate,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      netCashFlow: netCashFlow,
      expenseBreakdown: Map.fromEntries(expenseBreakdown),
    );

    state = [...state, report];
  }
}
