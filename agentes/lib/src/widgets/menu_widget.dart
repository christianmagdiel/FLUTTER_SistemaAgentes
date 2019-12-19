import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo_difarmer.png'),
                  fit: BoxFit.fitWidth
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blue),
            title: Text('Home'),
            onTap: () => Navigator.pushReplacementNamed(context,'home'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.border_color,color: Colors.blue),
            title: Text('Consulta de pedidos'),
            onTap: () => Navigator.pushReplacementNamed(context,'consultaPedidos'),
          ),
           ListTile(
            leading: Icon(Icons.settings, color: Colors.blue),
            title: Text('Configuración'),
            onTap: () {}
          ),
        ],
      ),
    );
  }
}