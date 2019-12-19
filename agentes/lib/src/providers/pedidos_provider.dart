import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:agentes/src/app/session.dart';
import 'package:agentes/src/models/pedido_model.dart';

class PedidosProvider {
  final String _url = 'http://www.difarmer.com/api/web/';
  final _session = new Session();

  Future<List<PedidoModel>> cargarPedidos(
      DateTime fechaInicio, DateTime fechaFin) async {
    try {
      String _token = '';

      final result = await _session.get();
      if (result != null) {
        _token = result['accessToken'] as String;
      }

      final authData = {
        "codAgente": "12",
        "fechaInicio":
            fechaInicio.toString().split(' ')[0].replaceAll('-', '/'),
        "fechaFin": fechaFin.toString().split(' ')[0].replaceAll('-', '/'),
        //"fechaInicio":"2019/12/02",
        //"fechaFin":"2019/12/02"
      };

      final resp = await http.post('$_url/consulta-pedidos/estatus',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
          body: json.encode(authData));

      final Map<String, dynamic> decodedData = json.decode(resp.body);

      if (resp.statusCode == 200) {
        final List<PedidoModel> pedidos = new List();
        List<dynamic> listPedidosDynamic = decodedData['data'];

        listPedidosDynamic.forEach((pedido) {
          String _fechaRecepcion = pedido['fechaRecepcion'];
          String _fechaActualizacion = pedido['fechaActualizacion'];
          pedido['fechaRecepcion'] = DateFormat("yyyy-MM-dd hh:mm:ss")
              .parse(_fechaRecepcion.replaceAll('T', ' '));
          pedido['fechaActualizacion'] = DateFormat("yyyy-MM-dd hh:mm:ss")
              .parse(_fechaActualizacion.replaceAll('T', ' '));
          final pedidoTemp = PedidoModel.fromJson(pedido);
          pedidos.add(pedidoTemp);
        });
        return pedidos;
      }
      return null;
    } on PlatformException catch (e) {
      print('ERROR ${e.code} : ${e.message}');
      return null;
    }
  }

  Future<List<PedidoModel>> buscarPedido(String query) async {
    return null;
  }
}
