import 'package:flutter/material.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';

class MaintenanceList extends StatelessWidget {
  const MaintenanceList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: 'Maintenance List'),
      body: Center(
        child: Text('Maintenance List Page'),
      ),
    );
  }
}
