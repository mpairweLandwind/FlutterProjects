enum ReminderType { email, pushNotification }

class Reminder {
  final String id;
  final DateTime dueDate;
  final ReminderType type;
  final bool isEnabled;

  Reminder({
    required this.id,
    required this.dueDate,
    required this.type,
    this.isEnabled = true,
  });
// Define the copyWith method
  Reminder copyWith({
    String? id,
    DateTime? dueDate,
    ReminderType? type,
    bool? isEnabled,
  }) {
    return Reminder(
      id: id ?? this.id,
      dueDate: dueDate ?? this.dueDate,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
      
    );
  }

}
