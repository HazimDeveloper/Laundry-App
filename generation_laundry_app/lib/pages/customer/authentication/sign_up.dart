import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generation_laundry_app/bloc/sign_up/sign_up_bloc.dart';
import 'package:generation_laundry_app/network/api_service.dart';
import 'package:generation_laundry_app/routes/navigation_bloc.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(context.read<ApiService>()),
      child: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            BlocProvider.of<NavigationBloc>(context)
                .add(NavigationEvent.goToDashboard);
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Create Your Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[300],
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField('Name', _nameController),
                      const SizedBox(height: 16),
                      _buildTextField('Email', _emailController),
                      const SizedBox(height: 16),
                      _buildTextField('Password', _passwordController, isPassword: true),
                      const SizedBox(height: 16),
                      _buildTextField('Address', _addressController),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is SignUpLoading
                              ? null
                              : () {
                                  context.read<SignUpBloc>().add(
                                        SignUpSubmitted(
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          address: _addressController.text,
                                        ),
                                      );
                                },
                          child: state is SignUpLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(color: Colors.white),
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5c4095),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}