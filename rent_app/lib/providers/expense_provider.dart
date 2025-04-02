import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_app/models/expense_model.dart';

final expenseProvider = StateNotifierProvider<ExpenseNotifier, List<Expense>>((ref) {
  return ExpenseNotifier();
});

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  ExpenseNotifier() : super([]);

  void addExpense(Expense expense) {
    state = [...state, expense];
  }

  void updateExpense(String id, Expense updatedExpense) {
    state = state.map((expense) => expense.id == id ? updatedExpense : expense).toList();
  }

  void deleteExpense(String id) {
    state = state.where((expense) => expense.id != id).toList();
  }
}
