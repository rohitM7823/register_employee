class Site {
  final String? name;
  final Map<String, dynamic>? location;
  final double? radius;

  const Site({this.name, this.location, this.radius});

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      name: json["name"],
      location: json["location"] as Map<String, dynamic>?,
      radius: double.tryParse(json["radius"]),
    );
  }
//
}
