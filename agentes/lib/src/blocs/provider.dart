import 'package:flutter/material.dart';
import 'login_bloc.dart';

import 'package:agentes/src/blocs/pedidos_bloc.dart';

class Provider extends InheritedWidget {
  final _loginBloc = new LoginBloc();
  final _pedidosBloc = new PedidosBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc loginProvider(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>())._loginBloc;
  }

  static LoginBloc logoutProvider(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>())._loginBloc;
  }

  static PedidosBloc pedidosProvider(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>())
        ._pedidosBloc;
  }
}
