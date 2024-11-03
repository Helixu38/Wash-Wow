import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

String baseUrlLaundryShop = "https://10.0.2.2:7276/LaundryShop";
String baseUrl = "https://10.0.2.2:7276";

IOClient createIOClient() {
  HttpClient client = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  return IOClient(client);
}

Future<List<dynamic>> fetchLaundryShops(int pageNo, int pageSize) async {
  final String url = '$baseUrlLaundryShop?PageNo=$pageNo&PageSize=$pageSize';
  final ioClient = createIOClient();

  try {
    final response = await ioClient.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['value']['data'];
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<dynamic>> fetchLandryShopServices(
    String shopID, int pageNo, int pageSize) async {
  print("Shop ID : $shopID");
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String url =
      '$baseUrl/ShopService/by-shop-id/$shopID?pageNo=$pageNo&pageSize=$pageSize';
  final token = await storage.read(key: 'token');
  print(token);

  if (token == null) {
    print('No token found, please log in again');
  }

  final ioClient = createIOClient();

  try {
    final response = await ioClient.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['value'];
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<dynamic>> fetchLandryShopByOwnerID(int pageNo, int pageSize) async {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final id = await storage.read(key: 'id');
  print(id);

  if (id == null) {
    print('No id found, please log in again');
  }
  final String url =
      '$baseUrl/LaundryShop/laundryShops/filter-laundry-shop?PageNumber=$pageNo&PageSize=$pageSize&OwnerID=$id';

  final token = await storage.read(key: 'token');
  print(token);

  if (token == null) {
    print('No token found, please log in again');
  }

  final ioClient = createIOClient();

  try {
    final response = await ioClient.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['data'];
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<dynamic>> fetchBookingByShopID(
    String shopId, int pageNo, int pageSize) async {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String url =
      '$baseUrl/Booking/bookings/$shopId?ShopId=$shopId&PageNumber=$pageNo&PageSize=$pageSize';

  final token = await storage.read(key: 'token');

  if (token == null) {
    print('No token found, please log in again');
    return [];
  }

  final ioClient = createIOClient();

  try {
    final response = await ioClient.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Ensure to access 'value' before 'data'
      return data['value']['data'];
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<Map<String, dynamic>> fetchLaundryShopByID(String id) async {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String url = '$baseUrlLaundryShop/$id';

  final token = await storage.read(key: 'token');
  print(token);

  if (token == null) {
    print('No token found, please log in again');
  }

  final ioClient = createIOClient();

  try {
    final response = await ioClient.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return {
        'id': data['id'],
        'ownerID': data['ownerID'],
        'ownerName': data['ownerName'],
        'address': data['address'],
        'name': data['name'],
        'phoneContact': data['phoneContact'],
        'totalMachines': data['totalMachines'],
        'wallet': data['wallet'],
        'status': data['status'],
        'openingHour': data['openingHour'],
        'closingHour': data['closingHour'],
      };
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<Map<String, dynamic>>> fetchBookingHistoryById() async {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final id = await storage.read(key: 'id');
  if (id == null) {
    print('No id found, please log in again');
  }
  final String url = '$baseUrl/Booking/history/$id';

  final token = await storage.read(key: 'token');
  if (token == null) {
    throw Exception('No token found, please log in again');
  }

  final ioClient = createIOClient();

  try {
    final response = await ioClient.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Assuming the response is a map with a 'value' key containing the booking list
      List<Map<String, dynamic>> bookingHistory = [];
      for (var booking in data['value']) {
        // Parse each booking and add to the list
        bookingHistory.add({
          'paymentId': booking['paymentId'],
          'bookingId': booking['bookingId'],
          'createdAt': booking['createdAt'],
          'status': booking['status'],
          'totalPrice': booking['totalPrice'],
          'totalWeight': booking['totalWeight'],
          'bookingItems': booking['bookingItems']
              .map((item) => {
                    'serviceName': item['serviceName'],
                    'pricePerKg': item['pricePerKg'],
                  })
              .toList(),
        });
      }

      return bookingHistory;
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<Map<String, dynamic>>> fetchNotifications(
    String? id, int? pageNo, int? pageSize) async {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String url =
      '$baseUrl/Notification/$id/notifications?pageNo=$pageNo&pageSize=$pageSize';

  final token = await storage.read(key: 'token');
  if (token == null) {
    throw Exception('No token found, please log in again');
  }

  final ioClient = createIOClient();

  try {
    final response = await ioClient.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Access the notifications through the 'value' and 'data' keys
      List<Map<String, dynamic>> notifications = [];
      for (var notification in data['value']['data']) {
        // Parse each notification and add it to the list
        notifications.add({
          'id': notification['id'],
          'content': notification['content'],
          'receiverName': notification['receiverName'],
          'status': notification['status'],
          'readAt': notification['readAt'],
          'type': notification['type'],
        });
      }

      return notifications;
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}


