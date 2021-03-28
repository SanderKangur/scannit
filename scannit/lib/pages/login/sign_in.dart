import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scannit/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:scannit/blocs/authentication_bloc/authentication_event.dart';
import 'package:scannit/blocs/login_bloc/login_bloc.dart';
import 'package:scannit/blocs/login_bloc/login_event.dart';
import 'package:scannit/blocs/login_bloc/login_state.dart';
import 'package:scannit/data/user_auth.dart';

class SignIn extends StatefulWidget {
  final UserAuthenticationRepository _auth;

  SignIn({Key key, @required UserAuthenticationRepository auth})
      : assert(auth != null),
        _auth = auth,
        super(key: key);
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  LoginBloc _loginBloc;
  UserAuthenticationRepository get _auth => widget._auth;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isFailure) {
            print("lmao2");
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Login Failure'), Icon(Icons.error)],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Logging In...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(AuthenticationLoggedIn());
          }
        },
      child: BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Brew Crew'),
        ),
          body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: RaisedButton(
              child: Text('sign in anon'),
              onPressed: _onContinue
            ),
          ),
        );
      }),
    );
  }


  void _onContinue() {
    _loginBloc.add(
      LoginWithAnonPressed(),
    );
    print("Continue");
  }
}
