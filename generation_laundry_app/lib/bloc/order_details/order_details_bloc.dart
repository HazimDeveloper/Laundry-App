// order_details_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/order_details/order_details_event.dart';
import 'package:generation_laundry_app/bloc/order_details/order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  OrderDetailsBloc() : super(OrderDetailsState()) {
    on<LoadOrderDetails>(_onLoadOrderDetails);
    on<UpdateDeliveryType>(_onUpdateDeliveryType);
  }

  void _onLoadOrderDetails(LoadOrderDetails event, Emitter<OrderDetailsState> emit) {
    // In a real app, you'd fetch order details from an API or local storage here
    emit(state.copyWith(isLoading: false));
  }

  void _onUpdateDeliveryType(UpdateDeliveryType event, Emitter<OrderDetailsState> emit) {
    emit(state.copyWith(deliveryType: event.deliveryType));
  }
}