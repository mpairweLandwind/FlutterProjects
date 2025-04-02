class Income {
  final String id;
  final String tenantName; // Name of the tenant
  final double rentAmount;
  final DateTime dueDate;
  final bool isRecurring;
  final DateTime? paidDate; // Optional, if rent is paid

  Income({
    required this.id,
    required this.tenantName,
    required this.rentAmount,
    required this.dueDate,
    this.isRecurring = false,
    this.paidDate,
  });

   // Define the copyWith method
  Income copyWith({
    String? id,
    String? tenantName,
    double? rentAmount,
    DateTime? dueDate,
    bool? isRecurring,
    DateTime? paidDate,
  }) {
    return Income(
      id: id ?? this.id,
      tenantName: tenantName ?? this.tenantName,
      rentAmount: rentAmount ?? this.rentAmount,
      dueDate: dueDate ?? this.dueDate,
      isRecurring: isRecurring ?? this.isRecurring,
      paidDate: paidDate ?? this.paidDate,
     
    );
  }
}
