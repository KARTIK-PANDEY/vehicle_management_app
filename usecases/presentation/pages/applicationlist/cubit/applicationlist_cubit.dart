import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/web.dart';
import 'package:vehicle_management_app/data/models/user/user_application.dart';
import 'package:vehicle_management_app/domain/usecases/application/get_applications_usecase.dart';
import 'package:vehicle_management_app/service_locator.dart';

part 'applicationlist_state.dart';

class ApplicationlistCubit extends HydratedCubit<ApplicationlistState> {
  ApplicationlistCubit() : super(ApplicationlistInitial());

  void clearApplications() {
    emit(ApplicationlistInitial());
  }

  Future<void> getApplications(bool self, String designation) async {
    emit(ApplicationlistLoading());
    try {
      final applications = await sl<GetApplicationsUsecase>().call(
        params: self,
        designation: designation,
      );

      applications.fold(
        (l) => emit(ApplicationlistError(l.toString())),
        (r) {
          Logger().i(r);
          emit(ApplicationlistLoaded(r));
        },
      );
    } catch (e) {
      emit(ApplicationlistError(e.toString()));
    }
  }

  @override
  ApplicationlistState? fromJson(Map<String, dynamic> json) {
    final applications = (json['applications'] as List)
        .map((e) => (e as List)
            .map((item) =>
                UserApplication.fromJson(item as Map<String, dynamic>))
            .toList())
        .toList();
    return ApplicationlistLoaded(applications);
  }

  @override
  Map<String, dynamic>? toJson(ApplicationlistState state) {
    if (state is ApplicationlistLoaded) {
      return {'applications': state.applications};
    }
    return null;
  }
}
