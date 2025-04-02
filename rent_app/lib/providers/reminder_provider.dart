import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_app/models/reminder_model.dart';

final reminderProvider = StateNotifierProvider<ReminderNotifier, List<Reminder>>((ref) {
  return ReminderNotifier();
});

class ReminderNotifier extends StateNotifier<List<Reminder>> {
  ReminderNotifier() : super([]);

  void addReminder(Reminder reminder) {
    state = [...state, reminder];
  }

  void toggleReminder(String id, bool isEnabled) {
    state = state.map((reminder) => reminder.id == id ? reminder.copyWith(isEnabled: isEnabled) : reminder).toList();
  }

  void deleteReminder(String id) {
    state = state.where((reminder) => reminder.id != id).toList();
  }
}
