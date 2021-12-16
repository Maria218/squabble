import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squabble/blocs/authentication/bloc.dart';
import 'package:squabble/models/userprofile/user_profile_singleton.dart';
import 'package:squabble/repositories/repositories.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthenticationInitial());
        
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = _userRepository.isSignedIn();
    var data;
    if (isSignedIn) {
      final user = _userRepository.getUser();
      DocumentReference document = FirebaseFirestore.instance.collection("userProfile").doc(user.uid);
      document.get().then((DocumentSnapshot snapshot) async {
        data = snapshot.data;
        UserProfileSingleton().fullName = data['fullname'];
        UserProfileSingleton().firstName = data['firstname'];
        UserProfileSingleton().lastName = data['lastname'];
        UserProfileSingleton().password = data['password'];
      });

      FirebaseFirestore.instance.collection('userProfile').doc(user.uid).get();

      yield AuthenticationSuccess(user);
    } else {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    final user = _userRepository.getUser();
    var data;
    DocumentReference document = FirebaseFirestore.instance.collection("userProfile").doc(user.uid);
    document.get().then((DocumentSnapshot snapshot) async {
      data = snapshot.data;
      UserProfileSingleton().fullName = data['fullname'];
      UserProfileSingleton().firstName = data['firstname'];
      UserProfileSingleton().lastName = data['lastname'];
      UserProfileSingleton().password = data['password'];
    });
    UserProfileSingleton().email = user.email;
    yield AuthenticationSuccess(user);
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationFailure();
    _userRepository.signOut();
  }
}
