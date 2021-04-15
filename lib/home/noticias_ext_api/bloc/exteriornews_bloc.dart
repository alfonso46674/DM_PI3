import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/utils/news_repository.dart';
import 'package:hive/hive.dart';

part 'exteriornews_event.dart';
part 'exteriornews_state.dart';

class ExteriornewsBloc extends Bloc<ExteriornewsEvent, ExteriornewsState> {
  final newsRepository = NewsRepository();
  List<New> noticiasExternas;
  Box _externalNewsDataBox = Hive.box('ExternalNews');

  ExteriornewsBloc() : super(ExteriornewsInitial());
//TODO: Bug: Solamente se deberian de guardar las noticias en hive la primera vez que el usuario abre la app con conexion
//Para solucionarlo, crear otro estado que maneje el boton de deportes y que no llame RequestInitialExteriorNewsEvent
  @override
  Stream<ExteriornewsState> mapEventToState(
    ExteriornewsEvent event,
  ) async* {
    //Evento inicial que muestra las noticias de deportes de mexico
    if (event is RequestInitialExteriorNewsEvent) {
      yield LoadingExternalNewsState();
      //Intentar mostrar las noticias de la api, sino mostrar error
      try {
        noticiasExternas = await newsRepository.getAvailableNoticias('sports');

        print('_externalNewsDataBox.length: ${_externalNewsDataBox.length}');
        await _externalNewsDataBox.clear();
        print('_externalNewsDataBox.length: ${_externalNewsDataBox.length}');
        //Guardar las noticias obtenidas de la api en Hive
        //
        //Poner cada UrlToImage de las noticias a null, para que no se guarde un url y posteriormente se intente hacer una peticion a la imagen.
        //Ya que las imagenes se guardan como Image.network si es que UrlToImage no es null
        List<New> localNews = _createLocalNews(noticiasExternas);
        // print('localNews[0]: ${localNews[0]}');
       
          // print('localNews length: ${localNews.length}');
        await _externalNewsDataBox.put('news', localNews);

        yield LoadedExternalNewsState(noticiasExternasList: noticiasExternas);
      } catch (e) {
        //Si hay algo guardado en hive, mostrarlo
        if (_externalNewsDataBox.length != 0) {
          var noticiasLocales = _externalNewsDataBox.get('news');
          // print('noticia local 0:${noticiasLocales[0]}');
          yield LocalStoredNewsState(noticiasLocales: noticiasLocales);
        } else {
          yield ErrorMessageExternalNewsState(errorMsg: e);
        }
      }
    }
    //mostrar noticias de acuerdo a un query
    else if (event is RequestCustomExteriorNewsEvent) {
      try {
        yield LoadedExternalNewsState(noticiasExternasList: await newsRepository.getAvailableNoticias(event.query));
      } catch (e) {
        yield ErrorMessageExternalNewsState(errorMsg: e);
      }
    }

  }

  //Regresa una lista de noticias apropiada para ser guardada en hive
  List<New> _createLocalNews(List<New> noticias) {
    List<New> noticiasLocales = [];
    for (var i = 0; i < noticias.length; i++) {
      noticiasLocales.add(
        New(
          author: noticias[i].author,
          description: noticias[i].description,
          title: noticias[i].title,
          url: noticias[i].url,
          urlToImage: null
        ),
      );
    }
    return noticiasLocales;
  }
}
