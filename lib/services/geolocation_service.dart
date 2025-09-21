import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/location_point.dart';

class GeolocationService {
  final Map<String, LocationPoint> _registeredGeofences = <String, LocationPoint>{};

  Future<LocationPoint?> currentLocation() async {
    // Placeholder that returns null. Real implementation would use geolocator package.
    return null;
  }

  Future<void> registerGeofence(LocationPoint point) async {
    _registeredGeofences[point.id] = point;
    debugPrint('Geofence registered for ${point.title}');
  }

  Future<void> removeGeofence(String id) async {
    _registeredGeofences.remove(id);
  }

  List<LocationPoint> get registeredGeofences => _registeredGeofences.values.toList();

  List<LocationPoint> nearbyLocations({
    required double latitude,
    required double longitude,
    required List<LocationPoint> locations,
    double maxDistanceInMeters = 1000,
  }) {
    return locations.where((LocationPoint point) {
      final double distance = _distanceMeters(
        latitude,
        longitude,
        point.latitude,
        point.longitude,
      );
      return distance <= maxDistanceInMeters;
    }).toList();
  }

  double _distanceMeters(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000;
    final double dLat = _degToRad(lat2 - lat1);
    final double dLon = _degToRad(lon2 - lon1);
    final double a =
        sin(dLat / 2) * sin(dLat / 2) + cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degToRad(double value) => value * pi / 180.0;
}
