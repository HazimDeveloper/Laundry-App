// result_order_event.dart
import 'package:equatable/equatable.dart';

abstract class ResultOrderEvent extends Equatable {
  const ResultOrderEvent();

  @override
  List<Object> get props => [];
}

class LoadResultOrder extends ResultOrderEvent {}

class ConfirmOrder extends ResultOrderEvent {}