import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/order_status/order_status_bloc.dart';
import 'package:generation_laundry_app/network/api_service.dart';
import 'package:generation_laundry_app/widget/custom_bar_navigation.dart';
import 'package:intl/intl.dart';

class OrderStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderStatusBloc(context.read<ApiService>())..add(LoadOrderStatus()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Status'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: BlocBuilder<OrderStatusBloc, OrderStatusState>(
          builder: (context, state) {
            if (state is OrderStatusLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is OrderStatusError) {
              return Center(child: Text(state.message));
            }
            
            if (state is OrderStatusLoaded) {
              if (state.orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No Active Orders',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<OrderStatusBloc>().add(LoadOrderStatus());
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    return Column(
                      children: [
                        _buildOrderItem(
                          order['service'] ?? 'Unknown Service',
                          DateFormat('dd MMM yyyy').format(DateTime.parse(order['date'])),
                          'RM ${order['price'].toStringAsFixed(2)}',
                          DateFormat('h:mm a').format(DateTime.parse(order['pickupDateTime'])),
                          isDelivery: order['isDelivery'] ?? false,
                          remainingTime: state.calculateRemainingTime(order['pickupDateTime']),
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              );
            }
            
            return Container();
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Widget _buildOrderItem(
    String service, 
    String date, 
    String price, 
    String time, 
    {required bool isDelivery, 
    required String remainingTime}
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              remainingTime,
              style: TextStyle(color: Colors.pink[800], fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(service, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(date, style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 18, color: Colors.grey),
                    Text(price, style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(isDelivery ? Icons.local_shipping : Icons.store, 
                         size: 18, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      isDelivery ? 'To be delivered: $time' : 'To be pickup: $time',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}