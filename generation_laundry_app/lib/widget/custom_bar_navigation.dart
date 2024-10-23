import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/pages/customer/user/dashboard.dart';
import 'package:generation_laundry_app/pages/customer/notifications/notifications.dart';
import 'package:generation_laundry_app/pages/customer/order/order_history.dart';
import 'package:generation_laundry_app/pages/customer/order/order_status.dart';
import 'package:generation_laundry_app/pages/customer/user/profile.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';

// Assuming you've already defined NavigationBloc as shown in your code

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

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
                _buildIcon(context, Icons.home_outlined, NavigationEvent.goToDashboard, state is Dashboard),
                _buildIcon(context, Icons.receipt_long_outlined, NavigationEvent.goToOrderHistory, state is OrderHistoryScreen),
                _buildCenterIcon(context),
                _buildIcon(context, Icons.local_offer_outlined, NavigationEvent.goToOrderStatus, state is OrderStatusScreen),
                _buildIcon(context, Icons.person_outline, NavigationEvent.goToProfile, state is ProfileScreen),
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