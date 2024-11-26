import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vehicle_management_app/common/utils/picklocation.dart';
import 'package:vehicle_management_app/data/models/user/user_application.dart';
import 'package:vehicle_management_app/data/sources/location_services.dart';
import 'package:vehicle_management_app/domain/usecases/application/create_application_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/application/update_applications_usecase.dart';
import 'package:vehicle_management_app/presentation/pages/admin/cubit/driverlist_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/applicationlist/cubit/applicationlist_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/vehicle/vehiclelistpage/cubit/vehiclelist_cubit.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';
import 'package:vehicle_management_app/service_locator.dart';

class ReviewApplicationPage extends StatefulWidget {
  const ReviewApplicationPage({
    super.key,
    required this.application,
    required this.who,
  });

  final UserApplication application;
  final String who;

  @override
  State<ReviewApplicationPage> createState() => _ReviewApplicationPageState();
}

class _ReviewApplicationPageState extends State<ReviewApplicationPage> {
  dynamic directions;

  @override
  void initState() {
    super.initState();

    getDirections();
  }

  getDirections() async {
    final response = await sl<LocationServices>().getDirections(
      "${widget.application.sourceCoordinates[0]},${widget.application.sourceCoordinates[1]}",
      "${widget.application.destinationCoordinates[0]},${widget.application.destinationCoordinates[1]}",
    );

    final Map<String, dynamic> data = response;
    final List<LatLng> polylineCoordinates = [];

    if (data['routes'] != null && data['routes'].isNotEmpty) {
      final route = data['routes'][0];
      if (route['legs'] != null && route['legs'].isNotEmpty) {
        final leg = route['legs'][0];
        if (leg['steps'] != null && leg['steps'].isNotEmpty) {
          for (var step in leg['steps']) {
            final startLocation = step['start_location'];
            final endLocation = step['end_location'];
            polylineCoordinates
                .add(LatLng(startLocation['lat'], startLocation['lng']));
            polylineCoordinates
                .add(LatLng(endLocation['lat'], endLocation['lng']));
          }
        }
      }
    }

    setState(() {
      directions = polylineCoordinates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Preview Application',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: directions == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.application.sourceCoordinates[0],
                          widget.application.sourceCoordinates[1]),
                      zoom: 12,
                    ),
                    polygons: {
                      Polygon(
                        polygonId: const PolygonId('source'),
                        points: [
                          LatLng(widget.application.sourceCoordinates[0],
                              widget.application.sourceCoordinates[1]),
                          LatLng(
                              widget.application.sourceCoordinates[0] + 0.001,
                              widget.application.sourceCoordinates[1] + 0.001),
                          LatLng(
                              widget.application.sourceCoordinates[0] + 0.001,
                              widget.application.sourceCoordinates[1] - 0.001),
                          LatLng(widget.application.sourceCoordinates[0],
                              widget.application.sourceCoordinates[1] - 0.001),
                        ],
                        strokeWidth: 2,
                        strokeColor: Colors.red,
                        fillColor: Colors.red.withOpacity(0.3),
                      ),
                      Polygon(
                        polygonId: const PolygonId('destination'),
                        points: [
                          LatLng(widget.application.destinationCoordinates[0],
                              widget.application.destinationCoordinates[1]),
                          LatLng(
                              widget.application.destinationCoordinates[0] +
                                  0.001,
                              widget.application.destinationCoordinates[1] +
                                  0.001),
                          LatLng(
                              widget.application.destinationCoordinates[0] +
                                  0.001,
                              widget.application.destinationCoordinates[1] -
                                  0.001),
                          LatLng(
                              widget.application.destinationCoordinates[0],
                              widget.application.destinationCoordinates[1] -
                                  0.001),
                        ],
                        strokeWidth: 2,
                        strokeColor: Colors.green,
                        fillColor: Colors.green.withOpacity(0.3),
                      ),
                    },
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route'),
                        points: directions ?? [],
                        color: Colors.blue,
                        width: 5,
                      ),
                    },
                  ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(Icons.location_on, 'Source',
                                widget.application.sourceName),
                            _buildInfoRow(Icons.location_on, 'Destination',
                                widget.application.destinationName),
                            _buildInfoRow(Icons.work, 'Purpose',
                                widget.application.purpose),
                            _buildInfoRow(Icons.calendar_today, 'Date',
                                widget.application.date),
                            _buildInfoRow(Icons.access_time, 'Time',
                                widget.application.time),
                            _buildInfoRow(
                                Icons.check_circle,
                                'Status',
                                (widget.application.status == 1)
                                    ? 'Accepted'
                                    : widget.application.status == -1
                                        ? 'Rejected'
                                        : widget.application.status == 0
                                            ? 'Completed'
                                            : 'Pending'),
                            _buildInfoRow(
                                Icons.repeat,
                                'Round Trip',
                                widget.application.roundTrip == 'true'
                                    ? 'Yes'
                                    : 'No'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomnavbar(context, widget.who),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _bottomnavbar(BuildContext context, String who) {
    if (who == 'review') {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Download logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Not yet implemented'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: const Text('Download',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    final result = await sl<CreateApplicationUsecase>()
                        .call(params: widget.application);
                    result.fold(
                      (error) {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.message),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      (success) {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Application submitted successfully'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        context.go('/home');
                      },
                    );
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('Submit',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (who == "hod" &&
        widget.application.userId != sl<FirebaseAuth>().currentUser!.uid &&
        widget.application.status == 3) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final rejectionComment = TextEditingController();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('Rejection Comment'),
                            content: TextField(
                              controller: rejectionComment,
                              decoration: const InputDecoration(
                                hintText: 'Enter rejection comment',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (rejectionComment.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please enter a comment'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return;
                                  }
                                  context.pop();
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );

                                  await sl<UpdateApplicationsUsecase>().call(
                                    params: {
                                      'status': -1,
                                      'rejectionComment': rejectionComment.text,
                                    },
                                    id: widget.application.bookingId,
                                  ).whenComplete(
                                    () {
                                      context.pop();
                                      context.go('/home');
                                    },
                                  );
                                },
                                child: const Text('Reject'),
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.remove, color: Colors.white),
                  label: const Text('Reject',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Approve Application'),
                          content: const Text(
                              'Are you sure you want to approve this application?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                context.pop();
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                                sl<UpdateApplicationsUsecase>().call(
                                  params: {'status': 2},
                                  id: widget.application.bookingId,
                                ).whenComplete(() {
                                  context.pop();
                                  context.go('/home');
                                });
                              },
                              child: const Text('Approve'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('Approve',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (who == "allocator") {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final rejectionComment = TextEditingController();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('Rejection Comment'),
                            content: TextField(
                              controller: rejectionComment,
                              decoration: const InputDecoration(
                                hintText: 'Enter rejection comment',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (rejectionComment.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please enter a comment'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return;
                                  }
                                  context.pop();
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );

                                  sl<UpdateApplicationsUsecase>().call(
                                    params: {
                                      'status': -1,
                                      'rejectionComment': rejectionComment.text,
                                    },
                                    id: widget.application.bookingId,
                                  ).whenComplete(
                                    () {
                                      context.pop();
                                      context.go('/home');
                                    },
                                  );
                                },
                                child: const Text('Reject'),
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: const Text('Reject',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        final vehicleId = TextEditingController();
                        final driverId = TextEditingController();
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Allocate Vehicle and Driver',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              _vehicleDropdown(context, vehicleId),
                              const SizedBox(height: 16),
                              _driverDropdown(context, driverId),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (vehicleId.text.isEmpty ||
                                    driverId.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please select a vehicle and driver'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }
                                context.pop();
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                                sl<UpdateApplicationsUsecase>().call(
                                  params: {
                                    'status': 1,
                                    'vehicleId': vehicleId.text,
                                    'driverId': driverId.text.toLowerCase(),
                                  },
                                  id: widget.application.bookingId,
                                ).whenComplete(() {
                                  context.pop();
                                  context.go('/home');
                                });
                              },
                              child: const Text('Approve'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('Approve',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (who == 'completion') {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text(
                              'Are you sure you want to complete this ride?',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                  await sl<UpdateApplicationsUsecase>().call(
                                    params: {'status': 0},
                                    id: widget.application.bookingId,
                                  ).whenComplete(() {
                                    if (context.mounted) {
                                      context.pop();
                                      context.go('/home');
                                    }
                                  });
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('Complete',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  _vehicleDropdown(BuildContext content, TextEditingController vehicleId) {
    return BlocBuilder<VehiclelistCubit, VehicleListState>(
      builder: (context, state) {
        if (state is VehicleListLoaded) {
          return SingleChildScrollView(
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Select Vehicle',
                border: OutlineInputBorder(),
              ),
              items: state.vehicles
                  .where((vehicle) => vehicle.user != '')
                  .toList()
                  .map(
                    (vehicle) => DropdownMenuItem(
                      value: vehicle,
                      child: Text(
                          "${vehicle.manufacturer} ${vehicle.brand} ${vehicle.registrationNumber}"),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                vehicleId.text = value?.vehicleId ?? '';
              },
            ),
          );
        } else if (state is VehicleListError) {
          return Center(child: Text(state.message));
        } else if (state is VehicleListLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return const SizedBox();
      },
    );
  }

  _driverDropdown(BuildContext content, TextEditingController driverId) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: BlocBuilder<DriverlistDartCubit, DriverlistDartState>(
        builder: (context, state) {
          if (state is DriverlistDartLoaded) {
            return SingleChildScrollView(
              child: DropdownButtonFormField(
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Select Driver',
                  border: OutlineInputBorder(),
                ),
                items: state.drivers
                    .map(
                      (driver) => DropdownMenuItem(
                        value: driver,
                        child: Text(
                          "${driver.name} | Status:${driver.status}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  driverId.text = value?.driverId ?? '';
                },
              ),
            );
          } else if (state is DriverlistDartError) {
            return Center(child: Text(state.message));
          } else if (state is DriverlistDartLoading) {
            context.read<DriverlistDartCubit>().getDrivers();
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox();
        },
      ),
    );
  }
}
