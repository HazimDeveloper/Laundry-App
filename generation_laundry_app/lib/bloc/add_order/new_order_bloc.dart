import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/add_order/new_order_event.dart';
import 'package:generation_laundry_app/bloc/add_order/new_order_state.dart';

class NewOrderBloc extends Bloc<NewOrderEvent, NewOrderState> {
  NewOrderBloc() : super(NewOrderState()) {
    on<ToggleServiceSelection>(_onToggleServiceSelection);
    on<SelectDate>(_onSelectDate);
  }

  void _onToggleServiceSelection(ToggleServiceSelection event, Emitter<NewOrderState> emit) {
    final updatedServices = Set<String>.from(state.selectedServices);
    if (updatedServices.contains(event.service)) {
      updatedServices.remove(event.service);
    } else {
      updatedServices.add(event.service);
    }
    emit(state.copyWith(selectedServices: updatedServices));
  }

  void _onSelectDate(SelectDate event, Emitter<NewOrderState> emit) {
    if (event.date.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
      emit(state.copyWith(selectedDate: event.date));
    }
  }
}