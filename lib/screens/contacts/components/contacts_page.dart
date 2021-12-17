import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squabble/models/userprofile/user_profile_model.dart';
import 'package:squabble/models/userprofile/user_profile_singleton.dart';
import 'package:squabble/screens/contacts/bloc/searchBloc/search_bloc_exports.dart';

class ContactPage extends StatefulWidget {

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late SearchBloc _contactSearchBloc;
  TextEditingController _searchHome = TextEditingController();
  UserProfile userProfile = UserProfile(
    UserProfileSingleton().fullName,
    UserProfileSingleton().firstName,
    UserProfileSingleton().lastName,
    UserProfileSingleton().email,
    UserProfileSingleton().description,
    UserProfileSingleton().location,
    UserProfileSingleton().hobbies
  );

  @override
  void initState() {
    super.initState();
    _contactSearchBloc = BlocProvider.of<SearchBloc>(context);
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Contact'),
      ),
      body: (buildMyWidget(context)),
    );
  }

  Widget buildMyWidget(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              style: TextStyle(color: Colors.grey[400]),
              controller: _searchHome,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderSide: new BorderSide(
                    color: Colors.grey[800]!, style: BorderStyle.solid
                  )
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(
                        color: Colors.grey[800]!, style: BorderStyle.solid)),
                focusedBorder: OutlineInputBorder(
                    borderSide: new BorderSide(
                        color: Colors.grey[800]!, style: BorderStyle.solid)),
                hintText: 'Search Contacts',
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
                suffixIcon: _searchHome.text.isEmpty
                    ? Icon(
                        Icons.search,
                        color: Colors.grey[600],
                      )
                    : IconButton(
                        icon: Icon(Icons.clear),
                        color: Colors.white,
                        iconSize: 20,
                        onPressed: () {
                          _searchHome.clear();
                          _contactSearchBloc
                              .add(SearchTextChanged(query: ''));
                        }),
                isDense: true,
                contentPadding: EdgeInsets.all(12),
              ),
              onChanged: (query) => _contactSearchBloc
                  .add(SearchTextChanged(query: query)),
            ),
          ),
        ),
        Expanded(
          child: _searchContactPage(context),
        )
      ],
    );
  }

  Widget _searchContactPage(BuildContext context) {
    return BlocListener<SearchBloc, ContactSearchState>(
      listener: (context, state) {
        if (state is SearchFetchingState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Loading Contacts'),
                    CircularProgressIndicator(),
                  ],
                ),
                duration: Duration(milliseconds: 600),
              ),
            );
        }

        if (state is SearchErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('There was an error getting contacts'),
                    Icon(Icons.error)
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<SearchBloc, ContactSearchState>(
        builder: (context, state) {
          if (state is SearchFetchingState) {
            //Show default items
            return Center(
              child: Text(
                'Loading contacts',
                style: TextStyle(color: Colors.white, fontSize: 18)
              )
            );
          }

          if (state is SearchFetchedState) {
            if (state.users.isEmpty) {
              return Text(
                "No contacts were found",
                style: TextStyle(color: Colors.white)
              );
            }

            if (state.users.isEmpty) {
              return Text(
                'There are no users',
                style: TextStyle(color: Colors.white),
              );
            }

            return Column(
              children: [
                Container(
                  child: ListView.separated(
                    itemCount: state.users.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final result = state.users[index];
                      return _buildContactSearchItem(context, result, index, state);
                    },
                  ),
                ),
              ]
            );
          }
          return Container(
            child: Text('Here are your contacts', style: TextStyle(color: Colors.white),),
          );
        },
      )
    );
  }

  Widget _buildContactSearchItem(BuildContext context, UserProfile user, int index, state) {
    return Card(
      color: Colors.black,
      child: Container(
        child: ListTile(
          onTap: () {
            // MyNavigator.goToStoreFront(context, state.vendors[index], onGoBack);
          },
          title: Text(
            user.firstName!,
            style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              // letterSpacing: 1.3,
              // fontSize: 17
            )
          ),
        )
      )
    );
  }
}

