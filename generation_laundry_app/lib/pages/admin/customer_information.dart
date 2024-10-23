import 'package:flutter/material.dart';
import 'package:generation_laundry_app/widget/custom_admin_bar_navigation.dart';

class CustomerInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Information',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _buildOrderCard(
            name: 'Aishah Azham',
            phone: '0123456789',
            address: 'Kg Kuala Setan, 39000 Kuala, Pahang',
            price: 'RM20',
            status: 'Pending (In Transit)',
            isCompleted: false,
          ),
          SizedBox(height: 16),
          _buildOrderCard(
            name: 'Azalea Azham',
            phone: '0123456789',
            address: 'Taman Kurnia, 39000 Kuala, Pahang',
            price: 'RM40',
            status: 'Paid | Delivered',
            isCompleted: true,
          ),
        ],
      ),
      bottomNavigationBar: CustomAdminBottomNavigationBar(),
    );
  }

  Widget _buildOrderCard({
    required String name,
    required String phone,
    required String address,
    required String price,
    required String status,
    required bool isCompleted,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text(phone, style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(child: Text(address, style: TextStyle(color: Colors.grey))),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text(status, style: TextStyle(color: isCompleted ? Colors.green : Colors.orange)),
                    SizedBox(width: 4),
                    Icon(
                      isCompleted ? Icons.check_circle : Icons.access_time,
                      color: isCompleted ? Colors.green : Colors.orange,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home_outlined), onPressed: () {}),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add, color: Colors.white),
              mini: true,
              backgroundColor: Colors.pink,
            ),
            IconButton(icon: Icon(Icons.chat_bubble_outline), onPressed: () {}),
            IconButton(icon: Icon(Icons.person_outline), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}