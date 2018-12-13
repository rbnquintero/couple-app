class Environment {
  static final String appId = 'HBGC7ACBv2Sov7jXfIzVanjcrIZSf1VGATW1NtrU';
  static final String restApiKey = 'BU9ChsuJ0RCZ5xGhYY5XmmJFa9tb66G6I1KbiNFA';
  static final String parseUrl = 'https://parseapi.back4app.com/';
  static final String uriUser = 'users';
  static final String uriLogin = 'login';
  static final String uriUserQuery = 'classes/_User';
  static final Map<String, String> parseHeaders = {
    'X-Parse-Application-Id': Environment.appId,
    'X-Parse-REST-API-Key': Environment.restApiKey,
    'X-Parse-Revocable-Session': '1',
    'Content-Type': 'application/json'
  };
}
