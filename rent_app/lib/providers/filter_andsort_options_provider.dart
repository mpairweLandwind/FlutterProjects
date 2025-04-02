import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_app/models/ui_model.dart';

final filterProvider = StateProvider<FilterOptions>((ref) {
  return FilterOptions();
});

final sortProvider = StateProvider<SortOptions>((ref) {
  return SortOptions(field: 'date');
});
