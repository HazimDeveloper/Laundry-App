import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
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
import 'package:generation_laundry_app/pages/customer/user/profile.dart';
import 'package:generation_laundry_app/pages/customer/search/search_location_pages.dart';
import 'package:generation_laundry_app/pages/customer/authentication/sign_in.dart';
import 'package:generation_laundry_app/pages/customer/authentication/sign_up.dart';
import 'package:generation_laundry_app/pages/customer/utils/success_page.dart';
import 'package:generation_laundry_app/pages/splash_screen.dart';
import 'package:generation_laundry_app/pages/customer/registration/registration_number.dart';
import 'package:generation_laundry_app/pages/customer/authentication/otp_number.dart';

enum NavigationEvent {
  goToSplash,
  goToRegistration,
  goToOTP,
  goToSignUp,
  goToLogin,
  goToDashboard,
  goToNavigation,
  goToOrderHistory,
  goToOrderStatus,
  goToProfile,
  goToAddNewOrder,
  goToSearchLocation,
  goToOrderDetails,
  goToOrderResults,
  goToSuccessPage,
  goToAdminDashboard,
  goToCustomerInformation,
  goToProfileAdmin,
}

class NavigationBloc extends Bloc<NavigationEvent, Widget> {
  NavigationBloc() : super(SplashScreen()) {
    on<NavigationEvent>((event, emit) {
      switch (event) {
        case NavigationEvent.goToSplash:
          emit(SplashScreen());
          break;
        case NavigationEvent.goToRegistration:
          emit(RegistrationNumber());
          break;
        case NavigationEvent.goToOTP:
          emit(OTPInputScreen(phoneNumber: '012 345 678'));
          break;
        case NavigationEvent.goToSignUp:
          emit(SignUp());
          break;
        case NavigationEvent.goToLogin:
          emit(SignIn());
          break;
        case NavigationEvent.goToDashboard:
          emit(Dashboard());
          break;
        case NavigationEvent.goToNavigation:
          emit(NotificationsScreen());
          break;
        case NavigationEvent.goToOrderHistory:
          emit(OrderHistoryScreen());
          break;
        case NavigationEvent.goToOrderStatus:
          emit(OrderStatusScreen());
          break;
        case NavigationEvent.goToProfile:
          emit(ProfileScreen());
          break;
        case NavigationEvent.goToAddNewOrder:
          emit(AddNewOrder());
          break;
        case NavigationEvent.goToSearchLocation:
          emit(SearchLocationPages());
          break;
        case NavigationEvent.goToOrderDetails:
          emit(OrderDetailsPage());
          break;
        case NavigationEvent.goToOrderResults:
          emit(ResultOrderPage());
          break;
        case NavigationEvent.goToSuccessPage:
          emit(SuccessPage());
          break;
          case NavigationEvent.goToAdminDashboard:                                                                
          emit(DashboardAdminPage());
          break;
          case NavigationEvent.goToCustomerInformation:
          emit(CustomerInformation());
          break;
          case NavigationEvent.goToProfileAdmin:
          emit(ProfileAdminScreen());
          break;
        default:
          emit(SplashScreen());
          break;
      }
    });
  }
}
