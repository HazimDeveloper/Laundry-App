import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:generation_laundry_app/network/api_service.dart';

abstract class OtpEvent extends Equatable {

    const OtpEvent();
    @override
    List<Object> get props => [];
}



class SendOtpEvent extends OtpEvent {

    final String phoneNumber;

    const SendOtpEvent(this.phoneNumber);

    @override
    List<Object> get props => [phoneNumber];
}

class VerifyOtp extends OtpEvent {
    final String phoneNumber;

    final String otp;

    const VerifyOtp(this.phoneNumber, this.otp);

  @override
  List<Object> get props => [phoneNumber, otp];
}

abstract class OtpState extends Equatable {
    const OtpState();

    @override
    List<Object> get props => [];   
}

class OtpInitial extends OtpState { 

}

class OtpSending extends OtpState {}

class OtpSent extends OtpState{}

class OtpVerifying extends OtpState{}

class OtpVerified extends OtpState{}

class OtpError extends OtpState{

    final String message;

    const OtpError(this.message);

    List<Object> get props => [message];
}

class OtpBloc extends Bloc<OtpEvent, OtpState>{

    final ApiService apiService;
    OtpBloc(this.apiService) : super(OtpInitial()){
        on<SendOtpEvent>(_onSendOtp);
        on<VerifyOtp>(_onVerifyOtp);
    }

    Future<void> _onSendOtp(SendOtpEvent event, Emitter<OtpState> emit) async{

        emit(OtpSending());
        try{
            await apiService.sendOtp(event.phoneNumber);
            emit(OtpSent());
        }catch(error){
            emit(OtpError(error.toString()));
        }
    }

    Future<void> _onVerifyOtp(VerifyOtp event, Emitter<OtpState> emit) async{
        emit(OtpVerifying());
        try{
            final isVerify = await apiService.verifyOtp(event.phoneNumber, event.otp);
            if(isVerify){
                emit(OtpVerified());
            }else{
                emit(OtpError('Failed to verify OTP'));
            }
        }catch(error){
            emit(OtpError(error.toString()));
    }
}
}





