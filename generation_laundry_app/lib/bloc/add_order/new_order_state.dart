import 'package:equatable/equatable.dart';

class NewOrderState extends Equatable {
  final List<String> selectedServices;
  final DateTime? selectedDate;
  final List<Map<String, dynamic>> availableServices;
  final bool isLoading;
  final String? error;

  const NewOrderState({
    this.selectedServices = const [],
    this.selectedDate,
    this.availableServices = const [],
    this.isLoading = false,
    this.error,
  });

  NewOrderState copyWith({
    List<String>? selectedServices,
    DateTime? selectedDate,
    List<Map<String, dynamic>>? availableServices,
    bool? isLoading,
    String? error,
  }) {
    return NewOrderState(
      selectedServices: selectedServices ?? this.selectedServices,
      selectedDate: selectedDate ?? this.selectedDate,
      availableServices: availableServices ?? this.availableServices,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        selectedServices,
        selectedDate,
        availableServices,
        isLoading,
        error,
      ];
}