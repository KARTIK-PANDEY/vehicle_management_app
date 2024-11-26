import 'package:flutter/material.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';

class MaintenanceForm extends StatelessWidget {
  const MaintenanceForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: 'Maintenance Form'),
      body: Center(
        child: Text('Maintenance Form'),
      ),
    );
  }
}
