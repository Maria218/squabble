import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:squabble/models/userprofile/user_profile_model.dart';
import 'package:squabble/repositories/repositories.dart';
import 'package:squabble/screens/contacts/bloc/searchBloc/search_bloc_exports.dart';

class SearchBloc extends Bloc<ContactSearchEvent, ContactSearchState> {
  UserRepository _userRepository;
  late List<UserProfile> users;

  SearchBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(SearchEmptyState());

  @override
  Stream<Transition<ContactSearchEvent, ContactSearchState>> transformEvents(
    Stream<ContactSearchEvent> events,
    TransitionFunction<ContactSearchEvent, ContactSearchState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! SearchTextChanged);
    });
    final debounceStream = events.where((event) {
      return (event is SearchTextChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<ContactSearchState> mapEventToState(ContactSearchEvent event) async* {
    if (event is ContactSearchInitEvent) {
      yield* _mapStoreListInitEventToState(event);
    }
    if (event is SearchTextChanged) {
      yield* _mapStoreListSearchTextChangedToState(event);
    }
    if (event is SearchContactList) {
      yield* _mapSearchStoreListToState(event);
    }
  }

  Stream<ContactSearchState> _mapStoreListInitEventToState(
    ContactSearchInitEvent event
  ) async* {
    try {
      users = await _userRepository.getAllUsers();
    } catch (error) {
      yield SearchErrorState(error.toString());
    }
  }

  Stream<ContactSearchState> _mapStoreListSearchTextChangedToState(
    SearchTextChanged event
  ) async* {
    final String query = event.query;
    if (query.isEmpty) {
      yield SearchEmptyState();
    } else {
      yield SearchFetchingState();
      try {
        final userResult = await submitUserQuery(query);
        yield SearchFetchedState(userResult, query);
      } catch (error) {
        yield SearchErrorState(error.toString());
      }
    }
  }

  Stream<ContactSearchState> _mapSearchStoreListToState(SearchContactList event) async* {
    final String query = event.query;
    if (query.isEmpty) {
      yield SearchEmptyState();
    } else {
      yield SearchFetchingState();
      try {
        final userResult = await submitAllContactsQuery(query);
        yield SearchFetchedState(userResult, query);
      } catch (error) {
        yield SearchErrorState(error.toString());
      }
    }
  }

  Future<List<UserProfile>> submitUserQuery(String query) async {
    var _results = users
        .where((x) => x.fullName!.toLowerCase().contains(query.toLowerCase().replaceAll(' ', '')))
        .toList();
    return _results;
  }

  Future<List<UserProfile>> submitAllContactsQuery(String query) async {
    var _results = users
        .where((x) => x.fullName!.toLowerCase().contains(query.toLowerCase().replaceAll(' ', '')))
        .toList();
    return _results;
  }
}
