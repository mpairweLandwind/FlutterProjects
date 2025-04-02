enum ExpenseCategory { fixed, variable, oneTime }

class Expense {
  final String id;
  final String name;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? description; // Optional

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });
}
