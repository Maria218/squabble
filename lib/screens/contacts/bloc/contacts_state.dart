import 'package:equatable/equatable.dart';
import 'package:squabble/models/userprofile/user_profile_model.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class ContactsFetchingState extends ContactState {
  @override
  String toString() => 'ContactFetchingState';
}

class ContactsFetchedState extends ContactState {
  final List<UserProfile> users;
  ContactsFetchedState(this.users);

  @override
  List<Object> get props => [users];

  @override
  String toString() => 'ContactFetchedState { vendors: ${users.length} }';
}

class ContactsErrorState extends ContactState {
  final String error;

  ContactsErrorState(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ContactsErrorState { error: $error }';
}

class VerticalListEmptyState extends ContactState {
  @override
  String toString() => 'Contact List initial state';
}
