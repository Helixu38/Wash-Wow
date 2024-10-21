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
