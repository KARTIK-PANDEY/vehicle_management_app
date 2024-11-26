import 'package:dartz/dartz.dart';
import 'package:vehicle_management_app/core/usecase/usecase.dart';
import 'package:vehicle_management_app/domain/repositories/application/application.dart';
import 'package:vehicle_management_app/service_locator.dart';

class GetApplicationsUsecase extends UseCase<Either, bool> {
  @override
  Future<Either> call({bool? params, String? designation}) async {
    return sl<ApplicationRepository>().getApplications(params!, designation!);
  }
}
