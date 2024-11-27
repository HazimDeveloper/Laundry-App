import 'package:equatable/equatable.dart';

abstract class NewOrderEvent extends Equatable {
  const NewOrderEvent();

  @override
  List<Object?> get props => [];
}

class ToggleServiceSelection extends NewOrderEvent {
  final String service;

  const ToggleServiceSelection(this.service);

  @override
  List<Object?> get props => [service];
}

class SelectDate extends NewOrderEvent {
  final DateTime date;

  const SelectDate(this.date);

  @override
  List<Object?> get props => [date];
}

class LoadServices extends NewOrderEvent {}

class SubmitOrder extends NewOrderEvent {
  final List<String> services;
  final DateTime date;

  const SubmitOrder({
    required this.services,
    required this.date,
  });

  @override
  List<Object?> get props => [services, date];
}