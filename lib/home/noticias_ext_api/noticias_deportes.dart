import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/noticias_ext_api/bloc/exteriornews_bloc.dart';
import 'package:google_login/utils/news_repository.dart';

import 'item_noticia.dart';

class NoticiasDeportes extends StatefulWidget {
  const NoticiasDeportes({Key key}) : super(key: key);

  @override
  _NoticiasDeportesState createState() => _NoticiasDeportesState();
}

class _NoticiasDeportesState extends State<NoticiasDeportes> {
  var queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExteriornewsBloc, ExteriornewsState>(
      listener: (context, state) {
        if (state is LoadingExternalNewsState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Cargando...'),
              ),
            );
          //Mandar error de falta de conexion
        } else if (state is ErrorMessageExternalNewsState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("${state.errorMsg}"),
              ),
            );
        } // mostrar en caso de que no haya conexion y se muestren las noticias locales
        else if (state is LocalStoredNewsState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Mostrando noticias guardadas localmente"),
              ),
            );
        }
      },
      builder: (context, state) {
        //si se pudo conectar a la api
        if (state is LoadedExternalNewsState) {
          //si no hay nada en la lista
          //TODO: Implementar mejor manejo de errores para la api
          if (state.noticiasExternasList.length == 0) {
            return _externalNewsError();
          }
          //Si hay elementos en la lista mostrarlos
          else if (state.noticiasExternasList.length > 0) {
            return _externalNews(state.noticiasExternasList, false);
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        }
        // si no se pudo conectar a la api, mandar llamar las noticias guardadas en hive
        else if (state is LocalStoredNewsState) {
          return _externalNews(state.noticiasLocales, true);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _externalNewsError() {
    return Column(
      children: [
        //barra de busqueda
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: queryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            MaterialButton(
              child: Text('Buscar'),
              onPressed: () {
                BlocProvider.of<ExteriornewsBloc>(context)
                    .add(RequestCustomExteriorNewsEvent(
                  query: queryController.text,
                ));
              },
            ),
            MaterialButton(
              child: Text('Deportes'),
              onPressed: () {
                BlocProvider.of<ExteriornewsBloc>(context)
                    .add(RequestInitialExteriorNewsEvent());
              },
            ),
          ],
        ),
        //mostrar error
        Expanded(
          child: Center(
            child: Text(
              "Algo salio mal",
              style: TextStyle(fontSize: 32),
            ),
          ),
        ),
      ],
    );
  }

  //Segundo parametro sirve como condicional para saber si se tiene que mostrar las noticias en hive o no
  Widget _externalNews(noticiasExternas, mostrandoNoticiasHive) {
    return Column(
      children: [
        //barra de busqueda
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: queryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            MaterialButton(
              child: Text('Buscar'),
              onPressed: () {
                BlocProvider.of<ExteriornewsBloc>(context)
                    .add(RequestCustomExteriorNewsEvent(
                  query: queryController.text,
                ));
              },
            ),
            MaterialButton(
              child: Text('Deportes'),
              onPressed: () {
                BlocProvider.of<ExteriornewsBloc>(context)
                    .add(RequestInitialExteriorNewsEvent());
              },
            ),
          ],
        ),
        Builder(
          builder: (context) {
            final condition = mostrandoNoticiasHive == true;
            return condition
                ? Text(
                    "Algo salio mal; Error de conexion",
                    style: TextStyle(fontSize: 25),
                    maxLines: 2,
                  )
                : Text("");
          },
        ),
        //mostrar noticias
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: noticiasExternas.length,
              itemBuilder: (context, index) {
                return ItemNoticia(
                  noticia: noticiasExternas[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
