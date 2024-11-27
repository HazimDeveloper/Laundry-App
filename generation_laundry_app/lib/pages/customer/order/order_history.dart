import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/order_history/order_history_bloc.dart';
import 'package:generation_laundry_app/network/api_service.dart';
import 'package:generation_laundry_app/widget/custom_bar_navigation.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderHistoryBloc(context.read<ApiService>())..add(LoadOrderHistory()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order History'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistoryLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is OrderHistoryError) {
              return Center(child: Text(state.message));
            }
            
            if (state is OrderHistoryLoaded) {
              return Column(
                children: [
                  _buildSearchBar(context),
                  if (state.filteredOrders.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No Orders Found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.groupedOrders.length,
                        itemBuilder: (context, index) {
                          final date = state.groupedOrders.keys.elementAt(index);
                          final orders = state.groupedOrders[date]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDateSection(date),
                              ...orders.map((order) => _buildOrderItem(
                                order['service'],
                                order['dateTime'],
                                order['status'],
                                'RM ${order['total'].toString()}',
                              )),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              );
            }
            
            return Container();
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (query) {
          context.read<OrderHistoryBloc>().add(SearchOrder(query));
        },
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