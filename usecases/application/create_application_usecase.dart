import 'package:dartz/dartz.dart';
import 'package:vehicle_management_app/core/usecase/usecase.dart';
import 'package:vehicle_management_app/data/models/user/user_application.dart';
import 'package:vehicle_management_app/domain/repositories/application/application.dart';
import 'package:vehicle_management_app/service_locator.dart';

class CreateApplicationUsecase extends UseCase<Either, UserApplication> {
  @override
  Future<Either> call({UserApplication? params}) {
    return sl<ApplicationRepository>().createApplication(params!);
  }
}
