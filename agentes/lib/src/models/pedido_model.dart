import 'dart:convert';

PedidoModel pedidoFromJson(String str) =>
    PedidoModel.fromJson(json.decode(str));

String pedidoToJson(PedidoModel data) => json.encode(data.toJson());

class PedidoModel {
  int codCliente;
  String nombre;
  String negocio;
  int renglones;
  DateTime fechaRecepcion;
  String estatus;
  String origen;
  DateTime fechaActualizacion;

  PedidoModel({
    this.codCliente,
    this.nombre,
    this.negocio,
    this.renglones,
    this.fechaRecepcion,
    this.estatus,
    this.origen,
    this.fechaActualizacion,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) => PedidoModel(
        codCliente: json["codCliente"],
        nombre: json["nombre"],
        negocio: json["negocio"],
        renglones: json["renglones"],
        fechaRecepcion: DateTime.parse(
            json["fechaRecepcion"].toString().replaceAll('T', ' ')),
        estatus: json["estatus"],
        origen: json["origen"],
        fechaActualizacion: DateTime.parse(
            json["fechaActualizacion"].toString().replaceAll('T', ' ')),
      );

  Map<String, dynamic> toJson() => {
        "codCliente": codCliente,
        "nombre": nombre,
        "negocio": negocio,
        "renglones": renglones,
        "fechaRecepcion": fechaRecepcion,
        "estatus": estatus,
        "origen": origen,
        "fechaActualizacion": fechaActualizacion,
      };
}
