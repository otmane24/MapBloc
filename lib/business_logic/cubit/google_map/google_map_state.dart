part of 'google_map_cubit.dart';

@immutable
abstract class GoogleMapState {}

class GoogleMapInitial extends GoogleMapState {}

class GoogleMapLoaded extends GoogleMapState {
  final List<PlaceSuggestion> places;

  GoogleMapLoaded(this.places);
}

class PlaceDetailLoaded extends GoogleMapState {
  final PlaceDetail placeDetail;

  PlaceDetailLoaded(this.placeDetail);
}

class PlaceDirectionLoaded extends GoogleMapState {
  final PlaceDirection placeDirection;

  PlaceDirectionLoaded(this.placeDirection);
}

class GoogleMapLoading extends GoogleMapState {}

class GoogleMapError extends GoogleMapState {}
