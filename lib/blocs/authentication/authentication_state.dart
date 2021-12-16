import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final User userDetails;

  const AuthenticationSuccess(this.userDetails);

  @override
  List<Object> get props => [userDetails.displayName!];

  @override
  String toString() =>
      'Authenticated { displayName: $userDetails.displayName }';
}

class AuthenticationFailure extends AuthenticationState {}
