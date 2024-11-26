import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:vehicle_management_app/core/config/constants/sample_vehicle_data.dart';
import 'package:vehicle_management_app/data/models/vehicle/vehicle.dart';

part 'vehiclelist_state.dart';

class VehiclelistCubit extends HydratedCubit<VehicleListState> {
  VehiclelistCubit() : super(VehicleListLoaded(vehicles: vehicleList));

  Future<void> fetchVehicleList() async {
    // emit(VehicleListLoading());
    // final result = await sl<GetVehicleListUsecase>().call();
    // result.fold(
    //   (l) {
    //     emit(VehicleListError(message: l.message));
    //   },
    //   (r) {
    //     emit(VehicleListLoaded(vehicles: r));
    //   },
    // );
    emit(VehicleListLoaded(vehicles: vehicleList));
  }

  @override
  VehicleListState? fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(VehicleListState state) {
    throw UnimplementedError();
  }
}
