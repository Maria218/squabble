import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:squabble/repositories/repositories.dart';
import 'package:squabble/screens/contacts/bloc/contact_exports.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  UserRepository _userRepository;

  ContactBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(ContactsEmptyState());

  @override
  Stream<ContactState> mapEventToState(ContactEvent event) async* {
    if (event is ContactInitEvent) {
      yield* _mapInitEventToState(event);
    }

    if (event is GetAllContactsEvent) {
      yield* _mapGetAllEventToState(event);
    }
  }

  Stream<ContactState> _mapInitEventToState(
      ContactInitEvent event) async* {
    yield ContactsFetchingState();
    try {
      //TODO: change to location based / popularity based query
      final result = await _userRepository.getAllUsers();
      yield ContactsFetchedState(result);
    } catch (error) {
      yield ContactsErrorState(error.toString());
    }
  }

  Stream<ContactState> _mapGetAllEventToState(GetAllContactsEvent event) async* {
    yield ContactsFetchingState();
    try {
      //change to location based query
      final result = await _userRepository.getAllUsers();
      yield ContactsFetchedState(result);
    } catch (error) {
      yield ContactsErrorState(error.toString());
    }
  }
}
