import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_management_app/presentation/pages/admin/cubit/driverlist_cubit.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';

class DriverList extends StatefulWidget {
  const DriverList({super.key});

  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList>
    with AutomaticKeepAliveClientMixin {
  @override
  initState() {
    super.initState();
    context.read<DriverlistDartCubit>().getDrivers();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: const CommonAppBar(title: "Driver List"),
      body: BlocBuilder<DriverlistDartCubit, DriverlistDartState>(
        builder: (context, state) {
          if (state is DriverlistDartInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DriverlistDartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DriverlistDartLoaded) {
            return ListView.builder(
              itemCount: state.drivers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.drivers[index].name),
                  subtitle: Text(state.drivers[index].contact),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Error loading drivers"),
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
