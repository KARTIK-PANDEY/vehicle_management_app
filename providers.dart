import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_management_app/presentation/cubit/currentlocation/currentlocation_cubit.dart';
import 'package:vehicle_management_app/presentation/cubit/theme_cubit/theme_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/admin/cubit/driverlist_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/applicationlist/cubit/applicationlist_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/user/profilescreen/cubit/profile_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/vehicle/vehiclelistpage/cubit/vehiclelist_cubit.dart';

class BlocProviders {
  static List<BlocProvider> get providers => [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<CurrentlocationCubit>(
            create: (_) => CurrentlocationCubit()),
        BlocProvider<ProfileCubit>(create: (_) => ProfileCubit()),
        BlocProvider<VehiclelistCubit>(
          create: (context) => VehiclelistCubit(),
        ),
        BlocProvider<DriverlistDartCubit>(
            create: (context) => DriverlistDartCubit()),
        BlocProvider<ApplicationlistCubit>(
            create: (context) => ApplicationlistCubit()),
      ];
}
