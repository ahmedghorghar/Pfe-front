







/* 
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();
  static const LatLng _tataLatLng =
      LatLng(32.92960892648104, 10.443027161976538);
  LatLng? _currentP = null;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _tataLatLng, zoom: 13),
              markers: {
                Marker(
                    markerId: MarkerId("_currentLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _tataLatLng)
              },
            ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGrnated;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }
    _permissionGrnated = await _locationController.hasPermission();

    if (_permissionGrnated == PermissionStatus.denied) {
      _permissionGrnated = await _locationController.requestPermission();
      if (_permissionGrnated != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocatoin) {
      if (currentLocatoin.latitude != null &&
          currentLocatoin.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocatoin.latitude!, currentLocatoin.longitude!);
          print(_currentP);
        });
      }
    });
  }
}
 */