import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:location/location.dart';
import 'package:vehicle_management_app/data/sources/location_services.dart';
import 'package:vehicle_management_app/service_locator.dart';

part 'currentlocation_state.dart';

class CurrentlocationCubit extends HydratedCubit<CurrentlocationState> {
  CurrentlocationCubit() : super(CurrentlocationInitial());

  Future<void> getCurrentLocation() async {
    var status = await sl<LocationServices>().isPermissionGranted();
    if (status == PermissionStatus.denied) {
      await sl<LocationServices>().requestService();
    }
    var locationData = await sl<LocationServices>().getCurrentLocation();
    emit(
        CurrentlocationLoaded(locationData.latitude!, locationData.longitude!));
  }

  @override
  CurrentlocationState? fromJson(Map<String, dynamic> json) {
    try {
      final latitude = json['latitude'] as double;
      final longitude = json['longitude'] as double;
      return CurrentlocationLoaded(latitude, longitude);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CurrentlocationState state) {
    if (state is CurrentlocationLoaded) {
      return {
        'latitude': state.latitude,
        'longitude': state.longitude,
      };
    }
    return null;
  }
}
