import 'dart:convert';

class GDGModel {
  String name;
  String url;
  GDGModel({
    required this.name,
    required this.url,
  });

  GDGModel copyWith({
    String? name,
    String? url,
  }) {
    return GDGModel(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory GDGModel.fromMap(Map<String, dynamic> map) {
    return GDGModel(
      name: map['name'] ?? '',
      url: map['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GDGModel.fromJson(String source) => GDGModel.fromMap(json.decode(source));

  @override
  String toString() => 'GDGModel(name: $name, url: $url)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GDGModel &&
      other.name == name &&
      other.url == url;
  }

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}
