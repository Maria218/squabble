import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squabble/repositories/repositories.dart';
import 'package:squabble/screens/contacts/bloc/searchBloc/search_bloc_exports.dart';
import 'package:squabble/screens/contacts/components/contacts_page.dart';
import 'bloc/contact_exports.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreen createState() => _ContactsScreen();
}

class _ContactsScreen extends State<ContactsScreen> {
  // final UserProfile? userProfile;
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ContactBloc>(
            lazy: false,
            create: (BuildContext context) => ContactBloc(userRepository: userRepository)..add(ContactInitEvent()),
          ),
          BlocProvider<SearchBloc>(
            lazy: false,
            create: (BuildContext context) => SearchBloc(
              userRepository: userRepository,
            )..add(ContactSearchInitEvent())
          ),
        ],
        child: ContactPage(),
      )
    );
  }
}
