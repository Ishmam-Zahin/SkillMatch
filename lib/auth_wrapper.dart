import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:findjob/bloc/blocs/home_page_bloc.dart';
import 'package:findjob/bloc/blocs/user_bloc.dart';
import 'package:findjob/bloc/states/user_state.dart';
import 'package:findjob/home_page.dart';
import 'package:findjob/login_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthUserBloc, UserState>(
      builder: (context, state) {
        if (state is AuthenticateUserSate) {
          return BlocProvider(
            create: (context) => HomePageBloc(),
            child: const HomePage(),
          );
        }

        return const LoginPage();
      },
    );
  }
}
