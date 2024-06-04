// lib/userPages/MapPage.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  final String? placeName;

  const MapPage({super.key, this.placeName});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  LatLng? _currentPosition;
  GoogleMapController? _mapController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final String _googleApiKey = 'Replace with your API key'; // Replace with your API key

  List<dynamic> _suggestions = [];
  Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];
  Polyline? _routePolyline;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _searchController.addListener(_onSearchChanged);

    if (widget.placeName != null && widget.placeName!.isNotEmpty) {
      print('Searching for place: ${widget.placeName}');
      _searchPlacesByName(widget.placeName!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _fetchSuggestions(_searchController.text);
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  Future<void> _fetchSuggestions(String query) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'OK') {
          setState(() {
            _suggestions = json['predictions'];
          });
        } else {
          print('Error status: ${json['status']}');
          print('Error message: ${json['error_message']}');
        }
      } else {
        print('Failed to load suggestions: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _searchPlacesByName(String placeName) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$placeName&inputtype=textquery&fields=geometry,name&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'OK' && json['candidates'].isNotEmpty) {
          final place = json['candidates'][0];
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];

          final newPosition = LatLng(lat, lng);

          setState(() {
            _currentPosition = newPosition;
            _markers.clear();
            _markers.add(
              Marker(
                markerId: MarkerId("destination"),
                position: newPosition,
                infoWindow: InfoWindow(
                  title: place['name'],
                  snippet: 'Place',
                ),
              ),
            );
          });

          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(newPosition, 15),
          );

          if (_currentPosition != null) {
            _getDirections(_currentPosition!, newPosition);
          }
        } else {
          print('No results found or API error: ${json['status']}');
        }
      } else {
        print('Failed to load place details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getDirections(LatLng origin, LatLng destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude}&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'OK') {
          final points = json['routes'][0]['overview_polyline']['points'];
          _polylineCoordinates = _decodePolyline(points);

          setState(() {
            _routePolyline = Polyline(
              polylineId: PolylineId('route'),
              points: _polylineCoordinates,
              color: Colors.blue,
              width: 5,
            );
          });
        } else {
          print('Error status: ${json['status']}');
          print('Error message: ${json['error_message']}');
        }
      } else {
        print('Failed to load directions: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng position = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      polylineCoordinates.add(position);
    }
    return polylineCoordinates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(
                  child: Text("Loading..."),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 15,
                  ),
                  markers: _markers,
                  polylines: _routePolyline != null ? {_routePolyline!} : {},
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                ),
          Positioned(
            top: 50.0,
            left: 16.0,
            right: 16.0,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search places...',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    ),
                  ),
                  if (_suggestions.isNotEmpty)
                    Container(
                      height: 200.0,
                      child: ListView.builder(
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_suggestions[index]['description']),
                            onTap: () {
                              _searchPlaces(_suggestions[index]['place_id']);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 50.0,
            child: FloatingActionButton(
              onPressed: _animateToUser,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    if (_permissionGranted == PermissionStatus.granted) {
      _locationController.onLocationChanged.listen((LocationData currentLocation) {
        if (currentLocation.latitude != null && currentLocation.longitude != null) {
          setState(() {
            _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _markers.add(
              Marker(
                markerId: MarkerId("currentLocation"),
                position: _currentPosition!,
                icon: BitmapDescriptor.defaultMarker,
              ),
            );
          });
        }
      });
    }
  }

  void _animateToUser() {
    if (_currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15),
      );
    }
  }

  Future<void> _searchPlaces(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'OK') {
          final place = json['result'];
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];

          final newPosition = LatLng(lat, lng);

          setState(() {
            _currentPosition = newPosition;
            _markers.clear();
            _markers.add(
              Marker(
                markerId: MarkerId("destination"),
                position: newPosition,
                infoWindow: InfoWindow(
                  title: place['name'],
                  snippet: place['formatted_address'],
                ),
              ),
            );
          });

          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(newPosition, 15),
          );

          if (_currentPosition != null) {
            _getDirections(_currentPosition!, newPosition);
          }
        } else {
          print('No results found');
        }
      } else {
        print('Failed to load place details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
