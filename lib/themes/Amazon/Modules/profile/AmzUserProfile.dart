class User {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profilePicture;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );
  }
}

class UserResponse {
  final String id;
  final User user;

  UserResponse({
    required this.id,
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as String,
      user: User.fromJson(json['user']),
    );
  }
}
