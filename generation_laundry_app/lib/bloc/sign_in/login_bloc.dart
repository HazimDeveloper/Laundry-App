import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:generation_laundry_app/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override 
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  @override 
  List<Object> get props => [email,password];
}

abstract class LoginState extends Equatable {
  const LoginState();

  @override 
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String,dynamic> userData;

  const LoginSuccess(this.userData);
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  List<Object> get props => [error];
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService apiService;

  LoginBloc(this.apiService) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final response = await apiService.signIn(
        email: event.email,
        password: event.password,
      );

      // Save token and user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      await prefs.setString('user', json.encode(response['user']));

      emit(LoginSuccess(response));
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }
}






