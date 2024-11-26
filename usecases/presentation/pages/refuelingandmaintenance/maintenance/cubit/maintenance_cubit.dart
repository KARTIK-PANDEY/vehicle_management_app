import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:vehicle_management_app/data/models/vehicle/maintenance_record.dart';

part 'maintenance_state.dart';

class MaintenanceCubit extends HydratedCubit<MiantenanceState> {
  MaintenanceCubit() : super(MiantenanceInitial());

  @override
  MiantenanceState? fromJson(Map<String, dynamic> json) {
    final maintenances = (json['maintenances'] as List<dynamic>?)
        ?.map((e) => MaintenanceRecord.fromJson(e as Map<String, dynamic>))
        .toList();
    return maintenances != null
        ? MiantenanceLoaded(maintenances)
        : MiantenanceInitial();
  }

  @override
  Map<String, dynamic>? toJson(MiantenanceState state) {
    if (state is MiantenanceLoaded) {
      return {
        'maintenances': state.maintenances.map((e) => e.toJson()).toList(),
      };
    }
    return null;
  }
}
