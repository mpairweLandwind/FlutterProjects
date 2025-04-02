import 'package:rent_app/models/expense_model.dart';

class FilterOptions {
  final DateTime? startDate;
  final DateTime? endDate;
  final ExpenseCategory? category;

  FilterOptions({
    this.startDate,
    this.endDate,
    this.category,
  });
}

class SortOptions {
  final String field; // e.g., 'date', 'amount'
  final bool isAscending;

  SortOptions({
    required this.field,
    this.isAscending = true,
  });
}
