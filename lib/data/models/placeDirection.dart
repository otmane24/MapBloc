import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDirection {
  late LatLngBounds bounds;
  late List<PointLatLng> polylinePoint;
  late String totalDistance;
  late String totalDuration;

  PlaceDirection({
    required this.bounds,
    required this.polylinePoint,
    required this.totalDistance,
    required this.totalDuration,
  });
  factory PlaceDirection.formJson(Map<String, dynamic> json) {
    print('json :${json['bounds']['southwest']}');
    final northeast = json['bounds']['northeast'];
    final southwest = json['bounds']['southwest'];
    final bounds = LatLngBounds(
        southwest: LatLng(southwest['lat'], southwest['lng']),
        northeast: LatLng(northeast['lat'], northeast['lng']));
    late String duration;
    late String distance;

    if ((json['legs'] as List).isNotEmpty) {
      distance = json['legs'][0]['distance']['text'];
      duration = json['legs'][0]['duration']['text'];
    }

    return PlaceDirection(
      bounds: bounds,
      polylinePoint:
          PolylinePoints().decodePolyline(json['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}
