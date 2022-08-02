class PlaceDetail {
  double? lat;
  double? lng;

  PlaceDetail({required this.lat, required this.lng});

  PlaceDetail.fromJson(Map<String, dynamic> json) {
    lat = json['lat'] ?? 0;
    lng = json['lng'] ?? 0;
  }
}
