import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart';
import 'package:timetracker/features/authentication/models/authenticated_user.dart';
import 'package:timetracker/features/job_orders/models/address.dart';
import 'package:timetracker/features/job_orders/models/job_order.dart';
import 'package:timetracker/repository/database.dart';
import 'package:timetracker/features/job_orders/models/customer.dart';

@riverpod
class ApiService {
  final DatabaseService db = DatabaseService();

  Future<List<JobOrder>?> fetchJobOrders() async {
    String url = "https://topbestsystems.com/api/user-schedule";
    String _token = await db.authenticatedUser().then((_user)=>_user.first.token);



    final Response response = await get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $_token',
    },
    );

    try {
      if (response.statusCode == 200 || response.statusCode == 400) {
        List<JobOrder> jos = [];
        final result = json.decode(response.body);

        for (final jo in result) {
          debugPrint(jo.toString());
          Customer customer = Customer.fromJson(jo['client']);
          int customer_id = await db.insertCustomer(customer);

          Address address = Address.fromJson(jo['address']);
          int address_id = await db.insertAddress(address);

          JobOrder jobOrder = JobOrder.fromJson(jo);
          jobOrder.address_id = address_id;
          jobOrder.client_id = customer_id;
          db.insertJobOrder(jobOrder);
          jos.add(jobOrder);
        }
        debugPrint(jos.length.toString());
        return jos;
      }
    }catch(e) {
      return null;
    }
    return null;
  }

}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final tokenServiceProvider = Provider<Future<String>>((ref) {
  final DatabaseService db = DatabaseService();
  return db.authenticatedUser().then((_user)=>_user.first.token);
});