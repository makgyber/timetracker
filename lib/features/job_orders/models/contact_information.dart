import 'package:json_annotation/json_annotation.dart';

part 'contact_information.g.dart';

@JsonSerializable()
class ContactInformation {
  String type;
  String value;

  ContactInformation({
    required this.type,
    required this.value,
  });

  factory ContactInformation.fromJson(Map<String, dynamic> json) => _$ContactInformationFromJson(json);

  Map<String, dynamic> toJson() => _$ContactInformationToJson(this);

}