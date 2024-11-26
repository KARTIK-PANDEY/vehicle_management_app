import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:vehicle_management_app/data/models/user/user_application.dart';

part 'applications_state.dart';

class ApplicationsCubit extends HydratedCubit<ApplicationsState> {
  ApplicationsCubit() : super(ApplicationsInitial());

  void loadSelfApplications() {
    emit(ApplicationsLoading());
    // final user = sl<UserRepository>().getUser();
    // sl<UserRepository>().getUserApplications(user.userId).then((applications) {
    //   emit(ApplicationsLoaded(applications));
    // }).catchError((error) {
    //   emit(ApplicationsError(error.toString()));
    // });
  }

  @override
  ApplicationsState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(ApplicationsState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
