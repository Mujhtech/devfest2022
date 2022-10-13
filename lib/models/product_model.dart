import 'dart:convert';

class ProductModel {
  String name;
  String link;
  String? image;
  ProductModel({
    required this.name,
    required this.link,
    this.image,
  });

  ProductModel copyWith({
    String? name,
    String? link,
    String? image,
  }) {
    return ProductModel(
      name: name ?? this.name,
      link: link ?? this.link,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'link': link,
      'image': image,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      link: map['link'] ?? '',
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() => 'ProductModel(name: $name, link: $link, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.name == name &&
        other.link == link &&
        other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ link.hashCode ^ image.hashCode;
}
