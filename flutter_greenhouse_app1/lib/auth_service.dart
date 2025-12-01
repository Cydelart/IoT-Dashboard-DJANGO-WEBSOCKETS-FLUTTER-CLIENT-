//just pour stocker le token  pour appeler l api
//aussi pour stocker les roles poir savoir quoi afficher dans l’UI
class AuthService {
  static String? _accessToken;
  static List<String> _roles = [];

  static void setToken(String token) {
    _accessToken = token;
  }

  static String? get token => _accessToken;

  static bool get isLoggedIn => _accessToken != null;

  static void setRoles(List<String> roles) {
    _roles = roles;
  }

  static bool get isAdmin => _roles.contains("admin");
  static bool get isFarmer => _roles.contains("farmer");
}
