import 'package:rent_app/models/expense_model.dart';

class CashFlowReport {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final double totalIncome;
  final double totalExpenses;
  final double netCashFlow;
  final Map<ExpenseCategory, double> expenseBreakdown;

  CashFlowReport({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netCashFlow,
    required this.expenseBreakdown,
  });
}
