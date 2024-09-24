import 'package:flutter_google_maps_webservices/places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlacesService {
  late final GoogleMapsPlaces _places;

  PlacesService() {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    if (apiKey == null) {
      throw Exception('GOOGLE_API_KEY not found in .env file');
    }
    _places = GoogleMapsPlaces(apiKey: apiKey);
  }

  Future<List<Prediction>> fetchPlacePredictions(String query) async {
    print("Fetching predictions for: $query");
    if (query.isEmpty) {
      return [];
    }

    try {
      final response = await _places.autocomplete(query);
      if (response.isOkay) {
        print("Response: ${response.predictions}"); // Should show predictions
      } else {
        print("Error: ${response.errorMessage}"); // Log any error messages
      }
      return response.predictions ?? [];
    } catch (e) {
      print("Error fetching predictions: $e");
      return [];
    }
  }
}
