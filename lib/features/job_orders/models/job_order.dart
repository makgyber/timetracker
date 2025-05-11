import 'package:json_annotation/json_annotation.dart';
import 'package:timetracker/features/job_orders/models/customer.dart';
import 'address.dart';

part 'job_order.g.dart';

@JsonSerializable(explicitToJson: true)
class JobOrder {
  int id;
  String code;
  String? summary;
  DateTime target_date;
  String? job_order_type;
  String status;
  int? client_id;
  Customer? client;
  int? address_id;
  Address? address;



  JobOrder({
    required this.id,
    required this.code,
    this.summary,
    required this.target_date,
    this.job_order_type,
    required this.status,
    this.client_id,
    this.client,
    this.address_id,
    this.address
  });

  factory JobOrder.fromJson(Map<String, dynamic> json) => _$JobOrderFromJson(json);

  Map<String, dynamic> toJson() => _$JobOrderToJson(this);
}