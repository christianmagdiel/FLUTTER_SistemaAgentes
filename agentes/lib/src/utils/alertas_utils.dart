import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';

void successMessage(BuildContext context, String titulo, String mensaje) {
  SweetAlert.show(context,
      title: titulo, subtitle: mensaje, style: SweetAlertStyle.success);
}

void errorMessage(BuildContext context, String titulo, String mensaje) {
  SweetAlert.show(context,
      title: titulo,
      subtitle: mensaje,
      confirmButtonColor: Color.fromRGBO(255, 0, 0, 1),
      style: SweetAlertStyle.error);
}

Future<bool> confirmDialog(BuildContext context) async {
  return showGeneralDialog<bool>(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      transitionBuilder: (BuildContext context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Column(
                children: <Widget>[
                  Icon(
                    Icons.warning,
                    color: Colors.orange.withOpacity(0.25),
                    size: 100.0,
                  ),
                  SizedBox(height: 10.0),
                  Text('¿Seguro que quiere salir de la aplicación?'),
                ],
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    children: <Widget>[
                      _crearFratButton(context, Colors.red.withOpacity(0.8),
                          'Si', true),
                        Padding(padding: EdgeInsets.only(left: 6.0)),
                      _crearFratButton(context, Colors.grey.withOpacity(0.8),
                          'No', false),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {});
}

Widget _crearFratButton(
    BuildContext context, Color color, String text, bool resp) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
    child: Container(
      width: 90.0,
      color: color,
      child: FlatButton(
        child: Text(text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => Navigator.of(context).pop(resp),
      ),
    ),
  );
}
