import 'package:equatable/equatable.dart';

class ResultOrderState extends Equatable {
  final String customerName;
  final String serviceType;
  final String date;
  final String phoneNumber;
  final String address;
  final String urgencyLevel;
  final bool isLoading;
  final bool isConfirmed;

  const ResultOrderState({
    this.customerName = '',
    this.serviceType = '',
    this.date = '',
    this.phoneNumber = '',
    this.address = '',
    this.urgencyLevel = '',
    this.isLoading = false,
    this.isConfirmed = false,
  });

  ResultOrderState copyWith({
    String? customerName,
    String? serviceType,
    String? date,
    String? phoneNumber,
    String? address,
    String? urgencyLevel,
    bool? isLoading,
    bool? isConfirmed,
  }) {
    return ResultOrderState(
      customerName: customerName ?? this.customerName,
      serviceType: serviceType ?? this.serviceType,
      date: date ?? this.date,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      isLoading: isLoading ?? this.isLoading,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  @override
  List<Object> get props => [customerName, serviceType, date, phoneNumber, address, urgencyLevel, isLoading, isConfirmed];
}