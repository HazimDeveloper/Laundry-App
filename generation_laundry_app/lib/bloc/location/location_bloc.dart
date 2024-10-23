// location_bloc.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/location/location_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import 'location_event.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  // Default location (e.g., New York City)
  static const LatLng DEFAULT_LOCATION = LatLng(40.7128, -74.0060);

  LocationBloc() : super(LocationState(currentLocation: DEFAULT_LOCATION)) {
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<UpdateLocation>(_onUpdateLocation);
    on<SearchLocation>(_onSearchLocation);
  }

  Future<void> _onGetCurrentLocation(GetCurrentLocation event, Emitter<LocationState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition();
      LatLng location = LatLng(position.latitude, position.longitude);
      String address = await _getAddressFromLatLng(location);
      emit(state.copyWith(currentLocation: location, locationName: address, isLoading: false));
    } catch (e) {
      print('Error getting current location: $e');
      String address = await _getAddressFromLatLng(DEFAULT_LOCATION);
      emit(state.copyWith(
        currentLocation: DEFAULT_LOCATION, 
        locationName: address, 
        isLoading: false, 
        error: 'Could not get current location. Using default.'
      ));
    }
  }

 void _onUpdateLocation(UpdateLocation event, Emitter<LocationState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      String address = await _getAddressFromLatLng(event.location);
      emit(state.copyWith(
        currentLocation: event.location,
        locationName: address,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Failed to update location: ${e.toString()}",
      ));
    }
  }

  Future<void> _onSearchLocation(SearchLocation event, Emitter<LocationState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      List<Location> locations = await locationFromAddress(event.query);
      if (locations.isNotEmpty) {
        LatLng location = LatLng(locations.first.latitude, locations.first.longitude);
        String address = await _getAddressFromLatLng(location);
        emit(state.copyWith(currentLocation: location, locationName: address, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, error: 'No locations found for the search query.'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }


  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      ).timeout(Duration(seconds: 10)); // Set a timeout

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}".trim();
      }
    } catch (e) {
      if (e is TimeoutException) {
        print('Geocoding request timed out: $e');
        return "Location lookup timed out";
      } else {
        print('Error getting address: $e');
        return "Unable to fetch address";
      }
    }
    return "Unknown location";
  }

}
