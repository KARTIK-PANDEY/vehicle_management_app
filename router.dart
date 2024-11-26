import 'package:go_router/go_router.dart';
import 'package:vehicle_management_app/data/models/user/user_application.dart';
import 'package:vehicle_management_app/presentation/pages/application/application_form.dart';
import 'package:vehicle_management_app/presentation/pages/auth/completeprofilepage/completeprofile.dart';
import 'package:vehicle_management_app/presentation/pages/auth/signinpage/signinpage.dart';
import 'package:vehicle_management_app/presentation/pages/auth/signuppage/signuppage.dart';
import 'package:vehicle_management_app/presentation/pages/getstartedpage/getstartedpage.dart';
import 'package:vehicle_management_app/presentation/pages/homepage/ui/homepage.dart';
import 'package:vehicle_management_app/presentation/pages/refuelingandmaintenance/maintenance/maintenancelist.dart';
import 'package:vehicle_management_app/presentation/pages/refuelingandmaintenance/refueling/refuelinglist.dart';
import 'package:vehicle_management_app/presentation/pages/reviewapplication/reviewapplicationpage.dart';
import 'package:vehicle_management_app/presentation/pages/spashscreen/splashscreen.dart';
import 'package:vehicle_management_app/presentation/pages/user/profilescreen/profilescreenpage.dart';
import 'package:vehicle_management_app/presentation/pages/vehicle/vehiclelistpage/vehiclelistpage.dart';

final GoRouter router = GoRouter(
  initialLocation: "/splash",
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => Splashscreen(),
    ),
    GoRoute(
      path: '/getstarted',
      builder: (context, state) => const GetStartedPage(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) => SigninPage(),
        ),
        GoRoute(
          path: 'signup',
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: "completeprofile",
          builder: (context, state) => const CompleteProfilePage(),
        )
      ],
    ),
    GoRoute(path: '/', redirect: (context, state) => '/home'),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Homepage(),
      routes: [
        GoRoute(
          path: 'vehiclelist',
          builder: (context, state) => const VehicleListPage(),
        ),
        GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreenPage()),
        GoRoute(
          path: 'applicationform',
          builder: (context, state) {
            final uid = state.uri.queryParameters['uid'] ?? '';
            final role = state.uri.queryParameters['role'] ?? '';
            return ApplicationForm(uid: uid, role: role);
          },
          routes: [
            GoRoute(
              path: 'reviewapplication',
              builder: (context, state) {
                final application = state.extra as UserApplication;
                final who = state.uri.queryParameters['who'] ?? '';
                return ReviewApplicationPage(
                  application: application,
                  who: who,
                );
              },
            ),
          ],
        ),
        GoRoute(
            path: 'reviewapplication',
            builder: (context, state) {
              final application = state.extra as UserApplication;
              final who = state.uri.queryParameters['who'] ?? '';
              return ReviewApplicationPage(
                application: application,
                who: who,
              );
            }),
        GoRoute(
            path: 'refueling',
            builder: (context, state) => const RefuelingList()),
        GoRoute(
            path: 'maintenance',
            builder: (context, state) => const MaintenanceList()),
      ],
    ),
  ],
);
