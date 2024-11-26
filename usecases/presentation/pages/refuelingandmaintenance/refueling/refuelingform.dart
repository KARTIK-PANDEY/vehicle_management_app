import 'package:flutter/material.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';

class RefuelingForm extends StatelessWidget {
  const RefuelingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: 'Refueling Form'),
      body: Center(
        child: Text('Refueling Form'),
      ),
    );
  }
}
