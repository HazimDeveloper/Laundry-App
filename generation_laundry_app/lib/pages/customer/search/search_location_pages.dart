import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/location/location_bloc.dart';
import 'package:generation_laundry_app/bloc/location/location_event.dart';
import 'package:generation_laundry_app/bloc/location/location_state.dart';
import 'package:generation_laundry_app/pages/customer/order/order_details_page.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';
import 'package:generation_laundry_app/widget/custom_bar_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchLocationPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc()..add(GetCurrentLocation()),
      child: SearchLocationContent(),
    );
  }
}

class SearchLocationContent extends StatefulWidget {
  @override
  _SearchLocationContentState createState() => _SearchLocationContentState();
}

class _SearchLocationContentState extends State<SearchLocationContent> {
  GoogleMapController? mapController;
  final TextEditingController _searchController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
        if (state.currentLocation != null && mapController != null) {
          mapController!.animateCamera(CameraUpdate.newLatLng(state.currentLocation!));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.goToAddNewOrder);
              },
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            children: [
              _buildSearchBar(context),
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: state.currentLocation ?? LocationBloc.DEFAULT_LOCATION,
                        zoom: 15.0,
                      ),
                      onTap: (LatLng latLng) {
                        context.read<LocationBloc>().add(UpdateLocation(latLng));
                      },
                      markers: state.currentLocation != null
                          ? {
                              Marker(
                                markerId: MarkerId('current_location'),
                                position: state.currentLocation!,
                              )
                            }
                          : {},
                    ),
                    if (state.isLoading)
                      Center(child: CircularProgressIndicator()),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _buildConfirmationCard(state),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search location...',
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        style: TextStyle(color: Colors.white),
        onSubmitted: (value) {
          context.read<LocationBloc>().add(SearchLocation(value));
        },
      ),
    );
  }

  Widget _buildConfirmationCard(LocationState state) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Confirm location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              state.locationName.isNotEmpty ? state.locationName : 'Pin location on map',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement confirmation logic
                 BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.goToOrderDetails);
              },
              child: Text('Next', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}