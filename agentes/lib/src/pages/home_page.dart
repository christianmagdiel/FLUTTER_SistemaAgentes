import 'package:flutter/material.dart';
import 'package:agentes/src/widgets/perfil_widget.dart';
import 'package:agentes/src/widgets/menu_widget.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
            PerfilWidget(),
        ],
      ),
      body: Center(
        child: Text('HOME PAGE'),
      ),
      drawer: MenuWidget(),
    );
  }
}