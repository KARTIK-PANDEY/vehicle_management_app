import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:vehicle_management_app/data/models/user/user.dart';
import 'package:vehicle_management_app/domain/usecases/user/get_driver_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/user/get_user_usecase.dart';
import 'package:vehicle_management_app/service_locator.dart';

class ProfileCubit extends HydratedCubit<dynamic> {
  ProfileCubit() : super(null);

  void clearProfile() {
    emit(null);
  }

  Future<void> getUserProfile(String role, String? id_) async {
    dynamic result;
    if (role == 'driver') {
      result = await sl<GetDriverUseCase>().call(params: id_);
    } else {
      result = await sl<GetUserUseCase>().call(params: "");
    }
    result.fold(
      (l) => emit(null),
      (r) => emit(r),
    );
  }

  @override
  UserModel? fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(dynamic state) {
    return state?.toJson();
  }
}
