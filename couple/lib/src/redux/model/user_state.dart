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
  String invite;
  String partnerId;

  User({
    this.id,
    this.email,
    this.nombre,
    this.password,
    this.invite,
    this.partnerId,
  });

  User cloneUser() {
    return User(
        id: this.id,
        email: this.email,
        nombre: this.nombre,
        password: this.password,
        invite: this.invite,
        partnerId: this.partnerId);
  }

  @override
  String toString() {
    return "id:$id, email:$email, nombre:$nombre";
  }

  static User fromJson(Map<String, dynamic> json) => User(
      id: json["objectId"] != null ? json["objectId"] : json["id"],
      nombre: json["name"],
      email: json["email"] != null ? json["email"] : json["username"],
      password: json["password"],
      invite: json["invite"],
      partnerId: json["partnerId"]);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': nombre,
        'email': email,
        'password': password,
        'username': email,
        'invite': invite,
        'partnerId': partnerId,
      };

  Map<String, dynamic> toJsonForApi() => {
        'name': nombre,
        'email': email,
        'username': email,
        'invite': invite,
        'partnerId': partnerId,
      };
}
