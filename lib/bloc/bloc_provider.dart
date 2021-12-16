import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:squabble/bloc/bloc_base.dart';

/// A Flutter widget which provides a bloc to its children via `BlocProvider.of(context)`.
/// It is used as a DI widget so that a single instance of a bloc can be provided
/// to multiple widgets within a subtree.
class BlocProvider<T extends Bloc> extends InheritedWidget  {
  /// The [Widget] and its descendants which will have access to the [Bloc].
  final Widget child;
  /// The [Bloc] which is to be made available throughout the subtree
  final T bloc;

  const BlocProvider({Key? key, required this.bloc, required this.child})
      : super(key: key, child: child);

  /// Method that allows widgets to access the bloc as long as their `BuildContext`
  /// contains a `BlocProvider` instance.
  static T? of<T extends Bloc>(BuildContext context) {
    final BlocProvider<T>? provider = context.findAncestorWidgetOfExactType() as BlocProvider<T>?;
    return provider?.bloc;
  }

  @override
  bool updateShouldNotify(BlocProvider oldWidget) => true;

  void dispose() {
    bloc.dispose();
  }
}


