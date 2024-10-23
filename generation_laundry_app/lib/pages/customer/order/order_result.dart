import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/result_order/result_order_bloc.dart';
import 'package:generation_laundry_app/bloc/result_order/result_order_event.dart';
import 'package:generation_laundry_app/bloc/result_order/result_order_state.dart';
import 'package:generation_laundry_app/pages/customer/utils/success_page.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';
import 'package:generation_laundry_app/widget/custom_bar_navigation.dart';

class ResultOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResultOrderBloc()..add(LoadResultOrder()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Result Order'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
               BlocProvider.of<NavigationBloc>(context)
                  .add(NavigationEvent.goToOrderDetails);
            },
          ),
        ),
        body: BlocBuilder<ResultOrderBloc, ResultOrderState>(
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
                    _buildDetailItem('Customer\'s Name', state.customerName),
                    _buildDetailItem('Service Type', state.serviceType),
                    _buildDetailItem('Date', state.date),
                    _buildDetailItem('Phone Number', state.phoneNumber),
                    _buildDetailItem('Address', state.address),
                    _buildDetailItem('Type of Urgency', state.urgencyLevel),
                    SizedBox(height: 24),
                    _buildConfirmButton(context, state),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar()
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, ResultOrderState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
              BlocProvider.of<NavigationBloc>(context)
                  .add(NavigationEvent.goToSuccessPage);
              },
        child: Text(
          state.isConfirmed ? 'Order Confirmed' : 'Confirm',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}