import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squabble/repositories/repositories.dart';
import 'package:squabble/screens/authentication/login/bloc/login_bloc_exports.dart';
import 'package:squabble/screens/authentication/register/bloc/register_bloc_exports.dart';
import 'package:squabble/screens/authentication/register/components/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterScreen({Key? key, required UserRepository userRepository})
    : _userRepository = userRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RegisterBloc>(
              create: (context) => RegisterBloc(userRepository: _userRepository),
            ),
            BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(userRepository: _userRepository)
            )
          ],
          child: RegisterForm(userRepository: _userRepository)
        ),
      ),
    );
  }
}
