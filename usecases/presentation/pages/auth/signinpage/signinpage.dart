import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_management_app/data/models/auth/signin_user_req.dart';
import 'package:vehicle_management_app/domain/usecases/auth/sigin.dart';
import 'package:vehicle_management_app/presentation/pages/user/profilescreen/cubit/profile_cubit.dart';
import 'package:vehicle_management_app/presentation/widgets/authappbutton.dart';
import 'package:vehicle_management_app/service_locator.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Center(
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      emailField(context),
                      const SizedBox(
                        height: 20,
                      ),
                      passwordField(context),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthAppButton(
                          text: "Sign In",
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                              var result = await sl<SigninUseCase>().call(
                                params: SigninUserReq(
                                  email: _emailController.text.toString(),
                                  password: _passwordController.text.toString(),
                                ),
                              );
                              result.fold(
                                (l) {
                                  context.pop();
                                  showDialog(
                                      context: context,
                                      builder: (builder) {
                                        return AlertDialog(
                                          title: const Text('Error'),
                                          content: Text(l.toString()),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                context.pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                (r) async {
                                  if (_emailController.text
                                      .toString()
                                      .contains("driver")) {
                                    String id = _emailController.text
                                        .split('@')[0]
                                        .split('.')
                                        .last
                                        .toUpperCase();
                                    await context
                                        .read<ProfileCubit>()
                                        .getUserProfile('driver', id);
                                  } else {
                                    await context
                                        .read<ProfileCubit>()
                                        .getUserProfile('user', null);
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text('Sign in successful'),
                                    ),
                                  );
                                  context.go('/home');
                                },
                              );
                            }
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AuthAppButton(
                          text: "Sign Up",
                          onPressed: () {
                            context.go('/getstarted/signup');
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget passwordField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your password';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}
