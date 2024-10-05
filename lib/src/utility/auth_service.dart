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

        final token = data['token'];
        final role = data['role'];
        final fullName = data['username'];
        final id = data['id'];

        if (token != null && role != null) {
          // Store the token securely
          await storage.write(key: 'token', value: token);
          await storage.write(key: 'fullName', value: fullName);
          await storage.write(key: 'id', value: id);
          await storage.write(key: 'role', value:  role);
          print('Login Successfully !! id: $id role: $role'); // Debugging line
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

  Future<String> resetPassword(String token, String newPassword) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final ioClient = IOClient(client);

    try {
      final response = await ioClient.put(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data'); // Debugging line

        return data['value'] ?? 'No value returned';
      } else {
        print('Request failed with status: ${response.statusCode}');
        return 'Failed to reset password';
      }
    } catch (error) {
      print('Error during forget password request: $error');
      return 'Error occurred';
    }
  }

  Future<String> forgetPassword(String email) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data'); // Debugging line

        return data['value'] ?? 'No value returned';
      } else {
        print('Request failed with status: ${response.statusCode}');
        return 'Failed to reset password';
      }
    } catch (error) {
      print('Error during forget password request: $error');
      return 'Error occurred';
    }
  }

  Future<Map<String, String?>> getUserInfo() async {
    final fullName = await storage.read(key: 'fullName');
    final role = await storage.read(key: 'role');

    return {
      'fullName': fullName,
      'role': role,
    };
  }

  Future<bool> submitForm(int formTemplateID, List<String> imageUrls,
      List<Map<String, dynamic>> fieldValues) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final token = await storage.read(key: 'token');
    print(token);

    if (token == null) {
      print('No token found, please log in again');
      return false; // Token is missing, handle this case appropriately
    }

    final ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse('$baseUrl/form'), // Replace with your actual endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'formTemplateID': formTemplateID,
          'imageUrl': imageUrls,
          'fieldValues': fieldValues,
        }),
      );

      if (response.statusCode == 200) {
        print('Form submitted successfully');
        return true;
      } else {
        print('Form submission failed: ${response.body}');
        throw Exception(
            'Form submission failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during form submission: $error');
      return false;
    }
  }
}
