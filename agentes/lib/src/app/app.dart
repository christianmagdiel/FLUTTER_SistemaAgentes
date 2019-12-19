import 'package:flutter/material.dart';

import 'package:agentes/src/blocs/provider.dart';
import 'package:agentes/src/app/routes.dart';
import 'package:agentes/src/pages/login_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Agentes',
          initialRoute: 'controlador',
          routes: getApplicationRoutes(),
          onGenerateRoute: (RouteSettings setting){
            return MaterialPageRoute(
              builder: (BuildContext context) => LoginPage()
            );
          },
          theme: ThemeData(
            primaryColor: Color.fromRGBO(8, 87, 246, 1.0)
          ),
        ),
    );
  }
}