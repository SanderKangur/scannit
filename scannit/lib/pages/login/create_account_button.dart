import 'package:flutter/material.dart';
import 'package:scannit/data/user_auth.dart';
import 'package:scannit/pages/register/register_screen.dart';

class CreateAccountButton extends StatelessWidget {
  final UserAuthenticationRepository _userRepository;

  CreateAccountButton({Key key, @required UserAuthenticationRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Sign up here!',
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return RegisterScreen(userRepository: _userRepository);
          }),
        );
      },
    );
  }
}