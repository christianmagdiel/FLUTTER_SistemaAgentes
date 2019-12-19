import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session {
  final key = 'SESION';
  // Create storage
  final storage = new FlutterSecureStorage();

  set(String token, String refreshToken, int expiresIn) async {
    final data = {
      "accessToken": token,
      "refreshToken": refreshToken,
      "expiresIn": expiresIn,
      "createAt": DateTime.now().toString()
    };
    await storage.write(key: key, value: jsonEncode(data));
  }

  get() async {
    final result = await storage.read(key: key);
    if (result != null) {
      return jsonDecode(result);
    } else {
      return null;
    }
  }

  Future<String> accessToken () async{
    final data = await storage.read(key: key);
    final resp = jsonDecode(data);
    String token = resp['accessToken'];
    print('-----> $token');
    return token ?? '';
  }

  // // Delete all
  deleteSession() async{
    await storage.deleteAll();
  }

  
// // Read all values
// Map<String, String> allValues = await storage.readAll();

// // Delete value
// await storage.delete(key: key);

}


