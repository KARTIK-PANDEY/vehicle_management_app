import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_management_app/common/helpers/isinternetconnected.dart';
import 'package:vehicle_management_app/common/helpers/isloggedin.dart';
import 'package:vehicle_management_app/common/utils/picklocation.dart';
import 'package:vehicle_management_app/common/utils/requestpermissions.dart';
import 'package:vehicle_management_app/presentation/pages/user/profilescreen/cubit/profile_cubit.dart';
import 'package:vehicle_management_app/presentation/widgets/getstartedlogo.dart';

class Splashscreen extends StatelessWidget {
  Splashscreen({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  isUserLoggedIn() {
    return auth.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        bool isconnected = await context.isInternetConnected();
        await RequestPermissions.requestLocationPermission();
        log('isconnected: $isconnected');
        if (!isconnected) {
          showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('No Internet Connection'),
                  content: const Text(
                      'Please check your internet connection and try again'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          context.pop();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            SystemNavigator.pop();
                          });
                        },
                        child: const Text('OK'))
                  ],
                );
              });
          return null;
        }
      }
      bool isLoggedIn = isUserLoggedIn();
      if (context.mounted) {
        if (isLoggedIn) {
          bool isDriver = auth.currentUser!.email!.contains('driver');
          await context
              .read<ProfileCubit>()
              .getUserProfile(isDriver ? 'driver' : 'user', '');
          context.go('/home');
        } else {
          context.go('/getstarted');
        }
      }
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Getstartedlogo(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator.adaptive()),
          ],
        ),
      ),
    );
  }
}
