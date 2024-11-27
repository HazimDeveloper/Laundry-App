import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/add_order/new_order_event.dart';
import 'package:generation_laundry_app/bloc/add_order/new_order_state.dart';
import 'package:generation_laundry_app/network/api_service.dart';

class NewOrderBloc extends Bloc<NewOrderEvent, NewOrderState> {
  final ApiService apiService;

  NewOrderBloc({required this.apiService}) : super(NewOrderState()) {
    on<LoadServices>(_onLoadServices);
    on<ToggleServiceSelection>(_onToggleServiceSelection);
    on<SelectDate>(_onSelectDate);
    on<SubmitOrder>(_onSubmitOrder);
  }

  Future<void> _onLoadServices(
    LoadServices event,
    Emitter<NewOrderState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final services = await apiService.getServices();
      emit(state.copyWith(
        availableServices: services,
        isLoading: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        error: error.toString(),
        isLoading: false,
      ));
    }
  }

  void _onToggleServiceSelection(
    ToggleServiceSelection event,
    Emitter<NewOrderState> emit,
  ) {
    final selectedServices = List<String>.from(state.selectedServices);
    if (selectedServices.contains(event.service)) {
      selectedServices.remove(event.service);
    } else {
      selectedServices.add(event.service);
    }
    emit(state.copyWith(selectedServices: selectedServices));
  }

  void _onSelectDate(
    SelectDate event,
    Emitter<NewOrderState> emit,
  ) {
    emit(state.copyWith(selectedDate: event.date));
  }

  Future<void> _onSubmitOrder(
    SubmitOrder event,
    Emitter<NewOrderState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await apiService.createOrder(
        services: event.services,
        date: event.date,
      );
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(
        error: error.toString(),
        isLoading: false,
      ));
    }
  }
}