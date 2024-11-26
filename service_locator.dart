import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicle_management_app/data/repositories/applications/application_repository_impl.dart';
import 'package:vehicle_management_app/data/repositories/auth/auth_repository_impl.dart';
import 'package:vehicle_management_app/data/repositories/user/user_repository_impl.dart';
import 'package:vehicle_management_app/data/repositories/vehicle/maintenance_repository_impl.dart.dart';
import 'package:vehicle_management_app/data/repositories/vehicle/refueling_repository_impl.dart';
import 'package:vehicle_management_app/data/repositories/vehicle/vehicle_repository_impl.dart';
import 'package:vehicle_management_app/data/sources/auth_firebase_service.dart';
import 'package:vehicle_management_app/data/sources/firebase_firestore_services.dart';
import 'package:vehicle_management_app/data/sources/location_services.dart';
import 'package:vehicle_management_app/domain/repositories/application/application.dart';
import 'package:vehicle_management_app/domain/repositories/auth/auth.dart';
import 'package:vehicle_management_app/domain/repositories/user/user.dart';
import 'package:vehicle_management_app/domain/repositories/vehicle/maintenance.dart';
import 'package:vehicle_management_app/domain/repositories/vehicle/refueling.dart';
import 'package:vehicle_management_app/domain/repositories/vehicle/vehicle.dart';
import 'package:vehicle_management_app/domain/usecases/application/create_application_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/application/get_application_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/application/get_applications_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/application/get_branch_applications_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/application/get_self_applications_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/application/update_applications_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/auth/sigin.dart';
import 'package:vehicle_management_app/domain/usecases/auth/signout.dart';
import 'package:vehicle_management_app/domain/usecases/auth/signup.dart';
import 'package:vehicle_management_app/domain/usecases/user/create_driverdatabase_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/user/create_userdatabase_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/user/delete_userdatabase_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/user/get_driver_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/user/get_driverlist_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/user/get_user_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/vehicle/create_maintenance.dart';
import 'package:vehicle_management_app/domain/usecases/vehicle/create_refueling.dart';
import 'package:vehicle_management_app/domain/usecases/vehicle/create_vehicle_usecase.dart';
import 'package:vehicle_management_app/domain/usecases/vehicle/get_maintenance.dart';
import 'package:vehicle_management_app/domain/usecases/vehicle/get_maintenance_list.dart';
import 'package:vehicle_management_app/domain/usecases/vehicle/get_refueling.dart';
import 'package:vehicle_management_app/domain/usecases/vehicle/get_refueling_list.dart';
import 'package:vehicle_management_app/domain/usecases/vehicle/get_vehicle.dart';
import 'package:vehicle_management_app/domain/usecases/vehicle/get_vehicle_list.dart';
import 'package:vehicle_management_app/presentation/pages/feedback/cubit/feedback_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Authservices
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerSingleton<SignoutUseCase>(SignoutUseCase());

  // Firestore services
  sl.registerSingleton<FirestoreService>(FirestoreServiceImpl());

  // Vehicle services
  sl.registerSingleton<VehicleRepository>(VehicleRepositoryImpl());
  sl.registerSingleton<GetVehicleUsecase>(GetVehicleUsecase());
  sl.registerSingleton<CreateVehicleUsecase>(CreateVehicleUsecase());
  sl.registerSingleton<GetVehicleListUsecase>(GetVehicleListUsecase());
  sl.registerSingleton<RefuelingRepository>(RefuelingRepositoryImpl());
  sl.registerSingleton<MaintenanceRepository>(MaintenanceRepositoryImpl());
  sl.registerSingleton<CreateMaintenanceUsecase>(CreateMaintenanceUsecase());
  sl.registerSingleton<CreateRefuelingUsecase>(CreateRefuelingUsecase());
  sl.registerSingleton<GetRefuelingUsecase>(GetRefuelingUsecase());
  sl.registerSingleton<GetMaintenanceUsecase>(GetMaintenanceUsecase());
  sl.registerSingleton<GetRefuelingListUsecase>(GetRefuelingListUsecase());
  sl.registerSingleton<GetMaintenanceListUsecase>(GetMaintenanceListUsecase());

  // User services
  sl.registerSingleton<UserRepository>(UserRepositoryImpl());
  sl.registerSingleton<CreateUserdatabseUseCase>(CreateUserdatabseUseCase());
  sl.registerSingleton<CreateDriverDatabaseUseCase>(
      CreateDriverDatabaseUseCase());
  sl.registerSingleton<DeleteUserDatabaseUseCase>(DeleteUserDatabaseUseCase());
  sl.registerSingleton<GetDriverUseCase>(GetDriverUseCase());
  // sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerSingleton<GetDriverListUseCase>(GetDriverListUseCase());
  sl.registerFactory(() => FeedbackCubit());

  // Application services
  sl.registerSingleton<ApplicationRepository>(ApplicationRepositoryImpl());
  sl.registerSingleton<UpdateApplicationsUsecase>(UpdateApplicationsUsecase());
  sl.registerSingleton<CreateApplicationUsecase>(CreateApplicationUsecase());
  sl.registerSingleton<GetApplicationUsecase>(GetApplicationUsecase());
  sl.registerSingleton<GetApplicationsUsecase>(GetApplicationsUsecase());
  sl.registerSingleton<GetBranchApplicationsUsecase>(
      GetBranchApplicationsUsecase());
  sl.registerSingleton<GetSelfApplicationsUsecase>(
      GetSelfApplicationsUsecase());

  // Location services
  sl.registerSingleton<LocationServices>(LocationServices());
}
