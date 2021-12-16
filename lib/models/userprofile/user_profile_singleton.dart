class UserProfileSingleton {
  String? fullName;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? description;
  String? location;
  
  // -------  SINGLETON ------
  static final UserProfileSingleton _instance = UserProfileSingleton._internal();
  factory UserProfileSingleton() => _instance;
  UserProfileSingleton._internal();
}
