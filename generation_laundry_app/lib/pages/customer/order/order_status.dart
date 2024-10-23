import 'package:flutter/material.dart';
import 'package:generation_laundry_app/widget/custom_bar_navigation.dart';

class OrderStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildOrderItem('Dry', '01 Feb 2024', 'RM28', '4:00 PM', isDelivery: true),
          SizedBox(height: 16),
          _buildOrderItem('Iron', '01 Feb 2024', 'RM15', '4:00 PM', isDelivery: true),
          SizedBox(height: 16),
          _buildOrderItem('Iron', '04 Feb 2024', 'RM10', '11:00 AM', isDelivery: false),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildOrderItem(String service, String date, String price, String time, {required bool isDelivery}) {
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
              '1 hour remaining',
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
                    Icon(isDelivery ? Icons.local_shipping : Icons.store, size: 18, color: Colors.grey),
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
