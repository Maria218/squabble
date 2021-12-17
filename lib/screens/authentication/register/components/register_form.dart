import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squabble/blocs/authentication/bloc.dart';
import 'package:squabble/repositories/repositories.dart';
import 'package:squabble/screens/authentication/login/bloc/login_bloc_exports.dart';
import 'package:squabble/screens/authentication/register/bloc/register_bloc_exports.dart';

class RegisterForm extends StatefulWidget {
  final UserRepository _userRepository;

  RegisterForm({Key? key, required UserRepository userRepository})
    : _userRepository = userRepository,
      super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final UserRepository userRepository = UserRepository();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late bool isPasswordObscure;
  late bool isConfirmPasswordObscure;
  late RegisterBloc _registerBloc;
  LoginBloc? _loginBloc;
  int _currentStep = 0;

  bool get isPopulated =>
    _emailController.text.isNotEmpty &&
    _passwordController.text.isNotEmpty &&
    _passwordController.text == _confirmPasswordController.text;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    isPasswordObscure = true;
    isConfirmPasswordObscure = true;
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _descriptionController.dispose();
    _hobbiesController.dispose();
    _locationController.dispose();
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
    _registerBloc.add(
      RegisterSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        description: _descriptionController.text,
        hobbies: _hobbiesController.text,
        location: _locationController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
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
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        if (state.isFailure) {
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
            SnackBar(
              content: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Registration Failure!'),
                    Icon(Icons.error,size: 30,),
                  ],
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stepper(
                      currentStep: _currentStep,
                      controlsBuilder: (BuildContext context, ControlsDetails details) {
                        return details.stepIndex < 4 ? Row(
                          children: <Widget>[
                            TextButton(
                              onPressed: details.onStepContinue,
                              child: const Text('Next'),
                            ),
                            TextButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Previous'),
                            ),
                          ],
                        ) : Row(
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _onFormSubmitted();
                                }
                                if (!_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text('Please go back and fill out all fields'),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                }
                                return null;
                              },
                              child: const Text('Sign Up'),
                            ),
                            TextButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Previous'),
                            ),
                          ],
                        );
                      },
                      onStepContinue: () {
                        if (_currentStep >= 4) return;
                        setState(() {
                          _currentStep += 1;
                        });
                      },
                      onStepCancel: () {
                        if (_currentStep <= 0) return;
                        setState(() {
                          _currentStep -= 1;
                        });
                      },
                      steps: <Step>[
                        Step(
                          title: Text('Full Name', style: TextStyle(color: Colors.white),),
                          content: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                                child: TextFormField(
                                  controller: _firstNameController,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.words,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'First name',
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
                                    )
                                  ),
                                  autofocus: false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your first name';
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                                child: TextFormField(
                                  controller: _lastNameController,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.words,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'Last name',
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
                                    )
                                  ),
                                  autofocus: false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your last name';
                                    }
                                  },
                                ),
                              )
                            ]
                          ),
                        ),
                        Step(
                          title: Text('Description', style: TextStyle(color: Colors.white),),
                          subtitle: Text('Tell us about yourself', style: TextStyle(color: Colors.white),),
                          content: Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: TextFormField(
                              controller: _descriptionController,
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(color: Colors.white),
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "I'm a fun loving person who loves to travel and explore new places...",
                                hintStyle: TextStyle(
                                  color: Colors.grey[700]
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
                                )
                              ),
                              autofocus: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a brief description of yourself';
                                }
                              },
                            ),
                          ),
                        ),
                        Step(
                          title: Text('Hobbies', style: TextStyle(color: Colors.white),),
                          subtitle: Text('What do you like to do in your spare time?', style: TextStyle(color: Colors.white),),
                          content: Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: TextFormField(
                              controller: _hobbiesController,
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(color: Colors.white),
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "1. Reading, 2. Watching movies, 3. Playing video games...",
                                hintStyle: TextStyle(
                                  color: Colors.grey[700]
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
                                )
                              ),
                              autofocus: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a brief description of yourself';
                                }
                              },
                            ),
                          ),
                        ),
                        Step(
                          title: Text('Password', style: TextStyle(color: Colors.white),),
                          content: SizedBox(
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                        Step(
                          title: Text('Full Name', style: TextStyle(color: Colors.white),),
                          content: SizedBox(
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ),
          );
        },
      ),
    );
  }
}




