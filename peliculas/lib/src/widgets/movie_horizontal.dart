import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    //Cuanto porcentaje ocupa una tarjeta en la pantalla
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      //Aqui he cambiado la altura tanto en el movie horizontal
      // como en el card_swiper para que me entre
      height: _screenSize.height * 0.2,
      //El pageview builder es para que carge bajo demanda
      child: PageView.builder(
        //Esto es para que no tenga efecto de iman
        pageSnapping: false,
        controller: _pageController,
        //children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context, i) {
          return _crearTarjeta(context, peliculas[i]);
        },
      ),
    );
  }

  Widget _crearTarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-poster';
    final peliculaTarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          Column(
            children: [
              Hero(
                tag: pelicula.uniqueId,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(pelicula.getPosterImg()),
                    fit: BoxFit.cover,
                    height: 140.0,
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                pelicula.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          )
        ],
      ),
    );

    //El gestureDetector es para cuando pulsamos el widget
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
      child: peliculaTarjeta,
    );
  }

  List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(pelicula.getPosterImg()),
                    fit: BoxFit.cover,
                    height: 140.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  pelicula.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            )
          ],
        ),
      );
    }).toList();
  }
}
