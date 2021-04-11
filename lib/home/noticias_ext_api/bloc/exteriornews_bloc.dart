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
  

  ExteriornewsBloc() : super(ExteriornewsInitial());

  @override
  Stream<ExteriornewsState> mapEventToState(
    ExteriornewsEvent event,
  ) async* {
    //Evento inicial que muestra las noticias de deportes de mexico
    if(event is RequestInitialExteriorNewsEvent){
      yield LoadingExternalNewsState();
      yield LoadedExternalNewsState(noticiasExternasList: await newsRepository.getAvailableNoticias('sports'));
    }
    //mostrar noticias de acuerdo a un query
    else if(event is RequestCustomExteriorNewsEvent){
      yield LoadedExternalNewsState(noticiasExternasList: await newsRepository.getAvailableNoticias(event.query));
    }
  }
}
