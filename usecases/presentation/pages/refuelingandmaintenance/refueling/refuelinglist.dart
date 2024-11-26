import 'package:flutter/material.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';

class RefuelingList extends StatelessWidget {
  const RefuelingList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: 'Refueling List'),
      body: Center(
        child: Text('Refueling List'),
      ),
    );
  }
}
