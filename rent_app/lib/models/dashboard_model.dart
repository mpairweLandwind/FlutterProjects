import 'package:rent_app/models/expense_model.dart';
import 'package:rent_app/models/income_model.dart';

class DashboardData {
  final double totalIncome;
  final double totalExpenses;
  final double netCashFlow;
  final List<Income> upcomingRentDueDates;
  final List<Expense> recentExpenses;

  DashboardData({
    required this.totalIncome,
    required this.totalExpenses,
    required this.netCashFlow,
    required this.upcomingRentDueDates,
    required this.recentExpenses,
  });
}
