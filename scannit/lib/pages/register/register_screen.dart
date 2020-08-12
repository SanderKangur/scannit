import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scannit/blocs/register_bloc/bloc.dart';
import 'package:scannit/data/user_auth.dart';
import 'package:scannit/pages/register/register_form_main.dart';


class RegisterScreen extends StatelessWidget {
  final UserAuthenticationRepository _userRepository;

  RegisterScreen({Key key, @required UserAuthenticationRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository),
          child: RegisterFormMain(),
        ),
      ),
    );
  }
}