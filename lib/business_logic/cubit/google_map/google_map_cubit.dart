import 'package:bloc/bloc.dart';
import 'package:maptest/data/models/placeSuggestion.dart';
import 'package:maptest/data/repository/placeSuggestionRepository.dart';
import 'package:meta/meta.dart';

part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> {
  GoogleMapCubit(this.placeSuggestionRepository) : super(GoogleMapInitial());

  final PlaceSuggestionRepository placeSuggestionRepository;
  List<PlaceSuggestion> placeSuggestion = [];

  List<PlaceSuggestion> getAllCharacters(String place, String sessionToken) {
    placeSuggestionRepository
        .getAllPlaceSuggestion(place, sessionToken)
        .then((places) {
      emit(GoogleMapLoaded(places));
      this.placeSuggestion = places;
    });
    return placeSuggestion;
  }
}
