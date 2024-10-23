import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/widget/custom_bar_navigation.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDateSection('Today'),
                _buildOrderItem('Dry', '02 Feb 2024, 6:56 PM', 'Completed', 'RM 30'),
                _buildOrderItem('Wash', '02 Feb 2024, 5:48 PM', 'Completed', 'RM 20'),
                _buildDateSection('01 Feb 2024'),
                _buildOrderItem('Wash', '01 Feb 2024, 6:48 PM', 'Completed', 'RM 30'),
                _buildOrderItem('Iron', '08 Oct 2023, 6:48 PM', 'Completed', 'RM 35'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Orders...',
          prefixIcon: Icon(Icons.search, color: Colors.pink),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildDateSection(String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        date,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildOrderItem(String service, String dateTime, String status, String price) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            _buildServiceIcon(service),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text(dateTime, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 4),
                  Text(status, style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Text(price, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon(String service) {
    IconData iconData;
    Color iconColor;
    switch (service.toLowerCase()) {
      case 'dry':
        iconData = Icons.dry_cleaning;
        iconColor = Colors.blue;
        break;
      case 'wash':
        iconData = Icons.local_laundry_service;
        iconColor = Colors.green;
        break;
      case 'iron':
        iconData = Icons.iron;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.cleaning_services;
        iconColor = Colors.purple;
    }
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }
}
