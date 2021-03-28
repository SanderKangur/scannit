import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/data/user_auth.dart';
import 'package:scannit/pages/loading.dart';
import 'package:scannit/pages/login/sign_in.dart';
import 'package:scannit/pages/main_screen.dart';
import 'package:scannit/pages/splash_screen.dart';
import 'package:scannit/simple_bloc_delegate.dart';

import 'data/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocDelegate();
  final UserAuthenticationRepository userRepository =
      UserAuthenticationRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AuthenticationStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserAuthenticationRepository _userRepository;

  App({Key key, @required UserAuthenticationRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<LocalUser>.value(
      value: UserAuthenticationRepository().user,
      initialData: null,
      child: MaterialApp(
        builder: (context, child) => SafeArea(child: child),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationInitial) {
              return SplashScreen();
            }
            if (state is AuthenticationFailure) {
              return SignIn();
            }
            if (state is AuthenticationSuccess) {
              Constants.userId = state.user.uid;
              print("uid: " + Constants.userId.toString());
              return MainScreen(name: state.user.displayName);
            } else {
              return LoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}
