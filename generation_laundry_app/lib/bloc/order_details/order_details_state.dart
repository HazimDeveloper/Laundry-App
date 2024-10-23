// order_details_state.dart
import 'package:equatable/equatable.dart';

class OrderDetailsState extends Equatable {
  final String deliveryType;
  final List<String> services;
  final bool isLoading;

  const OrderDetailsState({
    this.deliveryType = 'Standard',
    this.services = const ['Body Wash', 'Dry Cleaning'],
    this.isLoading = false,
  });

  OrderDetailsState copyWith({
    String? deliveryType,
    List<String>? services,
    bool? isLoading,
  }) {
    return OrderDetailsState(
      deliveryType: deliveryType ?? this.deliveryType,
      services: services ?? this.services,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [deliveryType, services, isLoading];
}