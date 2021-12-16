import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squabble/blocs/authentication/bloc.dart';
import 'package:squabble/repositories/repositories.dart';
import 'package:squabble/screens/authentication/login/login_screen.dart';
import 'package:squabble/screens/home/home_screen.dart';


void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
    Bloc.observer = BlocObserver();
    await Firebase.initializeApp();
    final UserRepository userRepository = UserRepository();
    runApp(
      BlocProvider(
        create: (context) => AuthenticationBloc(
          userRepository: userRepository,
        )..add(AuthenticationStarted()),
        child: Squabble(userRepository: userRepository),
      ),
    );
  }, (Object error, StackTrace stack) {
    print(error);
    print(stack);
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// void main() {
//   final UserRepository userRepository = UserRepository();
//   runApp(
//     BlocProvider(
//       create: (context) => AuthenticationBloc(
//         userRepository: userRepository,
//       )..add(AuthenticationStarted()),
//       child: Squabble(userRepository: userRepository),
//     ),
//   );
// }

class Squabble extends StatelessWidget {
  final UserRepository userRepository;

  // ignore: use_key_in_widget_constructors
  const Squabble({required this.userRepository});

  get auth => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return LoginScreen(userRepository: userRepository,);
          }
          if (state is AuthenticationSuccess) {
            return HomeScreen(
              userInfoDetails: state.userDetails,
            );
          }
          // if (state is AuthenticationLoading) {
          //   return LoadingScreen();
          // }
          return const Text(
            'Loading',
            style: TextStyle(fontSize: 20, color: Colors.white),
          );
        },
      ),
    );
  }
}

// class Squabble extends StatefulWidget {
//   final UserRepository userRepository;

//   const Squabble({required this.userRepository});

//   get auth => null;

//   @override
//   _SquabbleState createState() => _SquabbleState();
// }

// class _SquabbleState extends State<Squabble> {
//   final UserRepository userRepository;

//   _SquabbleState(this.userRepository);
  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//         builder: (context, state) {
//           if (state is AuthenticationFailure) {
//             return LoginScreen(userRepository: userRepository,);
//           }
//           if (state is AuthenticationSuccess) {
//             return HomeScreen(
//               userRepository: widget.userRepository,
//             );
//           }
//           // if (state is AuthenticationLoading) {
//           //   return LoadingScreen();
//           // }
//           return LoadingScreen();
//         },
//       ),
//     );
//   }
// }
