import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/add_order/new_order_bloc.dart';
import 'package:generation_laundry_app/bloc/add_order/new_order_event.dart';
import 'package:generation_laundry_app/bloc/add_order/new_order_state.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';
import 'package:generation_laundry_app/widget/custom_bar_navigation.dart';
import 'package:table_calendar/table_calendar.dart';

class AddNewOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewOrderBloc(),
      child: AddNewOrderContent(),
    );
  }
}

class AddNewOrderContent extends StatefulWidget {
  @override
  _AddNewOrderContentState createState() => _AddNewOrderContentState();
}

class _AddNewOrderContentState extends State<AddNewOrderContent> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Order'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildServiceOptions(),
            SizedBox(height: 20),
            _buildCalendar(),
            SizedBox(height: 20),
            _buildNextButton(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildServiceOptions() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildServiceCard('Wash', Icons.local_laundry_service, Colors.blue),
          _buildServiceCard('Iron', Icons.iron, Colors.purple),
          _buildServiceCard('Dry', Icons.dry_cleaning, Colors.orange),
          _buildServiceCard('Carpet & Mattress', Icons.cleaning_services, Colors.green),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, Color color) {
    return BlocBuilder<NewOrderBloc, NewOrderState>(
      builder: (context, state) {
        final isSelected = state.selectedServices.contains(title);
        return Card(
          elevation: 2,
          color: isSelected ? Colors.purple.shade100 : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {
              context.read<NewOrderBloc>().add(ToggleServiceSelection(title));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: isSelected ? Colors.purple : color),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.purple : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendar() {
  return BlocBuilder<NewOrderBloc, NewOrderState>(
    builder: (context, state) {
      return TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(Duration(days: 365)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(state.selectedDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(state.selectedDate, selectedDay)) {
            context.read<NewOrderBloc>().add(SelectDate(selectedDay));
            setState(() {
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.purple,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
      );
    },
  );
}

  Widget _buildNextButton() {
    return BlocBuilder<NewOrderBloc, NewOrderState>(
      builder: (context, state) {
        final bool isEnabled = state.selectedServices.isNotEmpty && state.selectedDate != null;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ElevatedButton(
            onPressed: isEnabled
                ? () {
                    BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.goToSearchLocation);
                  }
                : null,
            child: Text('Next', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled ? Colors.purple : Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        );
      },
    );
  }
}