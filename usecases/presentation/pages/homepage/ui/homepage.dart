import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_management_app/presentation/pages/homepage/cubit/navindex_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/homepage/cubit/time_cubit.dart';
import 'package:vehicle_management_app/presentation/pages/homepage/ui/homeview.dart';
import 'package:vehicle_management_app/presentation/pages/applicationlist/applicationlistpage.dart';
import 'package:vehicle_management_app/presentation/pages/user/profilescreen/cubit/profile_cubit.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  PageController pageController = PageController();
  int _currentIndx = 0;
  String? role_;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    role_ = context.read<ProfileCubit>().state?.role;

    return MultiBlocProvider(
      providers: [
        BlocProvider<NavindexCubit>(
          create: (context) => NavindexCubit(),
        ),
        BlocProvider<TimeCubit>(create: (context) => TimeCubit()),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: (role_ != 'admin' && role_ != 'driver')
            ? SafeArea(
                child: BlocBuilder<NavindexCubit, dynamic>(
                  builder: (context, state) {
                    return BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      currentIndex: state,
                      onTap: (value) {
                        context.read<NavindexCubit>().changeIndex(value);
                        setState(() {
                          _currentIndx = value;
                        });
                      },
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.pages),
                          label: 'Applications',
                        ),
                      ],
                    );
                  },
                ),
              )
            : null,
        body: (role_ != 'admin' && role_ != 'driver')
            ? IndexedStack(
                // controller: pageController,
                // physics: const NeverScrollableScrollPhysics(),
                index: _currentIndx,
                children: [
                    HomeView(role: role_!),
                    const ApplicationListPage(),
                  ])
            : HomeView(role: role_!),
      ),
    );
  }
}
