import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            BlocProvider.of<NavigationBloc>(context)
                .add(NavigationEvent.goToDashboard);
          },
        ),
        title: Text('Notifications'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildDateSection('Today'),
          _buildNotification(
              'Master, your laundry is already pickup!', '2:45 PM'),
          _buildOfferNotification('50% off your next laundry', '2:00 PM'),
          _buildOfferNotification('Check out brand new offers', '9:30 AM'),
          _buildDateSection('Yesterday'),
          _buildNotification('Master, your laundry is delivered!', '3:00 PM'),
          _buildOfferNotification('50% off your next laundry', '3:00 PM'),
          _buildOfferNotification('Check out brand new offers', '9:00 AM'),
          _buildDateSection('Yesterday'),
          _buildNotification('Master, your laundry is Done!', '1:00 PM'),
          _buildNotification(
              'Your laundry will be delivered by 3:00 PM', '1:00 PM'),
        ],
      ),
    );
  }

  Widget _buildDateSection(String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        date,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildNotification(String message, String time) {
    return ListTile(
      title: Text(message),
      trailing: Text(time, style: TextStyle(color: Colors.grey)),
      contentPadding: EdgeInsets.symmetric(vertical: 4),
    );
  }

  Widget _buildOfferNotification(String message, String time) {
    return ListTile(
      leading: Icon(Icons.local_offer, color: Colors.blue),
      title: Text(message),
      trailing: Text(time, style: TextStyle(color: Colors.grey)),
      contentPadding: EdgeInsets.symmetric(vertical: 4),
    );
  }
}
