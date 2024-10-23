import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/sign_in/login_bloc.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';
import 'package:generation_laundry_app/network/api_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(context.read<ApiService>()),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Check user role and navigate accordingly
              final userData = state.userData['user'];

            if (userData['role'] == 'admin') {
              BlocProvider.of<NavigationBloc>(context)
                  .add(NavigationEvent.goToAdminDashboard);
            } else {
              BlocProvider.of<NavigationBloc>(context)
                  .add(NavigationEvent.goToDashboard);
            }
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
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
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                      ),
                      child: IntrinsicHeight(
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
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Sign in',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            TextFormField(
                                              controller: _emailController,
                                              decoration: InputDecoration(
                                                hintText: 'Email',
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                              keyboardType: TextInputType.emailAddress,
                                            ),
                                            const SizedBox(height: 16),
                                            TextFormField(
                                              controller: _passwordController,
                                              decoration: InputDecoration(
                                                hintText: 'Password',
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                              obscureText: true,
                                            ),
                                            const SizedBox(height: 24),
                                            ElevatedButton(
                                              onPressed: state is LoginLoading
                                                ? null
                                                : () {
                                                    if (_emailController.text.isNotEmpty &&
                                                        _passwordController.text.isNotEmpty) {
                                                      context.read<LoginBloc>().add(
                                                        LoginSubmitted(
                                                          email: _emailController.text,
                                                          password: _passwordController.text,
                                                        ),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Please enter both email and password'),
                                                          backgroundColor: Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  },
                                              child: state is LoginLoading
                                                ? CircularProgressIndicator(color: Colors.white)
                                                : const Text(
                                                    'Sign In',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: const Size(double.infinity, 50),
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
                              // Sign up button at the bottom
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: TextButton(
                                  onPressed: () {
                                    BlocProvider.of<NavigationBloc>(context)
                                        .add(NavigationEvent.goToRegistration);
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(fontSize: 16),
                                      children: [
                                        TextSpan(
                                          text: 'Don\'t have an account? ',
                                          style: TextStyle(color: Colors.black.withOpacity(1)),
                                        ),
                                        TextSpan(
                                          text: 'Sign up',
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
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}