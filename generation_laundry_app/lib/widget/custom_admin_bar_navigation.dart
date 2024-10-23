import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/pages/admin/customer_information.dart';
import 'package:generation_laundry_app/pages/admin/dashboard_admin.dart';
import 'package:generation_laundry_app/pages/admin/profileAdmin.dart';
import 'package:generation_laundry_app/pages/customer/user/dashboard.dart';
import 'package:generation_laundry_app/pages/customer/notifications/notifications.dart';
import 'package:generation_laundry_app/pages/customer/order/order_history.dart';
import 'package:generation_laundry_app/pages/customer/order/order_status.dart';
import 'package:generation_laundry_app/pages/customer/user/profile.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';

// Assuming you've already defined NavigationBloc as shown in your code

class CustomAdminBottomNavigationBar extends StatelessWidget {
  const CustomAdminBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, Widget>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFFf162ba),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIcon(context, Icons.home_outlined, NavigationEvent.goToAdminDashboard, state is DashboardAdminPage),
                _buildIcon(context, Icons.list, NavigationEvent.goToCustomerInformation, state is CustomerInformation),
                _buildIcon(context, Icons.person_outline, NavigationEvent.goToProfileAdmin, state is ProfileAdminScreen),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(BuildContext context, IconData icon, NavigationEvent event, bool isSelected) {
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.white : Colors.white.withOpacity(0.5)),
      onPressed: () {
        context.read<NavigationBloc>().add(event);
      },
    );
  }

  Widget _buildCenterIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // You might want to define a new NavigationEvent for this action
        // For now, we'll use goToNavigation as a placeholder
        context.read<NavigationBloc>().add(NavigationEvent.goToAddNewOrder);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(Icons.add, color: Color(0xFFf162ba), size: 30),
        ),
      ),
    );
  }
}