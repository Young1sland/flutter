import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';


@JsonSerializable(createToJson: false)
class Product {
  final int id;
  final String title;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  @override
  String toString() => 'Product(id: $id, title: $title, description: $description)';
}
