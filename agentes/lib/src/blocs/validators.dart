import 'dart:async';

class Validators{

  final validarData = StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink){

      if (data.length >= 0){
        sink.add( data );
      }else{
        sink.addError('Ingrese la información solicitada');
      }
    }
  );

}