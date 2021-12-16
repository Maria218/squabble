class UserProfile {
  String? fullName;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? description;
  String? location;

  UserProfile(
    this.fullName,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.description,
    this.location
  );

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    json["fullName"] == null ? null : json["fullName"],
    json["firstName"] == null ? null : json["firstName"],
    json["lastName"] == null ? null : json["lastName"],
    json["email"] == null ? null : json["email"],
    json["password"] == null ? null : json["password"],
    json["description"] == null ? null : json["description"],
    json["location"] == null ? null : json["location"],
  );

  UserProfile.fromMap(Map<String, dynamic> map) : email = map['email'];

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'firstName': firstName,
    'lastName': lastName,
    'location': location,
    'email': email,
    'password': password,
    'description': description,
  };
}