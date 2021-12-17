import 'package:equatable/equatable.dart';

abstract class ContactSearchEvent extends Equatable {
  const ContactSearchEvent();
  @override
  List<Object> get props => [];
}

class ContactSearchInitEvent extends ContactSearchEvent {
  const ContactSearchInitEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'SearchContactListEvent Was Called';
}

class SearchTextChanged extends ContactSearchEvent {
  final String query;

  const SearchTextChanged({required this.query});

  @override
  List<Object> get props => [query];

  @override
  String toString() => 'SearchTextChanged { searchString :$query }';
}

class SearchContactList extends ContactSearchEvent {
  final String query;

  const SearchContactList({required this.query});

  @override
  List<Object> get props => [query];

  @override
  String toString() => 'Searching contacts';
}
