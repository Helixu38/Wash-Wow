import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

class AuthService {
  final String baseUrl;

  AuthService(this.baseUrl);

  Future<bool> register(String fullName, String email, String password,
      String phoneNumber, String address) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful registration
        print('Registration successful');
        return true;
      } else {
        // Handle registration error
        print('Registration failed: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during registration: $error');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user': {
            'email': email,
            'password': password,
          },
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful registration
        print('Login successful');
        return true;
      } else {
        // Handle registration error
        print('Login failed: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during login: $error');
      return false;
    }
  }
}
