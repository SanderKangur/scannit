import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'file:///C:/Users/Sander/AndroidStudioProjects/Flutter/scannit/lib/data/user_repository.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';
import 'package:scannit/data/user.dart';
import 'package:scannit/pages/main_screen.dart';
import 'package:scannit/pages/login/login_screen.dart';
import 'package:scannit/pages/splash_screen.dart';
import 'package:scannit/simple_bloc_delegate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AuthenticationStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}


class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(
      value: UserRepository().user,
      child: MaterialApp(
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationInitial) {
              return SplashScreen();
            }
            if (state is AuthenticationFailure) {
              return LoginScreen(userRepository: _userRepository);
            }
            if (state is AuthenticationSuccess) {
              return MyHomePage(name: state.displayName);
            }
          },
        ),
      ),
    );
  }
}
