import 'package:app/utils/MyToken.dart';

class AuthServe {
  saveToken(String? token) async {
    if (token != null) await MyToken.setToken(token);
  }
}
