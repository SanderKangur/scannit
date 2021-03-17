import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';
import 'package:scannit/blocs/register_bloc/bloc.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/pages/register/register_button.dart';

class RegisterFormMain extends StatefulWidget {
  State<RegisterFormMain> createState() => _RegisterFormMainState();
}

class _RegisterFormMainState extends State<RegisterFormMain> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Container(
                      height: 1.0,
                      color: Colors.brown,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "YOUR JOURNEY TO A HEALTHIER LIFESTYLE STARTS HERE!",
                      textScaleFactor: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.lightGreenAccent,
                                    width: 1.0)),
                            icon: Icon(
                              Icons.person,
                              color: Colors.lightGreen,
                            ),
                            labelText: 'Name',
                          ),
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.lightGreenAccent,
                                    width: 1.0)),
                            icon: Icon(
                              Icons.email,
                              color: Colors.lightGreen,
                            ),
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (_) {
                            return !state.isEmailValid ? 'Invalid Email' : null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.lightGreenAccent,
                                    width: 1.0)),
                            icon: Icon(
                              Icons.lock,
                              color: Colors.lightGreen,
                            ),
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (_) {
                            return !state.isPasswordValid
                                ? 'Invalid Password'
                                : null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RegisterButton(
                    onPressed: isRegisterButtonEnabled(state)
                        ? _onFormSubmitted
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.add(
      RegisterEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      RegisterPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    Constants.userName = _nameController.text;
    _registerBloc.add(
      RegisterSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
