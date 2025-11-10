class Place {
  String name;
  String state;
  String imageUrl;
  String description;
  String category;
  String contact;
  double latitude;
  double longitude;
  double rating;

  Place({
    required this.name,
    required this.state,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.contact,
    required this.latitude,
    required this.longitude,
    required this.rating,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ,
      state: json['state'] ,
      imageUrl: json['image_url'] ,
      description: json['description'] ,
      category: json['category'] ,
      contact: json['contact'] ,
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
    );
  }
}