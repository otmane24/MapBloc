import 'package:dio/dio.dart';

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
        'type': 'address',
        'sessiontoken': sessionToken,
        'components': 'country:dz',
        'key': googleMapAPi,
      });

      return response.data;
    } catch (e) {
      return [];
    }
  }
}
