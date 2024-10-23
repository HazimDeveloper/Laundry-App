import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:generation_laundry_app/network/api_service.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboard extends DashboardEvent {}

class LoadOngoingOrders extends DashboardEvent {}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String userName;
  final List<Map<String, dynamic>> ongoingOrders;
  final List<Map<String, dynamic>> services;

  const DashboardLoaded({
    required this.userName,
    required this.ongoingOrders,
    required this.services,
  });

  @override
  List<Object> get props => [userName, ongoingOrders, services];
}

class DashboardError extends DashboardState {
  final String error;

  const DashboardError(this.error);

  @override
  List<Object> get props => [error];
}

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ApiService apiService;

  DashboardBloc(this.apiService) : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<LoadOngoingOrders>(_onLoadOngoingOrders);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final userData = await apiService.getUserProfile();
      final ongoingOrders = await apiService.getOngoingOrders();
      final services = await apiService.getServices();

      emit(DashboardLoaded(
        userName: userData['name'],
        ongoingOrders: ongoingOrders,
        services: services,
      ));
    } catch (error) {
      emit(DashboardError(error.toString()));
    }
  }

  Future<void> _onLoadOngoingOrders(
    LoadOngoingOrders event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (state is DashboardLoaded) {
        final currentState = state as DashboardLoaded;
        final ongoingOrders = await apiService.getOngoingOrders();
        
        emit(DashboardLoaded(
          userName: currentState.userName,
          ongoingOrders: ongoingOrders,
          services: currentState.services,
        ));
      }
    } catch (error) {
      // Only emit error if we're not already in a loaded state
      if (state is! DashboardLoaded) {
        emit(DashboardError(error.toString()));
      }
    }
  }
}