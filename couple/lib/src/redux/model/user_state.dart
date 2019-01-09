class UserState {
  bool authenticated;
  int state; // Error: -1, LoggingIn:1, LoggedIn: 2, DataComplete:3
  bool updating;
  String error;
  User user;
  User invitedFrom;
  bool connected;

  UserState(
      {this.authenticated = false,
      this.state = 0,
      bool updating = false,
      this.user,
      this.error,
      this.invitedFrom,
      this.connected});

  @override
  String toString() {
    return "{authenticated:$authenticated, state:$state, user:$user, updating:$updating}";
  }
}

class User {
  String id;
  String email;
  String name;
  String password;
  String invite;
  User partner;

  User({
    this.id,
    this.email,
    this.name,
    this.password,
    this.invite,
    this.partner,
  });

  User cloneUser() {
    return User(
        id: this.id,
        email: this.email,
        name: this.name,
        password: this.password,
        invite: this.invite,
        partner: this.partner);
  }

  @override
  String toString() {
    return "id:$id, email:$email, name:$name";
  }

  static User fromJson(Map<String, dynamic> json) => User(
      id: json["objectId"] != null ? json["objectId"] : json["id"],
      name: json["name"],
      email: json["email"] != null ? json["email"] : json["username"],
      password: json["password"],
      invite: json["invite"],
      partner: json["partner"] != null
          ? User.fromJsonWithoutPartner(json["partner"])
          : null);

  static User fromJsonWithoutPartner(Map<String, dynamic> json) => User(
      id: json["objectId"] != null ? json["objectId"] : json["id"],
      name: json["name"],
      email: json["email"] != null ? json["email"] : json["username"],
      password: json["password"],
      invite: json["invite"],
      partner: null);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'username': email,
        'invite': invite,
      };

  Map<String, dynamic> toJsonForApi() => {
        'name': name,
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
