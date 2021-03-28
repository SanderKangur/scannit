import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scannit/data/user_auth.dart';
import 'package:scannit/validators.dart';

import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserAuthenticationRepository _userRepository;

  LoginBloc({
    @required UserAuthenticationRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository, super(null);

  @override
  LoginState get initialState => LoginState.initial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithAnonPressed) {
      yield* _mapLoginWithAnonPressedToState();
    }
  }

  Stream<LoginState> _mapLoginWithAnonPressedToState() async* {
    try {
      await _userRepository.signInAnon();
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
