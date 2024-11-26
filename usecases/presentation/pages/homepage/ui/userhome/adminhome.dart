import 'package:flutter/material.dart';
import 'package:vehicle_management_app/presentation/pages/admin/add_driver.dart';
import 'package:vehicle_management_app/presentation/pages/admin/cubit/driverlist_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/admin/driver_list.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});

  final List<Map<String, dynamic>> adminFunctions = [
    {
      'title': 'Vehicle Management',
      'icon': Icons.car_rental,
      'actions': [
        {'icon': Icons.add, 'label': 'Add Vehicle', 'onPressed': () {}},
        {'icon': Icons.remove, 'label': 'Remove Vehicle', 'onPressed': () {}},
        {'icon': Icons.update, 'label': 'Update Vehicle', 'onPressed': () {}},
        {'icon': Icons.list, 'label': 'View Vehicles', 'onPressed': () {}},
      ],
    },
    {
      'title': 'Driver Management',
      'icon': Icons.person,
      'actions': [
        {
          'icon': Icons.add,
          'label': 'Add Driver',
          'onPressed': (context) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddDriver()));
          }
        },
        {'icon': Icons.remove, 'label': 'Remove Driver', 'onPressed': () {}},
        {'icon': Icons.update, 'label': 'Update Driver', 'onPressed': () {}},
        {
          'icon': Icons.list,
          'label': 'View Drivers',
          'onPressed': (context) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DriverList()));
          }
        },
      ],
    },
    {
      'title': 'Refueling',
      'icon': Icons.local_gas_station,
      'actions': [
        {'icon': Icons.add, 'label': 'Create Refueling', 'onPressed': () {}},
        {'icon': Icons.details, 'label': 'Get Refueling', 'onPressed': () {}},
        {'icon': Icons.list, 'label': 'Get Refueling List', 'onPressed': () {}},
      ],
    },
    {
      'title': 'Maintenance',
      'icon': Icons.build,
      'actions': [
        {'icon': Icons.add, 'label': 'Create Maintenance', 'onPressed': () {}},
        {'icon': Icons.details, 'label': 'Get Maintenance', 'onPressed': () {}},
        {
          'icon': Icons.list,
          'label': 'Get Maintenance List',
          'onPressed': () {}
        },
      ],
    },
    {
      'title': 'User Management',
      'icon': Icons.supervisor_account,
      'actions': [
        {'icon': Icons.add, 'label': 'Create User', 'onPressed': () {}},
        {
          'icon': Icons.person_add,
          'label': 'Create Driver',
          'onPressed': () {}
        },
        {'icon': Icons.delete, 'label': 'Delete User', 'onPressed': () {}},
        {
          'icon': Icons.details,
          'label': 'Get Driver Details',
          'onPressed': () {}
        },
        {'icon': Icons.list, 'label': 'Get Driver List', 'onPressed': () {}},
      ],
    },
    {
      'title': 'Application Management',
      'icon': Icons.app_registration,
      'actions': [
        {
          'icon': Icons.update,
          'label': 'Update Applications',
          'onPressed': () {}
        },
        {
          'icon': Icons.post_add,
          'label': 'Create Application',
          'onPressed': () {}
        },
        {'icon': Icons.details, 'label': 'Get Application', 'onPressed': () {}},
        {'icon': Icons.list, 'label': 'Get Applications', 'onPressed': () {}},
        {
          'icon': Icons.business,
          'label': 'Get Branch Applications',
          'onPressed': () {}
        },
        {
          'icon': Icons.person,
          'label': 'Get Self Applications',
          'onPressed': () {}
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: ListView.builder(
          itemCount: adminFunctions.length,
          itemBuilder: (context, sectionIndex) {
            final section = adminFunctions[sectionIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    section['title'],
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 4 : 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: section['actions'].length,
                  itemBuilder: (context, actionIndex) {
                    final action = section['actions'][actionIndex];
                    return Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          action['onPressed'](context);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Action for ${action['label']}'),
                            ),
                          );
                        },
                        icon: Icon(action['icon']),
                        label: Text(action['label']),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          fixedSize: const Size(120, 60),
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
              ],
            );
          },
        ),
      ),
    );
  }
}
