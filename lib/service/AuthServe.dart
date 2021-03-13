import 'package:app/utils/MyStorage.dart';

class AuthServe {
  saveToken(String? token) async {
    if (token != null) await MyStorage.setToken(token);
  }
}
