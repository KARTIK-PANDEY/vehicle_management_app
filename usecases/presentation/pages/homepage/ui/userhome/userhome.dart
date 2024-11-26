import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:vehicle_management_app/presentation/pages/user/profilescreen/cubit/profile_cubit.dart";

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String? uid;
  String? role_;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: BlocBuilder<ProfileCubit, dynamic>(
              builder: (context, state) {
                uid = state?.uid ?? "";
                role_ = state?.role ?? "user";
                return Text.rich(
                  TextSpan(children: [
                    const TextSpan(
                      text: "Welcome,\n",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: state?.fullName ?? "User",
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                );
              },
            )),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              context.go("/home/applicationform?uid=$uid&role=$role_");
            },
            child: const Text(
              "Book a Vehicle",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
