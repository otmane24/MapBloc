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
}
