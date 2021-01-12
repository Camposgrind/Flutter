import 'package:flutter/material.dart';

import '../models/pelicula_model.dart';
import '../providers/peliculas_provider.dart';

class DataSeach extends SearchDelegate {
  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();
  final peliculas = [
    'Spiderman',
    'FlutterMovie',
    'Pokemon',
    'Superman',
    'Antman',
    'Capitan America'
  ];
  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    //Las acciones de nuestro appBar (el icono para pulsar y limpiar o cancelar la búsqueda)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Icono a la izquierda del appBar
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
    //Crea los resultado que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.fill,
                  ),
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close(context, null);
                  //pongo el unique id vacio porque si no petaría
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  //ESTo era para hacerlo sin la llamada a la API
  /*  @override
  Widget buildSuggestions(BuildContext context) {
    //Las sugerencias que aparecen cuando la persona escribe
    final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(
                  query.toLowerCase(),
                ))
            .toList();
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      },
    );
  }*/
}
