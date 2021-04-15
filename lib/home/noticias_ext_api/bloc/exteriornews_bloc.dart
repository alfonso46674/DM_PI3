import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/utils/news_repository.dart';

part 'exteriornews_event.dart';
part 'exteriornews_state.dart';

class ExteriornewsBloc extends Bloc<ExteriornewsEvent, ExteriornewsState> {
  final newsRepository = NewsRepository();
  List<New> noticiasExternas;

  ExteriornewsBloc() : super(ExteriornewsInitial());

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
        yield LoadedExternalNewsState(noticiasExternasList: noticiasExternas);
      } catch (e) {
        yield ErrorMessageExternalNewsState(errorMsg: e);
      }
    }
    //mostrar noticias de acuerdo a un query
    else if (event is RequestCustomExteriorNewsEvent) {
      try {
        await newsRepository.getAvailableNoticias(event.query);
        yield LoadedExternalNewsState(noticiasExternasList: noticiasExternas);
      } catch (e) {
        yield ErrorMessageExternalNewsState(errorMsg: e);
      }
    }
  }
}
