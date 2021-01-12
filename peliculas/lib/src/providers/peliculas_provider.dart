import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/actores_model.dart';
import '../models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = 'b257afd17aab337cf08529ce4a8f3a21';
  String _url = 'api.themoviedb.org';
  String _languaje = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();
  //El broadcast es para que más de un lugar pueda escuchar la emisión del stream
  //si no solo tendria un listener
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.miListaPeliculas;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _languaje,
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];
    _cargando = true;

    _popularesPage++;

    final url = Uri.https(
      _url,
      '3/movie/popular',
      {
        'api_key': _apikey,
        'language': _languaje,
        'page': _popularesPage.toString()
      },
    );

    final respuesta = await _procesarRespuesta(url);

    _populares.addAll(respuesta);
    popularesSink(_populares);

    _cargando = false;

    return respuesta;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key': _apikey,
      'language': _languaje,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apikey,
      'language': _languaje,
      'query': query,
    });

    return await _procesarRespuesta(url);
  }
}
