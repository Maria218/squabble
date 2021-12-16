import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:squabble/repositories/repositories.dart';
import 'package:squabble/screens/authentication/login/bloc/bloc_exports.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(LoginState.initial());
  
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    TransitionFunction<LoginEvent, LoginState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! LoginEmailChanged && event is! LoginPasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is LoginEmailChanged || event is LoginPasswordChanged);
    }).debounceTime(const Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // if (event is LoginEmailChanged) {
    //   yield* _mapLoginEmailChangedToState(event.email);
    // } else if (event is LoginPasswordChanged) {
    //   yield* _mapLoginPasswordChangedToState(event.password);
    // }
    if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  // Stream<LoginState> _mapLoginEmailChangedToState(String email) async* {
  //   yield state.update(
  //     isEmailValid: Validators.isValidEmail(email),
  //   );
  // }

  // Stream<LoginState> _mapLoginPasswordChangedToState(String password) async* {
  //   yield state.update(
  //     isPasswordValid: Validators.isValidPassword(password),
  //   );
  // }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    required String email,
    required String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
