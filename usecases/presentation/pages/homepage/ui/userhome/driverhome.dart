import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_management_app/presentation/pages/applicationlist/cubit/applicationlist_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/user/profilescreen/cubit/profile_cubit.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  late dynamic profileCubit;

  late dynamic cubit = context.read<ApplicationlistCubit>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    profileCubit = context.read<ProfileCubit>().state;
    cubit = context.read<ApplicationlistCubit>();
    cubit.getApplications(false, profileCubit.role);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: preferredSize,
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text("Pending Task"),
            ),
            Tab(
              child: Text("Completed Task"),
            ),
          ],
          onTap: (value) => setState(() {}),
        ),
      ),
      body: IndexedStack(
        index: _tabController.index,
        children: [
          BlocBuilder<ApplicationlistCubit, ApplicationlistState>(
              builder: (context, state) {
            if (state is ApplicationlistLoaded) {
              return ListView.builder(
                itemCount: state.applications[0].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.applications[0][index].date),
                    subtitle:
                        Text(state.applications[0][index].destinationName),
                    onTap: () {
                      GoRouter.of(context).go(
                        '/home/reviewapplication?who=${profileCubit.role}',
                        extra: state.applications[0][index],
                      );
                    },
                  );
                },
              );
            } else if (state is ApplicationlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ApplicationlistError) {
              return Center(
                child: Text(state.message),
              );
            }
            return const SizedBox();
          }),
          BlocBuilder<ApplicationlistCubit, ApplicationlistState>(
              builder: (context, state) {
            if (state is ApplicationlistLoaded) {
              return ListView.builder(
                itemCount: state.applications[1].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.applications[1][index].date),
                    subtitle:
                        Text(state.applications[1][index].destinationName),
                    onTap: () {
                      GoRouter.of(context).go(
                        '/home/reviewapplication?who=${profileCubit.role}',
                        extra: state.applications[1][index],
                      );
                    },
                  );
                },
              );
            } else if (state is ApplicationlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ApplicationlistError) {
              return Center(
                child: Text(state.message),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cubit.getApplications(false, profileCubit.role);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(55.0);
}
