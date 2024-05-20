class UserState {
  static final UserState _instance = UserState._internal();

  factory UserState() {
    return _instance;
  }

  UserState._internal();

  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  int? age;
  String? city;

  void setUser({
    required int id,
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required int age,
    required String city,
  }) {
    this.id = id;
    this.username = username;
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.age = age;
    this.city = city;
  }
}
