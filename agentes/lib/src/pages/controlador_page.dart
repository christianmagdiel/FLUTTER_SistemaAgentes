import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:agentes/src/app/auth_api.dart';

class ControladorPage extends StatefulWidget {
  @override
  _ControladorPageState createState() => _ControladorPageState();
}

class _ControladorPageState extends State<ControladorPage> {
  final _authApi = AuthApi();
  @override
  void initState() {
    super.initState();
    this._check();
  }

  _check() async {
     final token = await _authApi.getAccessToken();
    if (token != null) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(
          radius: 15,
        ),
      ),
    );
  }
}
