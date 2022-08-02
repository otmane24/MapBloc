import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maptest/data/models/placeDetail.dart';
import 'package:maptest/data/models/placeDirection.dart';

import '../models/placeSuggestion.dart';

import '../webservices/placeSuggestionWebService.dart';

class PlaceSuggestionRepository {
  final PlaceWebService placeWebService;

  PlaceSuggestionRepository(this.placeWebService);

  Future<List<PlaceSuggestion>> getAllPlaceSuggestion(
      String place, String sessionToken) async {
    final List<dynamic> placeSuggestion =
        await placeWebService.getPlaceSuggestion(place, sessionToken);
    return placeSuggestion
        .map((place) => PlaceSuggestion.formJson(place))
        .toList();
  }

  Future<PlaceDetail> getPlaceDetail(
      String placeId, String sessionToken) async {
    final placeDetail =
        await placeWebService.getPlaceDetail(placeId, sessionToken);
    return PlaceDetail.fromJson(placeDetail);
  }

  Future<PlaceDirection> getPlaceDirection(
      LatLng origin, LatLng destination) async {
    final placeDirection =
        await placeWebService.getDirection(origin, destination);
    return PlaceDirection.formJson(placeDirection);
  }
}
