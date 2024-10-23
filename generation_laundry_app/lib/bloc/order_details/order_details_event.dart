// order_details_event.dart
import 'package:equatable/equatable.dart';

abstract class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadOrderDetails extends OrderDetailsEvent {}

class UpdateDeliveryType extends OrderDetailsEvent {
  final String deliveryType;

  const UpdateDeliveryType(this.deliveryType);

  @override
  List<Object> get props => [deliveryType];
}