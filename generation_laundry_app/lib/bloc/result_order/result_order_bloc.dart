import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/result_order/result_order_event.dart';
import 'package:generation_laundry_app/bloc/result_order/result_order_state.dart';

class ResultOrderBloc extends Bloc<ResultOrderEvent, ResultOrderState> {
  ResultOrderBloc() : super(ResultOrderState()) {
    on<LoadResultOrder>(_onLoadResultOrder);
    on<ConfirmOrder>(_onConfirmOrder);
  }

  void _onLoadResultOrder(LoadResultOrder event, Emitter<ResultOrderState> emit) async{
    emit(state.copyWith(isLoading: true));

    // Simulating a network request
    await Future.delayed(Duration(seconds: 1), () {
      emit(state.copyWith(
        customerName: 'Mester',
        serviceType: 'Wash',
        date: 'Monday, 04 Feb 2024',
        phoneNumber: '0123456789',
        address: 'Korea, Benning',
        urgencyLevel: 'Standard',
        isLoading: false,
      ));
    });
  }

  void _onConfirmOrder(ConfirmOrder event, Emitter<ResultOrderState> emit) async {
    emit(state.copyWith(isConfirmed: true));
    // In a real app, you would send the confirmation to a server here
  }
}