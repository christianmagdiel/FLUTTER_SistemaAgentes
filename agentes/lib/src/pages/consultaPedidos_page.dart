import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:agentes/src/blocs/provider.dart';
import 'package:agentes/src/blocs/pedidos_bloc.dart';
import 'package:agentes/src/models/pedido_model.dart';
import 'package:agentes/src/widgets/menu_widget.dart';
import 'package:agentes/src/search/search_delegate.dart';

class ConsultaPedidosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pedidosBloc = Provider.pedidosProvider(context);
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(
          title: Text('Consultar pedidos'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            )
          ],
        ),
        body: SafeArea(
            child: Column(
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'LISTA DE PEDIDOS',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: _loadData(pedidosBloc, context, orientation),
            )
          ],
        )),
        drawer: MenuWidget(),
        floatingActionButton: _buttonSpeedDial(context, pedidosBloc),
        bottomNavigationBar: _bottomNavigationBar(pedidosBloc));
  }

  Widget _bottomNavigationBar(PedidosBloc pedidosBloc) {
    return StreamBuilder<NavBarItem>(
        stream: pedidosBloc.navBarItem,
        initialData: pedidosBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavigationBar(
              onTap: (i) => pedidosBloc.seleccionaItem(i),
              currentIndex: snapshot.data.index,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    title: Text("Dia Actual")),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_view_day),
                  title: Text("Ultima Semana"),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.date_range), title: Text("Ultimo Mes"))
              ]);
        });
  }

  _buttonSpeedDial(BuildContext context, PedidosBloc pedidosBloc) {
    return SpeedDial(
      marginRight: 10,
      marginBottom: 10,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 20.0),
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Filtrar por estado',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 10.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
            backgroundColor: Colors.green,
            label: 'Listos',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => pedidosBloc.seleccionaEstatus(0)),
        SpeedDialChild(
          backgroundColor: Colors.blue,
          label: 'En proceso',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => pedidosBloc.seleccionaEstatus(1),
        ),
        SpeedDialChild(
          backgroundColor: Colors.red,
          label: 'Negados',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => pedidosBloc.seleccionaEstatus(2),
        ),
      ],
    );
  }

  _loadData(PedidosBloc pedidosBloc, BuildContext context, Orientation orientation) {
    final size = MediaQuery.of(context).size;
    if (pedidosBloc.iniciarPedidos == 1) pedidosBloc.seleccionaItem(1);
    return StreamBuilder(
      stream: pedidosBloc.pedidosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<PedidoModel>> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting ||
            (pedidosBloc.cargandoPedidos)) {
          return Padding(
            padding: EdgeInsets.only(bottom: size.height * .45),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          final pedidos = snapshot.data;
          return Container(
            height: orientation == Orientation.portrait ? size.height * .75 : size.height * .50,
            child: ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, i) =>
                  _crearItem(context, pedidos[i], pedidosBloc),
            ),
          );
        }
      },
    );
  }

  Widget _crearItem(
      BuildContext context, PedidoModel pedido, PedidosBloc pedidosBloc) {
    return ListTile(
      leading: Container(
        child: CircleAvatar(
        backgroundColor: _statusChangeColor(pedido),
        child: Text('${pedido.renglones}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      ), 
      title: Text('${pedido.codCliente} - ${pedido.nombre}'),
      subtitle: Text('${pedido.fechaRecepcion}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Folio',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('${pedido.renglones}',
              style: TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  _statusChangeColor(PedidoModel pedido) {
    Color color;
    switch (pedido.estatus) {
      case 'Aduanado, Listo para Empaque':
        color = Colors.blue;
        break;
      case 'Surtiendose en Sucursal':
        color = Colors.blue;
        break;
      case 'Listo para surtir':
        color = Colors.blue;
        break;
      case 'Empacado, listo para embarque':
        color = Colors.green;
        break;
      default:
        color = Colors.red;
    }
    return color;
  }
}
