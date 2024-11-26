import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_management_app/presentation/pages/applicationlist/cubit/applicationlist_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/user/profilescreen/cubit/profile_cubit.dart';
import 'package:vehicle_management_app/service_locator.dart';

class ApplicationListPage extends StatefulWidget
    implements PreferredSizeWidget {
  const ApplicationListPage({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ApplicationListPageState createState() => _ApplicationListPageState();

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}

class _ApplicationListPageState extends State<ApplicationListPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  bool self = false;
  late dynamic profileCubit = context.read<ProfileCubit>().state;
  late dynamic cubit = context.read<ApplicationlistCubit>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    profileCubit = context.read<ProfileCubit>().state;
    cubit = context.read<ApplicationlistCubit>();
    cubit.getApplications(false, profileCubit.role);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: preferredSize,
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text('Applications',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          automaticallyImplyLeading: false,
          actions: [
            if (profileCubit.role == 'hod')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Self',
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onPrimary)),
                  Switch(
                      activeColor: Colors.amberAccent,
                      value: self,
                      onChanged: (val) {
                        setState(() {
                          self = val;
                          if (self) {
                            cubit.getApplications(true, profileCubit.role);
                          } else {
                            cubit.getApplications(false, profileCubit.role);
                          }
                        });
                      }),
                ],
              )
          ],
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                child: Text("Pending"),
              ),
              Tab(
                child: Text(
                  "Approved/Completed",
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                child: Text("Rejected"),
              ),
            ],
            onTap: (value) => setState(() {}),
          ),
          IndexedStack(
            index: _tabController.index,
            children: [
              BlocBuilder<ApplicationlistCubit, ApplicationlistState>(
                  builder: (context, state) {
                if (state is ApplicationlistLoaded) {
                  return ListView.builder(
                    itemCount: state.applications[0].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final application = state.applications[0][index];
                      return ListTile(
                        title: Text(application.date),
                        subtitle: Text(application.purpose),
                        onTap: () {
                          GoRouter.of(context).go(
                            '/home/reviewapplication?who=${profileCubit.role}',
                            extra: application,
                          );
                        },
                      );
                    },
                  );
                } else if (state is ApplicationlistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ApplicationlistError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text("Something went wrong"));
              }),
              BlocBuilder<ApplicationlistCubit, ApplicationlistState>(
                  builder: (context, state) {
                if (state is ApplicationlistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ApplicationlistLoaded) {
                  return ListView.builder(
                    itemCount: state.applications[1].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final application = state.applications[1][index];
                      return ListTile(
                        title: Text(application.date),
                        subtitle: Text(application.purpose),
                        onTap: () {
                          var who = (application.userId == profileCubit.uid &&
                                  application.status == 1)
                              ? 'completion'
                              : profileCubit.role;

                          GoRouter.of(context).go(
                            '/home/reviewapplication?who=$who',
                            extra: application,
                          );
                        },
                      );
                    },
                  );
                } else if (state is ApplicationlistError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text("Something went wrong"));
              }),
              BlocBuilder<ApplicationlistCubit, ApplicationlistState>(
                  builder: (context, state) {
                if (state is ApplicationlistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ApplicationlistLoaded) {
                  return ListView.builder(
                    itemCount: state.applications[2].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final application = state.applications[2][index];
                      return ListTile(
                        title: Text(application.date),
                        subtitle: Text(application.rejectionComment),
                        onTap: () {
                          GoRouter.of(context).go(
                            '/home/reviewapplication?who=${profileCubit.role}',
                            extra: application,
                          );
                        },
                      );
                    },
                  );
                } else if (state is ApplicationlistError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text("Something went wrong"));
              }),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cubit.getApplications(self, profileCubit.role);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(55.0);
}
