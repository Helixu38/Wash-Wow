import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;

  AuthService(this.baseUrl);

  Future<void> register(String fullName, String email, String password, String phoneNumber , String address) async {
    final url = '$baseUrl/register';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'address': '', 
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful registration
        print('Registration successful');
      } else {
        // Handle registration error
        print('Registration failed: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
