import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/pages/customer/authentication/otp_number.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';

class RegistrationNumber extends StatefulWidget {
  const RegistrationNumber({Key? key}) : super(key: key);

  @override
  _RegistrationNumberState createState() => _RegistrationNumberState();
}

class _RegistrationNumberState extends State<RegistrationNumber> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg-img.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                const Text(
                                  'Mobile Number',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Please enter your mobile phone number',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    prefixIcon: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/images/malaysia_flag.png',
                                            width: 24,
                                            height: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '+60',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Container(
                                            height: 24,
                                            width: 1,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    hintText: 'Mobile Number',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: Implement OTP sending logic
                                    BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.goToOTP );
                                  },
                                  child: const Text(
                                    'Send OTP',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: Color(0xFF5c4095),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Sign in button at the bottom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: TextButton(
                      onPressed: () {
                        BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.goToLogin);
                        // TODO: Implement login logic
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              text: 'Have an account? ',
                              style:
                                  TextStyle(color: Colors.black.withOpacity(1)),
                            ),
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(color: Color(0xFFf162ba)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
