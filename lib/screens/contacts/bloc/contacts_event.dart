import 'package:equatable/equatable.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();
  @override
  List<Object> get props => [];
}

class ContactInitEvent extends ContactEvent {
  const ContactInitEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'InitEvent Was Called';
}

class GetAllContactsEvent extends ContactEvent {
  const GetAllContactsEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetAll event was Called';
}
