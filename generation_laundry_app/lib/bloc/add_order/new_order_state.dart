// new_order_state.dart
import 'package:equatable/equatable.dart';

class NewOrderState extends Equatable {
  final Set<String> selectedServices;
  final DateTime? selectedDate;

  const NewOrderState({
    this.selectedServices = const {},
    this.selectedDate,
  });

  NewOrderState copyWith({
    Set<String>? selectedServices,
    DateTime? selectedDate,
  }) {
    return NewOrderState(
      selectedServices: selectedServices ?? this.selectedServices,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [selectedServices, selectedDate];
}