import 'package:app/store/Token.dart';

class AuthServe {
  Future<void> saveToken(String? token) async {
    if (token != null) await Token.saveToken(token);
  }
}
