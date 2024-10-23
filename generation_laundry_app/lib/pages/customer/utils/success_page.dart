import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';
import 'package:generation_laundry_app/widget/custom_bar_navigation.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: IconButton(
                onPressed: () {
                  BlocProvider.of<NavigationBloc>(context)
                      .add(NavigationEvent.goToDashboard);
                },
                icon: Icon(Icons.close))),
      ),
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Order Confirm",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                SizedBox(height: 16,),
                Text("We will notify when its will be Pickup and Deliver",style: TextStyle(fontSize: 16,color: Colors.grey),textAlign: TextAlign.center,),
                SizedBox(height: 16,),
                //TODO : add image here
                _buildImage(),
              ],
            ),
          ))
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

Widget _buildImage(){
  return Container(
    width: 200,
    height: 200,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/success.png'),
      )
    ),
  );
}
