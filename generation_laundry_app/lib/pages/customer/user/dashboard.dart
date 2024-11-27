import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/dashboard/dashboard_bloc.dart';
import 'package:generation_laundry_app/network/api_service.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';
import 'package:generation_laundry_app/widget/custom_bar_navigation.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(context.read<ApiService>())..add(LoadDashboard()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                state is DashboardLoaded
                    ? 'Hello, ${state.userName}!'
                    : 'Loading...',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications_outlined, color: Colors.black),
                  onPressed: () {
                    BlocProvider.of<NavigationBloc>(context)
                        .add(NavigationEvent.goToNavigation);
                  },
                ),
              ],
            ),
            body: state is DashboardLoading
                ? Center(child: CircularProgressIndicator())
                : state is DashboardError
                    ? Center(child: Text(state.error))
                    : state is DashboardLoaded
                        ? _buildDashboardContent(context, state)
                        : Container(),
            bottomNavigationBar: CustomBottomNavigationBar(),
          ); 
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardLoaded state) {
  return RefreshIndicator(
    onRefresh: () async {
      context.read<DashboardBloc>().add(LoadDashboard());
    },
    child: SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Color(0xFFf162ba),
            child: Row(
              children: [
                Icon(Icons.home, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildServicesGrid(state.services ?? []),
                SizedBox(height: 16),
                Text(
                  'Ongoing Orders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildOngoingOrders(state.ongoingOrders ?? []),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildServicesGrid(List<Map<String, dynamic>> services) {
  if (services.isEmpty) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No Services Available',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  return GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    ),
    itemCount: services.length,
    itemBuilder: (context, index) {
      final service = services[index];
      return Container(
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_laundry_service),
            SizedBox(height: 8),
            Text(service['name']),
            Text('${service['price']}'),
          ],
        ),
      );
    },
  );
}

  Widget _buildOngoingOrders(List<Map<String, dynamic>> orders) {
  if (orders.isEmpty) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_outlined, size: 32, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No Ongoing Orders',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: orders.length,
    itemBuilder: (context, index) {
      final order = orders[index];
      return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: _buildOrderItem(
          order['serviceName'] ?? 'Unknown Service',
          order['duration'] ?? 'N/A',
          Icons.local_laundry_service,
        ),
      );
    },
  );
}

  Widget _buildOrderItem(String title, String duration, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 12),
          Text(title),
          Spacer(),
          Text(duration),
        ],
      ),
    );
  }
}
