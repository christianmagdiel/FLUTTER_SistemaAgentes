import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:agentes/src/utils/alertas_utils.dart';
import 'package:agentes/src/blocs/login_bloc.dart';
import 'package:agentes/src/blocs/provider.dart';

class LoginPageDos extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _crearFondo(context),
            _loginForm(context),
          ],
        ),
      )
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;   
    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * .21, vertical: size.height * .165),
              child: Text(
                'AGENTES',  
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold
                ))),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * .18, vertical: size.height * .35),
              child: Text(
                'Iniciar Sesión',  
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold
                ))),
            Positioned(top: size.height * (-0.22)  ,left: size.width * .04    ,child: _circulo(23,119,250,1.0)),
            Positioned(top: size.height * (-0.16)  ,left: size.width * -.20   ,child: _circulo(23,119,250,0.8)),
            Positioned(top: size.height * 0.90     ,left: size.width * .45    ,child: _circulo(21,43,156,1.0)),
            Positioned(top: size.height * 0.80     ,left: size.width * .80    ,child: _circulo(21,43,156,0.8)),
        ],
      ),
    )
    ;
  }

  Widget _circulo(int r, int g, int b, double opacidad){
    return Container(
      width: 210.0,
      height: 210.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(r, g, b, opacidad)
      ),
    );
  }

  Widget _loginForm(BuildContext context) { 

    final bloc = Provider.loginProvider(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SafeArea(
            child: Container(
              height: size.height * .45
            ),
          ),
          Stack(
           children: <Widget>[
              Container( 
                 height: size.height * .20,  
                 width: size.width * .90,
                 decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.only(
                   bottomRight: Radius.circular(100.0),
                   topRight: Radius.circular(100.0)
                 ),
                 border: Border.all(
                   width: 2,
                   color: Colors.grey
                 ),
              ),
              child: Container(
                padding: EdgeInsets.only(right: 40.0),
                child: Column( 
                  children: <Widget>[
                    _crearUsuario(bloc),
                    Divider(height: 5.0, color: Colors.grey.withOpacity(0.8)),
                    _crearPassword(bloc), 
                  ],
                ),
              ),
              ),
              Container(
                child: _crearBoton(bloc, size),
              ),
              _isLoading(bloc,size)
            ]
          ),
        ],
      ),
    );
  }

  Widget _crearUsuario(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.userStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
         return Container(
          padding: EdgeInsets.only(right: 5.0, top: 10.0),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                Icons.person, 
                color: Color.fromRGBO(8, 87, 246, 1.0),
                size: 40.0,),
              labelText: 'Nombre de usuario'
            ),
            onChanged: (value) => bloc.changeUser(value),
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
         return Container(
          padding: EdgeInsets.only(right: 5.0, top: 10.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                Icons.lock, 
                color: Color.fromRGBO(8, 87, 246, 1.0),
                size: 40.0,),
              labelText: 'Contraseña'
            ),
            onChanged: (value) => bloc.changePassword(value),
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc, Size size){
    return Container(
      padding: EdgeInsets.only(left: size.width*.80, top: size.height*.06),
      child: StreamBuilder<bool>(
        stream: bloc.isLoadingStream,
        initialData: false,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return FloatingActionButton(   
                elevation: 4,
                tooltip: 'Iniciar',      
                child: Container(
                    child: Icon(Icons.arrow_forward, size: 35.0,),
                  ),
                  backgroundColor: Color.fromRGBO(8, 87, 246, 1.0),
                  onPressed:  () => _login(bloc,context)          
              ); 
            },
      )
    );
  }

  Widget _isLoading(LoginBloc bloc,Size size) {
    return StreamBuilder<bool>(
      stream: bloc.isLoadingStream,
      initialData: false,
      builder: (context, snapshot)=>
      snapshot.hasData && snapshot.data
      ?
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: size.height * .25),
            Container(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                backgroundColor: Color.fromRGBO(8, 87, 246, 1),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(height: 5.0),
            Align(
              alignment: FractionalOffset.center,
              child: Text(
                'Cargando . . .', 
                style: TextStyle(
                  color: Color.fromRGBO(8, 87, 246, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0)),
            )
          ]
        )
      :
      Container()
    );
  }

  void _login(LoginBloc bloc ,BuildContext context) async{
    Map info = await bloc.login(bloc.user,bloc.password); 
    if ( info['ok'] ) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      errorMessage(context, 'Ocurrio un error', info['mensaje']);
    }
  }
}