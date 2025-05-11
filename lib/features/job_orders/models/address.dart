import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(explicitToJson: true)
class Address {
  int id;
  String? region;
  String? province;
  String? city;
  String? barangay;
  String? street;
  String? longitude;
  String? latitude;

  Address({
    required this.id,
    this.region,
    this.province,
    this.city,
    this.barangay,
    this.street,
    this.longitude,
    this.latitude,
  });
  
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

}