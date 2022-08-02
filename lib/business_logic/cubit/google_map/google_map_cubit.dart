import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maptest/data/models/placeDetail.dart';
import 'package:maptest/data/models/placeDirection.dart';
import '../../../data/models/placeSuggestion.dart';
import '../../../data/repository/placeSuggestionRepository.dart';
import 'package:meta/meta.dart';

part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> {
  GoogleMapCubit(this.placeSuggestionRepository) : super(GoogleMapInitial());

  final PlaceSuggestionRepository placeSuggestionRepository;
  List<PlaceSuggestion> placeSuggestion = [];
  PlaceDetail? placeDetail;
  PlaceDirection? placeDirection;

  List<PlaceSuggestion> getAllPlaceSuggestion(
      String place, String sessionToken) {
    placeSuggestionRepository
        .getAllPlaceSuggestion(place, sessionToken)
        .then((places) {
      emit(GoogleMapLoaded(places));
      this.placeSuggestion = places;
    });
    return placeSuggestion;
  }

  PlaceDetail getPlaceDetail(String placeId, String sessionToken) {
    placeSuggestionRepository
        .getPlaceDetail(placeId, sessionToken)
        .then((places) {
      emit(PlaceDetailLoaded(places));
      this.placeDetail = places;
    });
    return placeDetail!;
  }

  PlaceDirection getPlaceDirection(LatLng origin, LatLng destination) {
    placeSuggestionRepository
        .getPlaceDirection(origin, destination)
        .then((direction) {
      emit(PlaceDirectionLoaded(direction));
      this.placeDirection = direction;
    });
    return placeDirection!;
  }
}
