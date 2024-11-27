import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:generation_laundry_app/network/api_service.dart';

// Events
abstract class OrderStatusEvent extends Equatable {
  const OrderStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadOrderStatus extends OrderStatusEvent {}

// States
abstract class OrderStatusState extends Equatable {
  const OrderStatusState();
  
  @override
  List<Object> get props => [];
}

class OrderStatusInitial extends OrderStatusState {}

class OrderStatusLoading extends OrderStatusState {}

class OrderStatusLoaded extends OrderStatusState {
  final List<Map<String, dynamic>> orders;

  const OrderStatusLoaded({required this.orders});

  @override
  List<Object> get props => [orders];

  String calculateRemainingTime(String pickupDateTime) {
    final pickup = DateTime.parse(pickupDateTime);
    final now = DateTime.now();
    final difference = pickup.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    }

    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes remaining';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours remaining';
    } else {
      return '${difference.inDays} days remaining';
    }
  }
}

class OrderStatusError extends OrderStatusState {
  final String message;

  const OrderStatusError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class OrderStatusBloc extends Bloc<OrderStatusEvent, OrderStatusState> {
  final ApiService apiService;

  OrderStatusBloc(this.apiService) : super(OrderStatusInitial()) {
    on<LoadOrderStatus>(_onLoadOrderStatus);
  }

  Future<void> _onLoadOrderStatus(
    LoadOrderStatus event,
    Emitter<OrderStatusState> emit,
  ) async {
    emit(OrderStatusLoading());
    try {
      final orders = await apiService.getActiveOrders();
      emit(OrderStatusLoaded(orders: orders));
    } catch (error) {
      emit(OrderStatusError(error.toString()));
    }
  }
}