import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scannit/blocs/authentication_bloc/bloc.dart';
import 'package:scannit/blocs/register_bloc/bloc.dart';
import 'package:scannit/constants.dart';
import 'package:scannit/pages/register/register_button.dart';


class RegisterFormExtra extends StatefulWidget {
  State<RegisterFormExtra> createState() => _RegisterFormExtraState();
}

class _RegisterFormExtraState extends State<RegisterFormExtra> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Map<String, bool> choice = {'Allergies': false, 'Intolerances': false, 'Lifestyle choice': false, 'Other': false};

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
          BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedIn());
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
                    child:Container(
                      height: 1.0,
                      color: Colors.brown,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "TELL US MORE",
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
                                borderSide: const BorderSide(color: Colors.lightGreenAccent, width: 1.0)),
                            icon: Icon(Icons.person,
                              color: Colors.lightGreen,),
                            labelText: 'Name',
                          ),
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          autovalidate: true,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.lightGreenAccent, width: 1.0)),
                            icon: Icon(Icons.email,
                              color: Colors.lightGreen,),
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          autovalidate: true,
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
                                borderSide: const BorderSide(color: Colors.lightGreenAccent, width: 1.0)),
                            icon: Icon(Icons.lock,
                              color: Colors.lightGreen,),
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          autocorrect: false,
                          autovalidate: true,
                          validator: (_) {
                            return !state.isPasswordValid ? 'Invalid Password' : null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "What brought you here?",
                            textScaleFactor: 2,
                          ),
                        ),
                        choiceTile("Allergies",),
                        choiceTile("Intolerances"),
                        choiceTile("Lifestyle choice"),
                        choiceTile("Other"),
                      ],
                    ),
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

  Widget choiceTile(String text){
    return new CheckboxListTile(
      title: Text(text),
      activeColor: Colors.lightGreen,
      value: choice[text],
      dense: true,
      onChanged: (newValue) {
        setState(() {
          choice[text] = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
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
    Constants.userChoice = choice;
    _registerBloc.add(
      RegisterSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}