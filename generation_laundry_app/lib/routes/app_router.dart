import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/location/location_bloc.dart';
import 'package:generation_laundry_app/bloc/order_details/order_details_bloc.dart';
import 'package:generation_laundry_app/bloc/result_order/result_order_bloc.dart';
import 'package:generation_laundry_app/pages/admin/customer_information.dart';
import 'package:generation_laundry_app/pages/admin/dashboard_admin.dart';
import 'package:generation_laundry_app/pages/admin/profileAdmin.dart';
import 'package:generation_laundry_app/pages/customer/order/add_new_order.dart';
import 'package:generation_laundry_app/pages/customer/user/dashboard.dart';
import 'package:generation_laundry_app/pages/customer/notifications/notifications.dart';
import 'package:generation_laundry_app/pages/customer/order/order_details_page.dart';
import 'package:generation_laundry_app/pages/customer/order/order_history.dart';
import 'package:generation_laundry_app/pages/customer/order/order_result.dart';
import 'package:generation_laundry_app/pages/customer/order/order_status.dart';
import 'package:generation_laundry_app/pages/customer/authentication/otp_number.dart';
import 'package:generation_laundry_app/pages/customer/user/profile.dart';
import 'package:generation_laundry_app/pages/customer/registration/registration_number.dart';
import 'package:generation_laundry_app/pages/customer/search/search_location_pages.dart';
import 'package:generation_laundry_app/pages/customer/authentication/sign_in.dart';
import 'package:generation_laundry_app/pages/customer/authentication/sign_up.dart';
import 'package:generation_laundry_app/pages/customer/utils/success_page.dart';
import 'package:generation_laundry_app/pages/splash_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print("AppRouter: Generating route for ${settings.name}");
    
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/registration':
        return MaterialPageRoute(builder: (_) => RegistrationNumber());
      case '/otp':
        return MaterialPageRoute(builder: (_) => OTPInputScreen(phoneNumber: '012 345 678'));
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => SignUp());  
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => SignIn());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => Dashboard());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => NotificationsScreen());
      case '/order_history':
        return MaterialPageRoute(builder: (_) => OrderHistoryScreen());
      case '/order_status':
        return MaterialPageRoute(builder: (_) => OrderStatusScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case '/add_new_order':
        return MaterialPageRoute(builder: (_) => AddNewOrder());
      case '/search_location_pages':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LocationBloc(),
            child: SearchLocationPages(),
          ),
        );
        case '/order_details_page':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
          create: (_) => OrderDetailsBloc(),
          child: OrderDetailsPage(),
        ));
        case '/result_order_page': 
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ResultOrderBloc(),
            child: ResultOrderPage(),
          ),
          );
        case '/success_page':
        return MaterialPageRoute(
          builder: (_) => const SuccessPage(),
        );
        case 'dashboard_admin':
        return MaterialPageRoute(builder: (_) => DashboardAdminPage());
        case 'customer_information':
        return MaterialPageRoute(builder: (_) => CustomerInformation());
      case '/profile_admin':
      return MaterialPageRoute(builder: (_) => ProfileAdminScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}