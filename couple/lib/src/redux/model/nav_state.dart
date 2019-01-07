class NavState {
  final String route;
  final String title;
  NavState({this.route = '/', this.title = ''});

  @override
  String toString() {
    return "{route:$route, title:$title}";
  }
}
