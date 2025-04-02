import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_app/models/income_model.dart';

final incomeProvider = StateNotifierProvider<IncomeNotifier, List<Income>>((ref) {
  return IncomeNotifier();
});

class IncomeNotifier extends StateNotifier<List<Income>> {
  IncomeNotifier() : super([]);

  void addIncome(Income income) {
    state = [...state, income];
  }

  void markAsPaid(String id, DateTime paidDate) {
    state = state.map((income) => income.id == id ? income.copyWith(paidDate: paidDate) : income).toList();
  }

  void deleteIncome(String id) {
    state = state.where((income) => income.id != id).toList();
  }
}
