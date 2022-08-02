import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/string.dart';

class PlaceWebService {
  Dio? dio;

  PlaceWebService() {
    BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: 20000,
      receiveTimeout: 20000,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getPlaceSuggestion(
      String place, String sessionToken) async {
    try {
      Response response =
          await dio!.get(suggestionPlaceBaseUrl, queryParameters: {
        'input': place,
        'type': 'establishment',
        'sessiontoken': sessionToken,
        'components': 'country:us',
        'key': googleMapAPi,
      });
      // print(response.data);
      return response.data['predictions'];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> getPlaceDetail(String placeId, String sessionToken) async {
    try {
      Response response = await dio!.get(detailPlaceBaseUrl, queryParameters: {
        'place_id': placeId,
        'fields': 'geometry',
        'sessiontoken': sessionToken,
        'key': googleMapAPi,
      });
      // print(response.data['result']['geometry']['location']);
      return response.data['result']['geometry']['location'];
    } catch (e) {
      return Future.error(
        'Place location error : ',
        StackTrace.fromString('this is its trace'),
      );
    }
  }

  Future<dynamic> getDirection(LatLng origin, LatLng destination) async {
    try {
      Response response = await dio!.get(directionBaseUrl, queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleMapAPi,
      });
      print("directiom : ${response.data}");
      return response.data['routes'][0];
    } catch (e) {
      return Future.error(
        'desction error : ',
        StackTrace.fromString('this is its trace'),
      );
    }
  }
}
