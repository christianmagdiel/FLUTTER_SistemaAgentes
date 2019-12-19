import 'package:agentes/src/blocs/login_bloc.dart';
import 'package:agentes/src/blocs/provider.dart';
import 'package:agentes/src/utils/alertas_utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        backgroundColor: Color.fromRGBO(25, 88, 148, 1),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
                  width: double.infinity,
                  height: size.height,
                  child: orientation == Orientation.portrait
                      ? Stack(
                          children: <Widget>[
                            _formulario(context, size),
                            _crearLogo(size),
                          ],
                        )
                      : GridView.count(
                          primary: false,
                          //padding: EdgeInsets.all(1),
                          crossAxisSpacing: 0, //Espacio entre columnas
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              child: _crearLogoLandscape(size),
                              color: Colors.white,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: _formularioLandscape(context, size),
                              color: Colors.white,
                            )
                          ],
                        ))),
        ));
  }

  Widget _crearLogoLandscape(Size size) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            border:
                Border.all(color: Colors.blue.withOpacity(0.5), width: 3.0)),
        child: ClipOval(
            child: Image.asset('assets/images/logo_agentes.png',
                fit: BoxFit.fill)),
      ),
    );
  }

  Widget _formularioLandscape(BuildContext context, Size size) {
    final blocProvider = Provider.loginProvider(context);
    return Container(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _usuario(blocProvider),
            _password(blocProvider),
            _botonLogin(blocProvider)
          ],
        ),
      ),
    );
  }

  Widget _crearLogo(Size size) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: size.height * 0.65),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            border:
                Border.all(color: Colors.blue.withOpacity(0.5), width: 3.0)),
        child: ClipOval(
            child: Image.asset('assets/images/logo_agentes.png',
                fit: BoxFit.fill)),
      ),
    );
  }

  Widget _formulario(BuildContext context, Size size) {
    final blocProvider = Provider.loginProvider(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: size.height * .15),
        child: ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(200.0)),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _usuario(blocProvider),
                _password(blocProvider),
                _botonLogin(blocProvider)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _usuario(LoginBloc blocProvider) {
    return _disenioInput('Código de Usuario', blocProvider.userStream,
        blocProvider.changeUser, TextInputType.text, Icons.account_box, false);
  }

  Widget _password(LoginBloc blocProvider) {
    return _disenioInput(
        'Contraseña',
        blocProvider.passwordStream,
        blocProvider.changePassword,
        TextInputType.visiblePassword,
        Icons.lock,
        true);
  }

  Widget _disenioInput(
      String lblText,
      Stream<String> tipoBlocProvider,
      Function strChangeTipoBlocProvider,
      TextInputType inputType,
      IconData icono,
      bool isPassword) {
    return StreamBuilder(
        stream: tipoBlocProvider,
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Color.fromRGBO(242, 238, 237, 1),
                border: Border.all(
                    color: Colors.blue.withOpacity(0.5), width: 3.0)),
            child: Container(
              child: TextField(
                obscureText: isPassword,
                autofocus: true,
                keyboardType: inputType,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: lblText,
                    labelStyle: TextStyle(fontSize: 16),
                    icon: Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.0),
                      child: Icon(
                        icono,
                        size: 40.0,
                      ),
                    )),
                onChanged: (value) => strChangeTipoBlocProvider(value),
              ),
            ),
          );
        });
  }

  Widget _botonLogin(LoginBloc blocProvider) {
    return StreamBuilder(
      stream: blocProvider.isLoadingStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.data) {
          return StreamBuilder<bool>(
              stream: blocProvider.formValidStream,
              builder: (context, snapshot) {
                return Container(
                  height: 85,
                  width: 200,
                  padding: EdgeInsets.only(top: 30),
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Color.fromRGBO(25, 88, 148, 1),
                    highlightColor: Colors.red,
                    icon: Icon(Icons.forward, color: Colors.white),
                    label: Text('Iniciar sesión',
                        style: TextStyle(color: Colors.white)),
                    onPressed: snapshot.hasData ? () => _login(blocProvider, context) : null,
                  ),
                );
              });
        } else {
          return Container(
            width: 100,
            height: 80,
            child: Container(
              width: 100,
              height: 40,
              child:
                  Image.asset('assets/images/cargando.gif', fit: BoxFit.fill),
            ),
          );
        }
      },
    );
  }

  void _login(LoginBloc bloc, BuildContext context) async {
    Map info = await bloc.login(bloc.user, bloc.password);
    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      errorMessage(context, 'Ocurrio un error', info['mensaje']);
    }
  }
}
