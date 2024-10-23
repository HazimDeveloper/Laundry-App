import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';
import 'package:generation_laundry_app/widget/custom_admin_bar_navigation.dart';
import 'package:generation_laundry_app/widget/custom_bar_navigation.dart';

class ProfileAdminScreen extends StatelessWidget {
  const ProfileAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildProfileImage(),
          SizedBox(height: 16),
          Text(
            'Admin',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '+60 1234567891',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 32),
          _buildProfileOption(icon: Icons.edit, title: 'Edit Profile', onTap: (){
          }),
          SizedBox(height: 32,),
          _buildProfileOption(icon: Icons.logout, title: 'Log Out', onTap: (){
                BlocProvider.of<NavigationBloc>(context)
                  .add(NavigationEvent.goToLogin);
            
          })
        ],
      ),
      bottomNavigationBar: CustomAdminBottomNavigationBar(),
    );
  }
}

Widget _buildProfileImage() {
  return Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.purple[100],
      image: DecorationImage(
          image: AssetImage('assets/images/laundry_service-2.png'),
          fit: BoxFit.cover),
    ),
  );
}

Widget _buildProfileOption(
    {required IconData icon,
    required String title,
    required VoidCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16,horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon,color: Color(0xFFf162ba)),
              SizedBox(width: 16,),
              Text(title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
              Spacer(),
              Icon(Icons.arrow_forward_ios,color: Colors.grey,)

            ],
          ),
        ),
      );
    }
