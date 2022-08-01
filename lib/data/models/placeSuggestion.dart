class PlaceSuggestion {
  String? palceId;
  String? description;

  PlaceSuggestion({required this.description, required this.palceId});

  PlaceSuggestion.formJson(Map<String, dynamic> json) {
    palceId = json['place_id'] ?? '';
    description = json['description'] ?? '';
  }
}
