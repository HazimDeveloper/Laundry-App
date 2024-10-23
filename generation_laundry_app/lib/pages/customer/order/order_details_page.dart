import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/order_details/order_details_bloc.dart';
import 'package:generation_laundry_app/bloc/order_details/order_details_event.dart';
import 'package:generation_laundry_app/bloc/order_details/order_details_state.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';
import 'package:generation_laundry_app/widget/custom_bar_navigation.dart';

class OrderDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailsBloc()..add(LoadOrderDetails()),
      child: OrderDetailsView(),
    );
  }
}

class OrderDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.goToSearchLocation);
          },
        ),
      ),

      body: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCouponsSection(),
                  SizedBox(height: 16),
                  _buildDeliveryTypeSection(context, state),
                  SizedBox(height: 16),
                  _buildServicesSection(state),
                  SizedBox(height: 24),
                  _buildNextButton(context),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildCouponsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 50),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, color: Colors.deepPurple[700]),
              SizedBox(width: 8),
              Text('Coupons', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _buildDeliveryTypeSection(BuildContext context, OrderDetailsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Type', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        _buildDeliveryTypeOption(context, 'Standard', state.deliveryType == 'Standard'),
        SizedBox(height: 8),
        _buildDeliveryTypeOption(context, 'Express', state.deliveryType == 'Express'),
      ],
    );
  }

  Widget _buildDeliveryTypeOption(BuildContext context, String type, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<OrderDetailsBloc>().add(UpdateDeliveryType(type));
      },
      child: Container(

        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple[700] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(type, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
            if (isSelected) Icon(Icons.check, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection(OrderDetailsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Services', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: state.services.map((service) => _buildServiceItem(service)).toList(),
        ),
      ],
    );
  }

  Widget _buildServiceItem(String service) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(service == 'Body Wash' ? Icons.water_drop : Icons.dry_cleaning, color: Colors.purple),
          ),
          SizedBox(height: 4),
          Text(service, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildNextButton(context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement next action
          BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.goToOrderResults);
        },
        child: Text('Next',style: TextStyle(color: Colors.white),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple[700],
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}