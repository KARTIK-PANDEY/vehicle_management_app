import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:vehicle_management_app/common/utils/picklocation.dart';
import 'package:vehicle_management_app/data/models/user/user_application.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';

class ApplicationForm extends StatefulWidget {
  const ApplicationForm({super.key, required this.uid, required this.role});

  final String uid;
  final String role;

  @override
  State<ApplicationForm> createState() => _VehicleRequestFormState();
}

class _VehicleRequestFormState extends State<ApplicationForm> {
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  List<double> sourceCoordinates = [0.0, 0.0];
  List<double> destinationCoordinates = [0.0, 0.0];
  final _formKey = GlobalKey<FormState>();

  bool isRoundTrip = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CommonAppBar(
          title: 'Vehicle Request Form',
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: [
              const Text('\tEnter source'),
              sourceField(),
              const SizedBox(height: 15),
              const Text('\tEnter destination'),
              destinationField(),
              const SizedBox(height: 15),
              const Text('Purpose of Travel'),
              purposeField(),
              const SizedBox(height: 15),
              isRoundTripCheckbox(),
              const SizedBox(height: 15),
              const Text("Select Date of Travel"),
              dateField(),
              const SizedBox(height: 15),
              const Text("Select Time of Travel"),
              timeField(),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  const uuid = Uuid();
                  UserApplication application = UserApplication(
                    bookingId: uuid.v4(),
                    sourceName: sourceController.text,
                    destinationName: destinationController.text,
                    sourceCoordinates: sourceCoordinates,
                    destinationCoordinates: destinationCoordinates,
                    date: dateController.text,
                    time: timeController.text,
                    accepted: 'false',
                    rejectionComment: '',
                    purpose: purposeController.text,
                    driverId: '',
                    vehicleId: '',
                    createdAt: DateTime.now().toString(),
                    roundTrip: isRoundTrip.toString(),
                    userId: widget.uid,
                    status: widget.role == 'user'
                        ? 3
                        : widget.role == 'hod'
                            ? 2
                            : 1,
                  );
                  context.go(
                    '/home/applicationform/reviewapplication?who=review',
                    extra: application,
                  );
                },
                icon: const Icon(Icons.preview),
                label: const Text('Preview'),
              ),
            ],
          ),
        ));
  }

  Widget sourceField() {
    return TextFormField(
        controller: sourceController,
        readOnly: true,
        onTap: () => {
              _pickLocation(context, sourceController, true),
            },
        decoration: InputDecoration(
          hintText: 'Pick a Source location',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a source location';
          }
          return null;
        });
  }

  Widget destinationField() {
    return TextFormField(
      controller: destinationController,
      readOnly: true,
      onTap: () => {
        _pickLocation(context, destinationController, false),
      },
      decoration: InputDecoration(
        hintText: 'Pick a Destination location',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a destination location';
        }
        return null;
      },
    );
  }

  Widget purposeField() {
    return TextFormField(
      controller: purposeController,
      maxLines: 4,
      decoration: const InputDecoration(
        hintText: 'Purpose of Travel',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a purpose';
        }
        return null;
      },
    );
  }

  Widget isRoundTripCheckbox() {
    return CheckboxListTile(
      title: const Text('Round Trip?'),
      value: isRoundTrip,
      onChanged: (value) {
        setState(() {
          isRoundTrip = value!;
        });
      },
    );
  }

  Widget dateField() {
    return TextFormField(
      enabled: true,
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        ).then((value) {
          if (value != null) {
            dateController.text = value.toString().substring(0, 10);
          }
        });
      },
      controller: dateController,
      readOnly: true,
      decoration: const InputDecoration(
        hintText: 'Date',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  Widget timeField() {
    return TextFormField(
      controller: timeController,
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() {
            timeController.text = picked.toString().substring(10, 15);
          });
        }
      },
      readOnly: true,
      decoration: const InputDecoration(
        hintText: 'Time',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a time';
        }
        return null;
      },
    );
  }

  _pickLocation(BuildContext context, TextEditingController controller,
      bool isSource) async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PickLocation(),
      ),
    );

    if (selectedLocation != null) {
      LatLng position = selectedLocation['position'];
      final name = selectedLocation['name'];
      controller.text = name;
      if (isSource) {
        sourceCoordinates = [position.latitude, position.longitude];
      } else {
        destinationCoordinates = [position.latitude, position.longitude];
      }

      print(position);
    }
  }
}
