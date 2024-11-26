import 'package:flutter/material.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';

class RefuelingAndMaintenancePage extends StatelessWidget {
  const RefuelingAndMaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: 'Refueling and Maintenance'),
      body: Center(
        child: Text('Refueling and Maintenance Page'),
      ),
    );
  }
}
