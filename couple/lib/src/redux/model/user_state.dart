class UserState {
  bool authenticated;
  int state;
  String sessionId;
  User user;

  UserState(
      {this.authenticated = false, this.state = 0, this.sessionId, this.user});

  @override
  String toString() {
    return "{init:$authenticated, state:$state, user:$user, session:$sessionId}";
  }
}

class User {
  String id;
  String email;
  String nombre;
  String password;

  User({
    this.id,
    this.email,
    this.nombre,
    this.password,
  });

  @override
  String toString() {
    return "id:$id, email:$email, nombre:$nombre";
  }

  static User fromJson(Map<String, dynamic> json) => User(
      id: json["objectId"],
      nombre: json["name"],
      email: json["email"],
      password: json["password"]);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': nombre,
        'email': email,
        'password': password,
        'username': email
      };
}
