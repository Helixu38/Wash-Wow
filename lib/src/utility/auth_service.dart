import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wash_wow/src/utility/model/store_details.dart';

class AuthService {
  final String baseUrl;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  AuthService(this.baseUrl);

  IOClient createIOClient() {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(client);
  }

  Future<bool> register(String fullName, String email, String password,
      String phoneNumber, String address) async {
    final ioClient = createIOClient();

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
    final ioClient = createIOClient();

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
          await storage.write(key: 'role', value: role);
          print(
              'Login Successfully !! id: $id role: $role token: $token'); // Debugging line
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

  Future<bool> postShopService(String? name, String? description,
      double? pricePerKg, String? shopId, int? minLaundryWeight) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final token = await storage.read(key: 'token');

    if (token == null) {
      print('No token found, please log in again');
      return false;
    }

    final ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse('$baseUrl/ShopService'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'pricePerKg': pricePerKg,
          'minLaundryWeight': minLaundryWeight,
          'shopId': shopId,
        }),
      );

      if (response.statusCode == 200) {
        print('Add service successful');
        return true;
      } else {
        print('Add service failed: ${response.body}');
        throw Exception('Add service with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during registration: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>?> booking(
    double? laundryWeight,
    String? note,
    String? shopPickupTime,
    String? customerPickupTime,
    String? laundryShopId,
    String voucherId,
    List<BookingItem> bookingItems, // Add this parameter
  ) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final token = await storage.read(key: 'token');

    if (token == null) {
      print('No token found, please log in again');
      return null; // Return null instead of false
    }

    final ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse('$baseUrl/Booking'), // Ensure this URL is correct
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'laundryWeight': laundryWeight,
          'note': note,
          'shopPickupTime': shopPickupTime,
          'customerPickupTime': customerPickupTime,
          'laundryShopId': laundryShopId,
          'voucherId': voucherId,
          'bookingItems': bookingItems
              .map((item) => item.toJson())
              .toList(), // Convert booking items to JSON
        }),
      );

      if (response.statusCode == 200) {
        print('Booking successful');
        // Decode the response body
        final responseBody = jsonDecode(response.body);
        return responseBody['value'] ??
            'No value returned'; // Return the 'value' object containing bookingId and paymentId
      } else {
        print('Booking failed: ${response.body}');
        throw Exception('Booking failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during Booking: $error');
      return null; // Return null on error
    }
  }

  Future<bool> changeBookingStatus(String? bookingID, String? status) async {
    final ioClient = createIOClient();
    final token = await storage.read(key: 'token');
    if (token == null) {
      print('No token found, please log in again');
      return false;
    }

    try {
      final response = await ioClient.patch(
        Uri.parse('$baseUrl/Booking/bookings/$bookingID/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'bookingId': bookingID,
          'newStatus': status,
        }),
      );

      if (response.statusCode == 200) {
        print('Change status successful');
        return true;
      } else {
        print('Change status failed: ${response.body}');
        throw Exception(
            'Change status failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during changing status: $error');
      return false;
    }
  }

  Future<bool> deleteBooking(String? bookingID) async {
    final ioClient = createIOClient();
    final token = await storage.read(key: 'token');
    if (token == null) {
      print('No token found, please log in again');
      return false;
    }

    try {
      final response = await ioClient.delete(
        Uri.parse('$baseUrl/Booking/$bookingID'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Delete booking successful');
        return true;
      } else {
        print('Delete booking failed: ${response.body}');
        throw Exception(
            'Delete booking failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during delete booking: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>?> pay(
    String? bookingID,
    int? paymentID,
  ) async {
    final ioClient = createIOClient();
    final token = await storage.read(key: 'token');
    final id = await storage.read(key: 'id');

    if (token == null) {
      print('No token found, please log in again');
      return null; // Return null if no token is found
    }
    if (id == null) {
      print('No id found, please log in again');
      return null; // Return null if no id is found
    }

    try {
      final response = await ioClient.post(
        Uri.parse('$baseUrl/payOS'), // Ensure this URL is correct
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'buyerID': id,
          'bookingID': bookingID,
          'paymentID': paymentID,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print('Payment successful: $responseBody');

        // Example: Access specific fields
        final String bin = responseBody['bin'];
        final String accountNumber = responseBody['accountNumber'];
        final int amount = responseBody['amount'];
        final String checkoutUrl = responseBody['checkoutUrl'];
        final String qrCode = responseBody['qrCode'];

        // Log specific fields if needed
        print(
            'Bin: $bin, Account Number: $accountNumber, Checkout URL: $checkoutUrl');

        // Return the entire response body as a map
        return responseBody;
      } else {
        print('Payment failed: ${response.body}');
        throw Exception('Payment failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during Payment: $error');
      return null; // Return null in case of an error
    }
  }

  Future<bool> changePaymentStatus(
      int? paymentID, String? bookingID, int? status) async {
    final ioClient = createIOClient();
    final token = await storage.read(key: 'token');
    if (token == null) {
      print('No token found, please log in again');
      return false;
    }

    try {
      final response = await ioClient.put(
        Uri.parse('$baseUrl/payments/payment/after-payment/$paymentID'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'paymentID': paymentID,
          'orderID': bookingID,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        print('Change payment status successful : ${response.body}');
        return true;
      } else {
        print('Change payment status failed: ${response.body}');
        throw Exception(
            'Change payment status with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during changing status payment: $error');
      return false;
    }
  }
}
