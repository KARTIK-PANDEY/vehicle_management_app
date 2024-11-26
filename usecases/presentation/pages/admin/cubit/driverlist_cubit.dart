import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:vehicle_management_app/data/models/user/driver.dart';
import 'package:vehicle_management_app/domain/usecases/user/get_driverlist_usecase.dart';
import 'package:vehicle_management_app/service_locator.dart';

part 'driverlist_state.dart';

class DriverlistDartCubit extends HydratedCubit<DriverlistDartState> {
  DriverlistDartCubit() : super(DriverlistDartLoading());

  void getDrivers() async {
    emit(DriverlistDartLoading());
    try {
      final drivers = await sl<GetDriverListUseCase>().call();
      drivers.fold(
        (l) => emit(DriverlistDartError(l.toString())),
        (r) => emit(DriverlistDartLoaded(r)),
      );
    } catch (e) {
      emit(DriverlistDartError(e.toString()));
    }
  }

  @override
  DriverlistDartState? fromJson(Map<String, dynamic> json) {
    try {
      final drivers = (json['drivers'] as List)
          .map((driver) => DriverModel.fromJson(driver))
          .toList();
      return DriverlistDartLoaded(drivers);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(DriverlistDartState state) {
    if (state is DriverlistDartLoaded) {
      return {
        'drivers': (state).drivers.map((driver) => driver.toJson()).toList(),
      };
    }
    return null;
  }
}
