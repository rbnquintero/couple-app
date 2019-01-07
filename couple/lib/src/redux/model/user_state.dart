class UserState {
  bool authenticated;
  int state;
  String sessionId;
  User user;
  User invitedFrom;
  bool connected;

  UserState(
      {this.authenticated = false,
      this.state = 0,
      this.sessionId,
      this.user,
      this.invitedFrom,
      this.connected});

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
  User partner;

  User({
    this.id,
    this.email,
    this.nombre,
    this.password,
    this.invite,
    this.partner,
  });

  User cloneUser() {
    return User(
        id: this.id,
        email: this.email,
        nombre: this.nombre,
        password: this.password,
        invite: this.invite,
        partner: this.partner);
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
      partner: json["partner"] != null
          ? User.fromJsonWithoutPartner(json["partner"])
          : null);

  static User fromJsonWithoutPartner(Map<String, dynamic> json) => User(
      id: json["objectId"] != null ? json["objectId"] : json["id"],
      nombre: json["name"],
      email: json["email"] != null ? json["email"] : json["username"],
      password: json["password"],
      invite: json["invite"],
      partner: null);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': nombre,
        'email': email,
        'password': password,
        'username': email,
        'invite': invite,
      };

  Map<String, dynamic> toJsonForApi() => {
        'name': nombre,
        'email': email,
        'username': email,
        'invite': invite,
        'partner': partner != null ? userToPointer(partner) : null
      };

  static Map<String, String> userToPointer(User user) {
    Map<String, String> map = Map();
    map['__type'] = "Pointer";
    map['className'] = "_User";
    map['objectId'] = user.id;
    return map;
  }
}
