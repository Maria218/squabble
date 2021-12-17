import 'package:equatable/equatable.dart';
import 'package:squabble/models/userprofile/user_profile_model.dart';

abstract class ContactSearchState extends Equatable {
  const ContactSearchState();

  @override
  List<Object> get props => [];
}

class SearchState extends ContactSearchState {
  final List<UserProfile> users;
  SearchState(this.users);

  @override
  List<Object> get props => [users];

  @override
  String toString() => 'VerticalListFetchedState { userrs: ${users.length} }';
}

class SearchFetchingState extends ContactSearchState {
  @override
  String toString() => 'SearchFetchingState';
}

class SearchFetchedState extends ContactSearchState {
  final List<UserProfile> users;
  final String query;

  SearchFetchedState(this.users, this.query);

  @override
  List<Object> get props => [users, query];

  @override
  String toString() => 'SearchFetchedState';
}

class SearchErrorState extends ContactSearchState {
  final String error;

  SearchErrorState(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SearchErrorState { error: $error }';
}

class SearchEmptyState extends ContactSearchState {
  @override
  String toString() => 'SearchStateEmpty';
}
