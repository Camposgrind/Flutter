import 'package:flutter/material.dart';

import '../providers/peliculas_provider.dart';
import '../search/search_delegate.dart';
import '../widgets/card_swiper_widget.dart';
import '../widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    return Scaffold(
        appBar: AppBar(
          title: Text('Películas en cines'),
          backgroundColor: Colors.indigoAccent,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSeach(),
                  //Este es para que ponga algo predeterminado
                  //query: 'hola',
                );
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _swiperTarjetas(),
              _footer(context),
            ],
          ),
        )
        //Esto es para los móviles nuevos que tienen un trozo sin pantalla arriba
        //SafeArea(
        //  child: Text('Hola mundo!!!!!!!!'),
        //),
        );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );

    /* 
    peliculasProvider.getEnCines();

    return CardSwiper(
      peliculas: [1, 2, 3, 4, 5],
    );*/
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Populares',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          SizedBox(height: 1.0),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
