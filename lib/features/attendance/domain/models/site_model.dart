
import 'dart:convert';

class Site {
  final int? id;
  final String? name;
  final Location? location;
  final int? radius;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Site({
    this.id,
    this.name,
    this.location,
    this.radius,
    this.createdAt,
    this.updatedAt,
  });

  Site copyWith({
    int? id,
    String? name,
    Location? location,
    int? radius,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Site(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        radius: radius ?? this.radius,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Site.fromRawJson(String str) => Site.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Site.fromJson(Map<String, dynamic> json) => Site(
    id: json["id"],
    name: json["name"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    radius: json["radius"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location?.toJson(),
    "radius": radius,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Location {
  final double? lat;
  final double? lng;

  Location({
    this.lat,
    this.lng,
  });

  Location copyWith({
    double? lat,
    double? lng,
  }) =>
      Location(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  factory Location.fromRawJson(String str) => Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}
