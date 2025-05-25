class Department {
  final int? id;
  final String? name;

  Department(this.id, this.name);

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(json['id'] as int?, json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  Department copyWith({
    int? id,
    String? name,
  }) {
    return Department(id ?? this.id, name ?? this.name);
  }
}
