import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl;
  final FlutterSecureStorage storage = FlutterSecureStorage();

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
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        print('Registration successful');
        return true;
      } else {
        print('Registration failed: ${response.body}');
        throw Exception(
            'Registration failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during registration: $error');
      return false;
    }
  }

  Future<String?> login(String email, String password) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {
            'email': email,
            'password': password,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data'); // Debugging line

        // Accessing token and role directly from the root level
        final token = data['token'];
        final role = data['role'];
        final fullName = data['username'];

        if (token != null && role != null) {
          // Store the token securely
          await storage.write(key: 'token', value: token);
          await storage.write(key: 'fullName', value: fullName);
          print('Login successful, token: $token , fullName: $fullName');
          return role;
        } else {
          print('Token or role is missing in the response: $data');
          return null;
        }
      } else {
        print('Login failed: ${response.body}');
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during login: $error');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      // Clear the stored token and user data
      await storage.delete(key: 'token');
      await storage.delete(key: 'fullName');
      print('Logout successful');
      return true; // Return true to indicate successful logout
    } catch (error) {
      print('Error during logout: $error');
      return false; // Return false to indicate failure
    }
  }

  Future<String?> getUserName() async {
    return await storage.read(
        key: 'fullName'); // Retrieve full name from storage
  }
}
