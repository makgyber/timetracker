import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetracker/features/authentication/services/auth.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime? visitDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now()
    );

    setState(() {
      visitDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(visitDate != null
            ? 'Job orders from ${visitDate!.year}/${visitDate!.month}/${visitDate!.day}'
            : 'Job orders today',),
        elevation: 2,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.date_range_outlined),
              onPressed: _selectDate),
          IconButton(icon: Icon(Icons.exit_to_app),
              onPressed: () {
                UserAuthScope.of(context)
                    .signOut();
              })
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [

        ],
      )
    );
  }
}


