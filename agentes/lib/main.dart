import 'package:flutter/material.dart';
import 'package:agentes/src/app/app.dart';
import 'package:agentes/src/preferencias_usuario/preferencias_usuario.dart';

void main() async{
    
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
} 
 
