import 'package:dartz/dartz.dart';
import 'package:vehicle_management_app/core/usecase/usecase.dart';
import 'package:vehicle_management_app/domain/repositories/application/application.dart';
import 'package:vehicle_management_app/service_locator.dart';

class GetSelfApplicationsUsecase extends UseCase<Either, String> {
  @override
  Future<Either> call({String? params, String? status}) async {
    return sl<ApplicationRepository>().getSelfApplications(params!, status!);
  }
}
