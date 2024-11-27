import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:generation_laundry_app/network/api_service.dart';

// Events
abstract class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadOrderHistory extends OrderHistoryEvent {}

class SearchOrder extends OrderHistoryEvent {
  final String query;
  const SearchOrder(this.query);

  @override
  List<Object> get props => [query];
}

// States
abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();
  
  @override
  List<Object> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<Map<String, dynamic>> orders;
  final String searchQuery;

  const OrderHistoryLoaded({
    required this.orders,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [orders, searchQuery];

  List<Map<String, dynamic>> get filteredOrders {
    if (searchQuery.isEmpty) return orders;
    
    return orders.where((order) {
      final service = order['service'].toString().toLowerCase();
      final status = order['status'].toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      
      return service.contains(query) || status.contains(query);
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get groupedOrders {
    final grouped = <String, List<Map<String, dynamic>>>{};
    
    for (var order in filteredOrders) {
      final date = _formatDate(order['dateTime']);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(order);
    }
    
    return grouped;
  }

  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    final now = DateTime.now();
    
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }
}

class OrderHistoryError extends OrderHistoryState {
  final String message;
  const OrderHistoryError(this.message);

  @override
  List<Object> get props => [message];
}

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final ApiService apiService;

  OrderHistoryBloc(this.apiService) : super(OrderHistoryInitial()) {
    on<LoadOrderHistory>(_onLoadOrderHistory);
    on<SearchOrder>(_onSearchOrder);
  }

  Future<void> _onLoadOrderHistory(
    LoadOrderHistory event,
    Emitter<OrderHistoryState> emit,
  ) async {
    emit(OrderHistoryLoading());
    try {
      final orders = await apiService.getOrderHistory();
      emit(OrderHistoryLoaded(orders: orders));
    } catch (error) {
      emit(OrderHistoryError(error.toString()));
    }
  }

  Future<void> _onSearchOrder(
    SearchOrder event,
    Emitter<OrderHistoryState> emit,
  ) async {
    if (state is OrderHistoryLoaded) {
      final currentState = state as OrderHistoryLoaded;
      emit(OrderHistoryLoaded(
        orders: currentState.orders,
        searchQuery: event.query,
      ));
    }
  }
}