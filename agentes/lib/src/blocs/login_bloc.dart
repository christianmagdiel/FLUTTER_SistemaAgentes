import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:agentes/src/providers/usuario_provider.dart';
import 'package:agentes/src/blocs/validators.dart';

class LoginBloc with Validators{
  final _usuarioProvider = new UsuarioProvider();
  
  final _passwordController = BehaviorSubject<String>();
  final _userController = BehaviorSubject<String>();
  final _isLoadingController = BehaviorSubject<bool>();

  //Recuperar los datos del Stream
  Stream<String> get passwordStream  => _passwordController.stream.transform(validarData);
  Stream<String> get userStream  => _userController.stream.transform(validarData);

  Stream<bool> get isLoadingStream  => _isLoadingController.stream;

  Stream<bool> get formValidStream =>
  Observable.combineLatest2(userStream, passwordStream, (e,p)=> true);

  //Obtener el ultimo valor ingresado a los Streams
  String get password => _passwordController.value;
  String get user => _userController.value;

  //Insertar valores al Stream
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeUser => _userController.sink.add;
  
  //Metodos
  Future<Map<String,dynamic>> login(String user ,String password) async{
    _isLoadingController.sink.add(true);
    Map resp = await _usuarioProvider.login(user,password);
    _isLoadingController.sink.add(false);
    return resp;
  }

  Future<Map<String,dynamic>> logout(String user ,String password) async{
    Map resp = await _usuarioProvider.logout(user,password);
    return resp;
  }

  dispose(){
    _passwordController?.close();
    _userController?.close();
    _isLoadingController?.close();
  }
}