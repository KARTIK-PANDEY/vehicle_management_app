import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_management_app/data/models/user/user.dart';
import 'package:vehicle_management_app/domain/usecases/user/create_userdatabase_usecase.dart';
import 'package:vehicle_management_app/presentation/pages/homepage/ui/homepage.dart';
import 'package:vehicle_management_app/presentation/widgets/authappbutton.dart';
import 'package:vehicle_management_app/core/config/constants/university_data.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';
import 'package:vehicle_management_app/service_locator.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _contactNumberController =
      TextEditingController();

  final TextEditingController _employeeIdController = TextEditingController();

  final TextEditingController _departmentController = TextEditingController();

  final TextEditingController _teachingDepartmentController =
      TextEditingController();

  final TextEditingController _designationController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  bool isUTD = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Complete Profile"),
      body: Stack(
        children: [
          Form(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Complete Your Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          fullNameField(context),
                          const SizedBox(height: 20),
                          emailField(context),
                          const SizedBox(height: 20),
                          contactNumberField(context),
                          const SizedBox(height: 20),
                          employeeIdField(context),
                          const SizedBox(height: 20),
                          adminDepartmentDropdown(context),
                          const SizedBox(height: 20),
                          // if (isUTD) ...[
                          //   teachingDepartmentDropdown(context),
                          //   const SizedBox(height: 20)
                          // ],
                          designationDropdown(context),
                          const SizedBox(height: 20),
                          AuthAppButton(
                            text: "Continue",
                            onPressed: () async {
                              FocusNode().unfocus();
                              log('Full Name: ${_fullNameController.text}, '
                                  'Email: ${_auth.currentUser!.email.toString()}, '
                                  'Contact Number: ${_contactNumberController.text}, '
                                  'Employee ID: ${_employeeIdController.text}, '
                                  'Department: ${_departmentController.text}, '
                                  'Designation: ${_designationController.text}');
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              var result =
                                  await sl<CreateUserdatabseUseCase>().call(
                                params: UserModel(
                                  fullName: _fullNameController.text,
                                  createdAt: DateTime.now().toString(),
                                  uid: _auth.currentUser!.uid.toString(),
                                  email: _auth.currentUser?.email ?? '',
                                  contactNumber: _contactNumberController.text,
                                  employeeId: _employeeIdController.text,
                                  department: _departmentController.text,
                                  designation: _designationController.text,
                                ),
                              );

                              if (context.mounted) {
                                result.fold(
                                  (l) {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (builder) {
                                        return AlertDialog(
                                          title: const Text('Error'),
                                          content: Text(l.toString()),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  (r) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content:
                                            Text('User created successfully'),
                                      ),
                                    );
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                const Homepage(),
                                        transitionsBuilder: (context,
                                            animation1, animation2, child) {
                                          return FadeTransition(
                                            opacity: animation1,
                                            child: child,
                                          );
                                        },
                                        transitionDuration:
                                            const Duration(milliseconds: 500),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget emailField(BuildContext context) {
    return TextFormField(
      initialValue: _auth.currentUser?.email.toString(),
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget fullNameField(BuildContext context) {
    return TextFormField(
      controller: _fullNameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        prefixIcon: const Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your full name';
        }
        return null;
      },
    );
  }

  Widget contactNumberField(BuildContext context) {
    return TextFormField(
      controller: _contactNumberController,
      decoration: InputDecoration(
        labelText: 'Contact Number',
        prefixIcon: const Icon(Icons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your contact number';
        } else if (value.length < 10 || value.length > 10) {
          return 'Please enter a valid contact number';
        }
        return null;
      },
    );
  }

  Widget employeeIdField(BuildContext context) {
    return TextFormField(
      controller: _employeeIdController,
      decoration: InputDecoration(
        labelText: 'Employee ID',
        prefixIcon: const Icon(Icons.badge),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your employee ID';
        }
        return null;
      },
    );
  }

  Widget teachingDepartmentDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Sub Department',
        prefixIcon: const Icon(Icons.business),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: teachingDepartments.map((String department) {
        return DropdownMenuItem<String>(
          value: department,
          child: Text(department),
        );
      }).toList(),
      onChanged: (String? newValue) {
        _teachingDepartmentController.text = newValue!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your department';
        }
        return null;
      },
    );
  }

  Widget adminDepartmentDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Department',
        prefixIcon: const Icon(Icons.business),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: adminDepartments.map((String department) {
        return DropdownMenuItem<String>(
          value: department,
          child: Text(department),
        );
      }).toList(),
      onChanged: (String? newValue) {
        _departmentController.text = newValue!;
        if (newValue == 'UTD') {
          setState(() {
            isUTD = true;
          });
        } else {
          setState(() {
            isUTD = false;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your department';
        }
        return null;
      },
    );
  }

  Widget designationDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Designation',
        prefixIcon: const Icon(Icons.work),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: designations.map((String designation) {
        return DropdownMenuItem<String>(
          value: designation,
          child: Text(designation),
        );
      }).toList(),
      onChanged: (String? newValue) {
        _designationController.text = newValue!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your designation';
        }
        return null;
      },
    );
  }
}
