import 'package:rxdart/rxdart.dart';

import 'package:agentes/src/models/pedido_model.dart';
import 'package:agentes/src/providers/pedidos_provider.dart';

enum NavBarItem {  
  DIA_ACTUAL,
  ULTIMA_SEMANA,
  ULTIMO_MES
}

class PedidosBloc {

  //VARIABLES
  final _today     = new DateTime.now();
  final _pedidosProvider = new PedidosProvider();
  List<PedidoModel> _pedidosControllerAux = new List<PedidoModel>();
  NavBarItem defaultItem = NavBarItem.ULTIMA_SEMANA;

  //CONTROLADORES
  final _pedidosController = new BehaviorSubject<List<PedidoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();
  final _navBarController = new BehaviorSubject<NavBarItem>();
  final _iniciarCargaPedidos = new BehaviorSubject<int>();

  //STREAMS
  Stream<List<PedidoModel>> get pedidosStream => _pedidosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;
  Stream<NavBarItem> get navBarItem => _navBarController.stream;
  Stream<int> get iniciarCargaPedidos => _iniciarCargaPedidos.stream; 

  //VARIABLES PUBLICAS PARA MANEJAR EL CONTROLADOR
  bool get cargandoPedidos => _cargandoController.value;
  String get indexNavBar => _navBarController.value == null ? defaultItem.toString() : _navBarController.value.toString();
  int get iniciarPedidos => _iniciarCargaPedidos.value == null ? 1 : _iniciarCargaPedidos.value;

  //METODOS
  void cargarProductos(DateTime fechaInicio, DateTime fechaFin) async{ 
    _cargandoController.sink.add(true);
    final pedidos = await _pedidosProvider.cargarPedidos(fechaInicio, fechaFin);
    _pedidosController.sink.add(pedidos);
    _pedidosControllerAux = pedidos;
    _cargandoController.sink.add(false);
  }

  void seleccionaItem(int i){
    _pedidosController.sink.add(null);
    switch (i) {
      case 0: 
          cargarProductos(_today, _today);
          _navBarController.sink.add(NavBarItem.DIA_ACTUAL);
        break;
      case 1:
          DateTime ultimaSemana  = _today.add(Duration(days: -7));
          cargarProductos(ultimaSemana, _today);
          _navBarController.sink.add(NavBarItem.ULTIMA_SEMANA);
        break;
      case 2:
          String diaNumero     = _today.day.toString().length == 1 ? '0${_today.day}' : '{_today.day}';
          DateTime ultimoMes     = DateTime.parse('${_today.year}-${_today.month-1}-$diaNumero');
          cargarProductos(ultimoMes, _today);
          _navBarController.sink.add(NavBarItem.ULTIMO_MES);
        break;
    }
  }

   void seleccionaEstatus(int i){
    List<PedidoModel> auxListaPedidos = new List<PedidoModel>();
    _pedidosController.sink.add(_pedidosControllerAux.toList());
    switch (i) {
      case 0: 
        auxListaPedidos = _pedidosController.value.where((x) => 
            x.estatus == 'Empacado, listo para embarque').toList();    
        _pedidosController.sink.add(auxListaPedidos);
        break;
      case 1: 
        auxListaPedidos = _pedidosController.value.where((x) => 
            x.estatus == 'Surtiendose en Sucursal' || 
            x.estatus == 'Aduanado, Listo para Empaque' ||
            x.estatus == 'Listo para surtir').toList();    
        _pedidosController.sink.add(auxListaPedidos);
        break;
      case 2:      
         auxListaPedidos = _pedidosController.value.where((x) => 
            x.estatus != 'Surtiendose en Sucursal' && 
            x.estatus != 'Aduanado, Listo para Empaque' &&
            x.estatus != 'Listo para surtir' &&
            x.estatus != 'Empacado, listo para embarque').toList();    
         _pedidosController.sink.add(auxListaPedidos);
        break;
    }
  }
  
  dispose(){
    _pedidosController?.close();
    _cargandoController.close();
    _navBarController?.close();
    _iniciarCargaPedidos?.close();
  }
}
