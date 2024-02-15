// ignore_for_file: unused_catch_clause
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationService {
  late Location _location;
  bool _serviceEnabled = false;
  PermissionStatus? _grantedPermission;

  LocationService() {
    _location = Location();
  }

  Future<bool> _checkPermission() async {
    if (await _checkService()) {
      _grantedPermission = await _location.hasPermission();
      if (_grantedPermission == PermissionStatus.denied) {
        _grantedPermission = await _location.requestPermission();
      }
    }

    return _grantedPermission == PermissionStatus.granted;
  }

  Future<bool> _checkService() async {
    try {
      _serviceEnabled = await _location.serviceEnabled();

      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
      }
    } on PlatformException catch(error) {
      _serviceEnabled = false;
      await _checkService();
    }

    return _serviceEnabled;
  }

  Future<LocationData?> getLocation() async {
    if (await _checkPermission()) {
      final locationData = _location.getLocation();
      return locationData;
    }
    
    return null;
  }

  Future<geo.Placemark?> getPlaceMark({required LocationData locationData}) async {
    final List<geo.Placemark>? placeMarks = await geo.placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);

    if (placeMarks != null && placeMarks.isNotEmpty) {
      return placeMarks[0];
    }

    return null;
  }
}