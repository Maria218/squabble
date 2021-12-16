import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squabble/blocs/authentication/bloc.dart';
import 'package:squabble/repositories/repositories.dart';
import 'package:squabble/screens/authentication/login/bloc/bloc_exports.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginForm({Key? key, required UserRepository userRepository})
    : _userRepository = userRepository,
      super(key: key);
  
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final UserRepository userRepository = UserRepository();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool isPasswordObscure;
  final _formKey = GlobalKey<FormState>();
  User? user;
  late LoginBloc _loginBloc;

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    isPasswordObscure = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      LoginEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Please wait...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedIn());
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Login Failure!'),
                      Icon(Icons.error,size: 30,),
                    ],
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                        image: AssetImage(
                          'assets/icon/adaptive_icons/foreground.png'
                        ),
                        height: 170,
                        width: 170,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 60, 15, 10),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  // fontSize: 20,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.white
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.teal.shade100,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.red.shade900,
                                  ),
                                )
                              ),
                              autofocus: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                return !state.isEmailValid ? 'Invalid Email' : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: isPasswordObscure,
                              style: TextStyle(color: Colors.white),
                              autocorrect: false,
                              autofocus: false,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  // fontSize: 20,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.red.shade900,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordObscure ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordObscure = !isPasswordObscure;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a strong password!';
                                }
                                else if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              }
                            )
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onFormSubmitted();
                              }
                              return null;
                            },
                            child: const Text('Login'),
                          )
                        ]
                      ),
                    ),
                  ]
                )
              ),
            )
          );
        },
      ),
    );
  }
}
