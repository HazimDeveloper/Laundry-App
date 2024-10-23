import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/otp/otp_bloc.dart';
import 'package:generation_laundry_app/bloc/sign_up/sign_up_bloc.dart';
import 'package:generation_laundry_app/network/api_service.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ApiService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationBloc()),
          BlocProvider(create: (context) => SignUpBloc(context.read<ApiService>() )),
          BlocProvider(create: (context) => OtpBloc(context.read<ApiService>())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<NavigationBloc, Widget>(
            builder: (context, currentPage) {
              print(currentPage);
              return currentPage;
            },
          ),
        ),
      ),
    );
  }
}