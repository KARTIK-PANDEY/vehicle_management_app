import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_management_app/domain/usecases/auth/signout.dart';
import 'package:vehicle_management_app/presentation/pages/homepage/ui/userhome/adminhome.dart';
import 'package:vehicle_management_app/presentation/pages/homepage/ui/userhome/driverhome.dart';
import 'package:vehicle_management_app/presentation/pages/homepage/ui/userhome/userhome.dart';
import 'package:vehicle_management_app/presentation/pages/applicationlist/cubit/applicationlist_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/user/profilescreen/cubit/profile_cubit.dart';
import 'package:vehicle_management_app/service_locator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.role});

  final String role;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: _drawer(context, widget.role),
        appBar: _appbar(),
        body: widget.role == 'driver'
            ? const DriverHome()
            : widget.role == 'admin'
                ? AdminHome()
                : const UserHome());
  }

  _appbar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 5,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }

  _drawer(BuildContext context, String role) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child:
                BlocBuilder<ProfileCubit, dynamic>(builder: (context, state) {
              return ListView(
                shrinkWrap: true,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    // backgroundImage: NetworkImage(
                    //     'https://via.placeholder.com/150?text=${state?.fullName}'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      state?.role == 'driver'
                          ? state?.name ?? "User"
                          : state?.fullName ?? "User",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            title: const Text(
              "Profile",
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            onTap: () {
              context.go('/home/profile');
            },
          ),
          if (role != 'driver') ...[
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.description,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              title: const Text(
                "Vehicle List",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              onTap: () {
                context.go('/home/vehiclelist');
              },
            ),
          ],
          if (role == 'driver') ...[
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.car_repair,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              title: const Text(
                "Maintenace",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              onTap: () {
                context.go('/home/maintenance');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.gas_meter,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              title: const Text(
                "Refueling",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              onTap: () {
                context.go('/home/refueling');
              },
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.album_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            title: const Text(
              "Contact Us",
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.feedback,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            title: const Text(
              "Feedback",
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            title: const Text(
              "Sign Out",
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            onTap: () {
              _signout(context);
            },
          )
        ],
      ),
    );
  }

  _signout(BuildContext context) async {
    context.pop();
    showDialog(
        context: context,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    var result = await sl<SignoutUseCase>().call();
    Future.delayed(const Duration(seconds: 2), () {
      context.read<ApplicationlistCubit>().clearApplications();
      context.read<ProfileCubit>().clearProfile();
      if (context.mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(result.fold(
            (l) => l.toString(),
            (r) => r.toString(),
          )),
        ));

        context.go('/getstarted');
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
