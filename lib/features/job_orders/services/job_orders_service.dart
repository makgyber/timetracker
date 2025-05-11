import 'package:flutter/cupertino.dart';
import 'package:timetracker/features/job_orders/models/job_order.dart';
import 'package:timetracker/features/job_orders/services/api_service.dart';
import 'package:timetracker/repository/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


class JobOrderService {
  // final DatabaseService _databaseService = DatabaseService();
  final ApiService apiService = ApiService();

  Stream<List<JobOrder>> getJobOrders() async* {
    final List<JobOrder> jobOrders = await apiService.db.jobOrders();

    debugPrint(jobOrders.length.toString());

    // Returns the database result if it exists
    if (jobOrders != null) {
      debugPrint('from local');
      yield jobOrders;
    }

    // Fetch the job orders from the API
    try {
      final jobOrders = await apiService.fetchJobOrders();



      if (jobOrders != null) {
        debugPrint(jobOrders.length.toString());
        debugPrint('from remote');
        yield jobOrders;
      }
    } catch (e) {
      // Handle the error
    }
  }
}

final jobOrderServiceProvider = Provider<JobOrderService>((ref)=>JobOrderService());

final allJobOrdersProvider = StreamProvider<List<JobOrder>>((ref) {
  final joProvider = ref.read(jobOrderServiceProvider);
  return joProvider.getJobOrders();
});