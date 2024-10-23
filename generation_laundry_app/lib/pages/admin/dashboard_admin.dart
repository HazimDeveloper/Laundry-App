import 'package:flutter/material.dart';
import 'package:generation_laundry_app/widget/custom_admin_bar_navigation.dart';

class DashboardAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildOngoingOrders(),
                  SizedBox(height: 20),
                  _buildHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomAdminBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hello, Admin!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Image.asset('assets/images/logo-2.png',
              height: 40), // Make sure the asset exists
        ],
      ),
    );
  }

  Widget _buildOngoingOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ongoing Orders',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildOrderCard(
          icon: Icons.local_laundry_service,
          service: 'Dry Cleaning',
          status: 'In progress',
          address: 'Komsir, Panilaing',
          time: '1:00PM',
          price: 10,
          weight: 1,
          isUrgent: true,
        ),
        SizedBox(height: 10),
        _buildOrderCard(
          icon: Icons.iron,
          service: 'Iron',
          status: 'In 2 days',
          showDetails: false,
          price: 10,
          weight: 1
        ),
      ],
    );
  }

  Widget _buildOrderCard({
  required IconData icon,
  required String service,
  required String status,
  int? weight,
  double? price,
  String? name,
  String? address,
  String? time,
  bool isUrgent = false,
  bool showDetails = true,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.purple),
              SizedBox(width: 8),
              Expanded(
                child: Text(service, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text(status, style: TextStyle(color: Colors.purple)),
            ],
          ),
          if (showDetails) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (address != null)
                      Row(
                        children: [
                          // Icon(Icons.location_on, size: 16, color: Colors.grey),
                        
                          Text(address, style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    if (name != null)
                      Text(name, style: TextStyle(color: Colors.grey)),
                    if (weight != null)
                      Text('Weight: ${weight}kg', style: TextStyle(color: Colors.grey)),
                    if (price != null)
                      Text('Price: RM${price.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Spacer(),
                if (time != null) ...[
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(time, style: TextStyle(color: Colors.grey)),
                ],
              ],
            ),
            if (isUrgent)
              Chip(
                label: Text('URGENT', style: TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: Colors.red,
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
          ],
        ],
      ),
    ),
  );
}

  Widget _buildHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildHistoryItem(Icons.iron, 'Iron', '2 days ago'),
      ],
    );
  }

  Widget _buildHistoryItem(IconData icon, String service, String time) {
    return Row(
      children: [
        Icon(icon, color: Colors.purple),
        SizedBox(width: 8),
        Text(service),
        Spacer(),
        Text(time, style: TextStyle(color: Colors.grey)),
        Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(Icons.home, color: Colors.white), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {}),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.pink,
            ),
            IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
                onPressed: () {}),
            IconButton(
                icon: Icon(Icons.person_outline, color: Colors.white),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
