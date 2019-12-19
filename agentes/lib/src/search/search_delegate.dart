import 'package:agentes/src/models/pedido_model.dart';
import 'package:agentes/src/providers/pedidos_provider.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate{

  String seleccion = '';
  final pedidosProvider = new PedidosProvider();

  final peliculas = [
    'Avengers',
    'Batman',
    'Superman',
    'Guason'
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan America'
  ];


  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar (Ej. Borrar texto, cancelar busqueda)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(

      ),
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Son las sugerencias que aparecen cuando la persona escribe

  //   final listaSugerida = (query.isEmpty) 
  //                         ? peliculasRecientes 
  //                         : peliculas.where( 
  //                           (p)=>p.toLowerCase().startsWith(query.toLowerCase())
  //                           ).toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context,i){
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugerida[i]),
  //       );
  //     }
  //   );
  // }

    @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty){
      return Container();
    }
    return FutureBuilder(
      future: pedidosProvider.buscarPedido(query),
      builder: (BuildContext context, AsyncSnapshot<List<PedidoModel>> snapshot) {
        final peliculas = snapshot.data;

        if (snapshot.hasData){
          return ListView(
            children: peliculas.map( (pelicula){
                return ListTile(
                  leading: 
                  // FadeInImage(
                  //   // image: NetworkImage(pelicula.getPosterImg()),
                  //   // placeholder: AssetImage('assets/img/no-image.jpg'),
                  //   // width: 50.0,
                  //   // fit: BoxFit.contain,
                  // ),
                  Text('asd'),
                  title: Text('asd'),
                  subtitle: Text('asdasd'),
                  onTap: () {
                    close(context, null);
                   // pelicula.uniqueId = '';
                    //Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                  },
                );
            }).toList(),
          );
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}