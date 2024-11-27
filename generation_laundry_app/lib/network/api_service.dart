import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  // Get the appropriate base URL based on platform
  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://192.168.0.169:3000';
    } else if (Platform.isIOS) {
      return 'http://192.168.0.169:3000';
    }
    return 'http://192.168.0.169:3000';
  }

  Future<bool> checkConnection() async {
    try {
      print('Attempting to connect to: $baseUrl');
      final response = await http.get(
        Uri.parse('$baseUrl/test'), // Add a test endpoint in your backend
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('Connection timeout');
          throw Exception('Connection timeout');
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      return response.statusCode == 200;
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }

  Future<bool> sendOtp(String phoneNumber) async {
    if (!await checkConnection()) {
      throw Exception('Cannot connect to server. Please check your internet connection and try again.');
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/otp/send'),  // Updated to match your backend route
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phoneNumber': phoneNumber,
        }),
      );

      print('Send OTP response: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['message'] == 'OTP sent successfully';
      } else {
        throw Exception('Failed to send OTP: ${response.body}');
      }
    } catch (e) {
      print('Send OTP error: $e');
      throw Exception('Error sending OTP: $e');
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    if (!await checkConnection()) {
      throw Exception('Cannot connect to server. Please check your internet connection and try again.');
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/otp/verify'),  // Updated to match your backend route
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phoneNumber': phoneNumber,
          'otp': otp,
        }),
      );

      print('Verify OTP response: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['isValid'] ?? false;
      } else {
        throw Exception('Failed to verify OTP: ${response.body}');
      }
    } catch (e) {
      print('Verify OTP error: $e');
      throw Exception('Error verifying OTP: $e');
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    required String address,
  }) async {
    if (!await checkConnection()) {
      throw Exception('Cannot connect to server. Please check your internet connection and try again.');
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
          'address': address
        }),
      );

      print('Sign up response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to sign up: ${response.body}');
      }
    } catch (e) {
      print('Sign up error: $e');
      throw Exception('Error during sign up: $e');
    }
  }

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {

    if(!await checkConnection()){
      throw Exception('Cannot connect to server. Please check your internet connection and try again.');
    }

    try{
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email' : email,
          'password' : password,
        }
      ));

      print('Sign in response: ${response.body}');

      if(response.statusCode == 200 || response.statusCode == 201){
          final Map<String, dynamic> data = json.decode(response.body);
        
        //check the token if have error 
          if(data.containsKey('error')){
            throw Exception(data['error']);
          }

        return data;
       
      }else if(response.statusCode == 401){
        throw Exception('Invalid Credentials');
      }else{
        throw Exception('Failed To login: ${response.body}');
      }
    }catch(error){
      throw Exception('Error during sign in: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getOngoingOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/order/ongoing'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load ongoing orders');
      }
    } catch (e) {
      throw Exception('Error loading ongoing orders: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getServices() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/services'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      throw Exception('Error loading services: $e');
    }
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String,dynamic>> getUserProfile() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if(token == null){
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/profile'),
        headers: {
          'Contenmt-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      print('Profile Response: ${response.body}'); 

      if(response.statusCode == 200){
        final data =  json.decode(response.body);
        return data;
      } else if(response.statusCode == 401){
        throw Exception('Invalid Credentials');
      }else{
        throw Exception('Failed To login: ${response.body}');
      }
    }catch(e){
      print('Error loading profile: $e');
      throw Exception('Error loading profile: $e');  
    }
  }

 Future<List<Map<String, dynamic>>> getOrderHistory() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/order/history'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Order history response: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load order history: ${response.body}');
    }
  } catch (e) {
    print('Error loading order history: $e');
    throw Exception('Error loading order history: $e');
  }
}

// Add this method to your existing ApiService class
Future<List<Map<String, dynamic>>> getActiveOrders() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/order/active'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load active orders: ${response.body}');
    }
  } catch (e) {
    print('Error loading active orders: $e');
    throw Exception('Error loading active orders: $e');
  }
}

Future<void> createOrder({
    required List<String> services,
    required DateTime date,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/order'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'services': services,
          'pickupDateTime': date.toIso8601String(),
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create order: ${response.body}');
      }
    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Error creating order: $e');
    }
  }
}