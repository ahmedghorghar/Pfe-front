// lib/repositories/get_places_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tataguid/models/place_model.dart';

class PlaceRepository {
  static const String baseUrl = 'http://192.168.1.9:8080';

  Future<List<PlaceModel>> getAllPlaces() async {
    final response = await http.get(Uri.parse('$baseUrl/uploads/all-places'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((place) => PlaceModel.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<PlaceModel> fetchPlaceById(String placeId) async { 
    try {
      final response = await http.get(Uri.parse('$baseUrl/uploads/places/$placeId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PlaceModel.fromJson(data);
      } else {
        throw Exception('Failed to load place details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load place details: $e');
    }
  }
}
