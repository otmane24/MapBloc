part of 'google_map_cubit.dart';

@immutable
abstract class GoogleMapState {}

class GoogleMapInitial extends GoogleMapState {}

class GoogleMapLoaded extends GoogleMapState {
  final List<PlaceSuggestion> places;

  GoogleMapLoaded(this.places);
}

class GoogleMapLoading extends GoogleMapState {}

class GoogleMapError extends GoogleMapState {}
