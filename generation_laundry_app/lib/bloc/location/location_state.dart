
// location_state.dart
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationState extends Equatable {
  final LatLng? currentLocation;
  final String locationName;
  final bool isLoading;
  final String? error;

  const LocationState({
    this.currentLocation,
    this.locationName = '',
    this.isLoading = false,
    this.error,
  });

  LocationState copyWith({
    LatLng? currentLocation,
    String? locationName,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      locationName: locationName ?? this.locationName,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [currentLocation, locationName, isLoading, error];
}