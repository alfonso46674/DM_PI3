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
        } else if (state is ErrorMessageExternalNewsState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("${state.errorMsg}"),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is LoadedExternalNewsState) {
          //si no hay nada en la lista
          //TODO: Implementar mejor manejo de errores para la api
          if (state.noticiasExternasList.length == 0) {
            return Center(
              child: Text("Algo salio mal", style: TextStyle(fontSize: 32)),
            );
          }
          //Si hay elementos en la lista mostrarlos
          else if (state.noticiasExternasList.length > 0) {
            return _externalNews(state.noticiasExternasList);
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
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _externalNews(noticiasExternas) {
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
