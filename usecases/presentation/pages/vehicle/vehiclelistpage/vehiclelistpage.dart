import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_management_app/data/models/vehicle/vehicle.dart';
import 'package:vehicle_management_app/presentation/pages/vehicle/vehiclelistpage/cubit/vehiclelist_cubit.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';
import 'package:vehicle_management_app/presentation/widgets/vehicle_card.dart';

class VehicleListPage extends StatelessWidget implements PreferredSizeWidget {
  const VehicleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Vehicles"),
      body: BlocBuilder<VehiclelistCubit, VehicleListState>(
        builder: (context, state) {
          if (state is VehicleListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VehicleListLoaded) {
            return ListView.builder(
              itemCount: state.props.length,
              itemBuilder: (context, index) {
                return VehicleWidget(
                  vehicle: state.props[index] as VehicleModel,
                  onTap: () {
                    // Navigate to vehicle details page
                  },
                );
              },
            );
          } else if (state is VehicleListError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}
