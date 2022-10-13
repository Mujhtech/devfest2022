import 'dart:convert';

class ProductModel {
  String name;
  String link;
  ProductModel({
    required this.name,
    required this.link,
  });

  ProductModel copyWith({
    String? name,
    String? link,
  }) {
    return ProductModel(
      name: name ?? this.name,
      link: link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'link': link,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      link: map['link'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));

  @override
  String toString() => 'ProductModel(name: $name, link: $link)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductModel &&
      other.name == name &&
      other.link == link;
  }

  @override
  int get hashCode => name.hashCode ^ link.hashCode;
}
