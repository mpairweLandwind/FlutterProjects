import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_app/models/dashboard_model.dart';
import 'package:rent_app/providers/expense_provider.dart';
import 'package:rent_app/providers/income_provider.dart';

final dashboardProvider = Provider<DashboardData>((ref) {
  final incomes = ref.watch(incomeProvider);
  final expenses = ref.watch(expenseProvider);

  final totalIncome = incomes.where((income) => income.paidDate != null).fold(0.0, (sum, income) => sum + income.rentAmount);
  final totalExpenses = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  final netCashFlow = totalIncome - totalExpenses;

  final upcomingRentDueDates = incomes.where((income) => income.paidDate == null).toList();
  final recentExpenses = expenses.take(5).toList(); // Last 5 expenses

  return DashboardData(
    totalIncome: totalIncome,
    totalExpenses: totalExpenses,
    netCashFlow: netCashFlow,
    upcomingRentDueDates: upcomingRentDueDates,
    recentExpenses: recentExpenses,
  );
});
