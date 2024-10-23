// location_event.dart
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentLocation extends LocationEvent {}

class UpdateLocation extends LocationEvent {
  final LatLng location;

  const UpdateLocation(this.location);

  @override
  List<Object> get props => [location];
}

class SearchLocation extends LocationEvent {
  final String query;

  const SearchLocation(this.query);

  @override
  List<Object> get props => [query];
}