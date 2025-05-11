import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer {
  int id;
  String name;
  String classification;


  Customer({
    required this.id,
    required this.name,
    required this.classification,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}