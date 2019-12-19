import 'package:flutter/material.dart';
import 'package:agentes/src/pages/login_page.dart';
import 'package:agentes/src/pages/home_page.dart';
import 'package:agentes/src/pages/controlador_page.dart';
import 'package:agentes/src/pages/consultaPedidos_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes(){
  return <String, WidgetBuilder>{
        'controlador'     : (BuildContext context) => ControladorPage(),
        'login'        : (BuildContext context) => LoginPage(),
        'home'            : (BuildContext context) => HomePage(),
        'consultaPedidos' : (BuildContext context) => ConsultaPedidosPage()
  };
}