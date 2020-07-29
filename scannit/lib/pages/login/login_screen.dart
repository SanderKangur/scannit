import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scannit/blocs/login_bloc/bloc.dart';
import 'package:scannit/data/user_auth.dart';
import 'package:scannit/pages/login/login_form.dart';


class LoginScreen extends StatelessWidget {
  final UserAuthenticationRepository _userRepository;

  LoginScreen({Key key, @required UserAuthenticationRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}