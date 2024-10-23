import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/otp/otp_bloc.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';// Import the OtpBloc

class OTPInputScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPInputScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OTPInputScreenState createState() => _OTPInputScreenState();
}

class _OTPInputScreenState extends State<OTPInputScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOTPDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }

  String get _otp => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.goToSignUp);
        } else if (state is OtpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFFE85C6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Enter OTP',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please enter OTP sent to +${widget.phoneNumber}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                            (index) => SizedBox(
                              width: 50,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: TextStyle(fontSize: 24),
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) => _onOTPDigitChanged(index, value),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<OtpBloc, OtpState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state is OtpVerifying
                                  ? null
                                  : () {
                                      context.read<OtpBloc>().add(
                                        VerifyOtp(widget.phoneNumber, _otp),
                                      );
                                    },
                              child: state is OtpVerifying
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : const Text('Confirm', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF5c4095),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            context.read<OtpBloc>().add(SendOtpEvent(widget.phoneNumber));
                          },
                          child: const Text(
                            'Did not receive OTP? Resend OTP',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.goToLogin);
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Have an account? ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(color: Color(0xFFFE85C6)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}