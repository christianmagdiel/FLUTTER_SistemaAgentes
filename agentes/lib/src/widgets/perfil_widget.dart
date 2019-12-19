import 'package:agentes/src/blocs/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:agentes/src/blocs/provider.dart';
import 'package:agentes/src/utils/alertas_utils.dart';

class PerfilWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.logoutProvider(context);

    return PopupMenuButton<int>(
      icon: Icon(Icons.account_circle),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              Icon(Icons.account_circle, color: Theme.of(context).primaryColor),
              SizedBox(width: 10),
              Text("Perfil"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Divider(color: Colors.black),
                Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Cerrar sesión", textAlign: TextAlign.left)
                  ],
                )
              ],
            ),
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 2:
            confirmDialog(context).then((resp) {
              if (resp) {
                _cerrarSesion(context, bloc);
              }
            });
            break;
          default:
        }
      },
    );
  }

  void _cerrarSesion(BuildContext context, LoginBloc bloc) async {
    Map info = await bloc.logout(bloc.user, bloc.password);
    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'login');
    } else {
      errorMessage(context, 'Ocurrio un error', info['mensaje']);
    }
  }
}
