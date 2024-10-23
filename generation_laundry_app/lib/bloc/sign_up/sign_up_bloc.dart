import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:generation_laundry_app/network/api_service.dart';

// Events
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpSubmitted extends SignUpEvent {
  final String name;
  final String email;
  final String password;
  final String address;

  const SignUpSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.address,
  });

  @override
  List<Object> get props => [name, email, password, address];
}

// States
abstract class SignUpState extends Equatable {
  const SignUpState();
  
  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final Map<String, dynamic> userData;

  const SignUpSuccess(this.userData);

  @override
  List<Object> get props => [userData];
}

class SignUpFailure extends SignUpState {
  final String error;

  const SignUpFailure(this.error);

  @override
  List<Object> get props => [error];
}

// BLoC
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final ApiService apiService;

  SignUpBloc(this.apiService) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading());
    try {
      final response = await apiService.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
        address: event.address,
      );
      emit(SignUpSuccess(response));
    } catch (error) {
      emit(SignUpFailure(error.toString()));
    }
  }
}