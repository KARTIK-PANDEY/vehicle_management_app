import 'package:flutter/material.dart';
import 'package:vehicle_management_app/data/models/user/driver.dart';
import 'package:vehicle_management_app/domain/usecases/user/create_driverdatabase_usecase.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';
import 'package:vehicle_management_app/service_locator.dart';

class AddDriver extends StatelessWidget {
  AddDriver({super.key});

  final TextEditingController driverIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController allocationController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController alternateContactController =
      TextEditingController();
  final TextEditingController alternateContactRelationController =
      TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController licenseTypeController = TextEditingController();
  final TextEditingController licenseIssueDateController =
      TextEditingController();
  final TextEditingController licenseExpiryDate1Controller =
      TextEditingController();
  final TextEditingController licenseExpiryDate2Controller =
      TextEditingController();
  final TextEditingController licenseExpiryDate3Controller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Add Driver'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: driverIdController,
                  decoration: const InputDecoration(labelText: 'Driver ID'),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: statusController,
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
                TextFormField(
                  controller: allocationController,
                  decoration: const InputDecoration(labelText: 'Allocation'),
                ),
                TextFormField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: 'Contact'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: alternateContactController,
                  decoration:
                      const InputDecoration(labelText: 'Alternate Contact'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: alternateContactRelationController,
                  decoration: const InputDecoration(
                      labelText: 'Alternate Contact Relation'),
                ),
                TextFormField(
                  controller: dobController,
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      dobController.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                    }
                  },
                ),
                TextFormField(
                  controller: residenceController,
                  decoration: const InputDecoration(labelText: 'Residence'),
                ),
                TextFormField(
                  controller: licenseNumberController,
                  decoration:
                      const InputDecoration(labelText: 'License Number'),
                ),
                TextFormField(
                  controller: licenseTypeController,
                  decoration: const InputDecoration(labelText: 'License Type'),
                ),
                TextFormField(
                  controller: licenseIssueDateController,
                  decoration:
                      const InputDecoration(labelText: 'License Issue Date'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      licenseIssueDateController.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                    }
                  },
                ),
                TextFormField(
                  controller: licenseExpiryDate1Controller,
                  decoration:
                      const InputDecoration(labelText: 'License Expiry Date 1'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      licenseExpiryDate1Controller.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                    }
                  },
                ),
                TextFormField(
                  controller: licenseExpiryDate2Controller,
                  decoration:
                      const InputDecoration(labelText: 'License Expiry Date 2'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      licenseExpiryDate2Controller.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                    }
                  },
                ),
                TextFormField(
                  controller: licenseExpiryDate3Controller,
                  decoration:
                      const InputDecoration(labelText: 'License Expiry Date 3'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      licenseExpiryDate3Controller.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    DriverModel driver = DriverModel(
                      driverId: driverIdController.text.isNotEmpty
                          ? driverIdController.text
                          : "",
                      name: nameController.text.isNotEmpty
                          ? nameController.text
                          : "",
                      status: statusController.text.isNotEmpty
                          ? statusController.text
                          : "",
                      allocation: allocationController.text.isNotEmpty
                          ? allocationController.text
                          : "",
                      contact: contactController.text.isNotEmpty
                          ? contactController.text
                          : "",
                      altContact: alternateContactController.text.isNotEmpty
                          ? alternateContactController.text
                          : "",
                      altContactRelative:
                          alternateContactRelationController.text.isNotEmpty
                              ? alternateContactRelationController.text
                              : "",
                      dateOfBirth: dobController.text.isNotEmpty
                          ? dobController.text
                          : "",
                      residence: residenceController.text.isNotEmpty
                          ? residenceController.text
                          : "",
                      licenseNumber: licenseNumberController.text.isNotEmpty
                          ? licenseNumberController.text
                          : "",
                      licenseType: licenseTypeController.text.isNotEmpty
                          ? licenseTypeController.text
                          : "",
                      licenseIssueDate:
                          licenseIssueDateController.text.isNotEmpty
                              ? licenseIssueDateController.text
                              : "",
                      licenseExpiryDate1:
                          licenseExpiryDate1Controller.text.isNotEmpty
                              ? licenseExpiryDate1Controller.text
                              : "",
                      licenseExpiryDate2:
                          licenseExpiryDate2Controller.text.isNotEmpty
                              ? licenseExpiryDate2Controller.text
                              : "",
                      licenseExpiryDate3:
                          licenseExpiryDate3Controller.text.isNotEmpty
                              ? licenseExpiryDate3Controller.text
                              : "",
                    );
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    final result = await sl<CreateDriverDatabaseUseCase>()
                        .call(params: driver);
                    result.fold(
                      (l) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $l'),
                        ),
                      ),
                      (r) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Driver added successfully'),
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
