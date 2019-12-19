import 'dart:convert';
import 'package:agentes/src/app/auth_api.dart';
import 'package:http/http.dart' as http;
import 'package:agentes/src/app/session.dart';

class UsuarioProvider {
  // final String _url = 'http://www.difarmer.com/api/web/';
  final _session = new Session();
  final authApi = AuthApi();

  Future<Map<String, dynamic>> login(String user, String password) async {
    try {
      final authData = {"usuario": user, "password": password};
      final resp = await http.post('${authApi.url}/seguridad/login/',
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(authData));
      //PENDIENTE EVALUAR ESTADOS DE RESPUESTA .....
      Map<String, dynamic> decodedResp = json.decode(resp.body);

      if (resp.statusCode == 200) {
        final token = decodedResp['data']['accessToken'] as String;
        final refreshToken = decodedResp['data']['refreshToken'] as String;
        final expiresIn = decodedResp['data']['expiresIn'] as int;

        await _session.set(token, refreshToken, expiresIn);

        return {'ok': true, 'token': decodedResp['data']['accessToken']};
      } else {
        return {'ok': false, 'mensaje': decodedResp['message']};
      }
    } catch (e) {
      return {'ok': false, 'mensaje': e.toString()};
    }
  }

  Future<Map<String, dynamic>> logout(String user, String password) async {
    try {
      String _token = '';

      final result = await _session.get();
      if (result != null) _token = result['accessToken'] as String;

      final authData = {"usuario": 'a31', "password": '123'};
      final resp = await http.post('${authApi.url}/seguridad/login/',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
          body: json.encode(authData));

      Map<String, dynamic> decodedResp = json.decode(resp.body);

      if (resp.statusCode == 200) {
        _session.deleteSession();

        return {'ok': true, 'token': decodedResp['message']};
      } else {
        return {'ok': false, 'mensaje': decodedResp['message']};
      }
    } catch (e) {
      return {'ok': false, 'mensaje': e};
    }
  }
}
