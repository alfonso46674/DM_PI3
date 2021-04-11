part of 'exteriornews_bloc.dart';

abstract class ExteriornewsEvent extends Equatable {
  const ExteriornewsEvent();

  @override
  List<Object> get props => [];
}

class RequestInitialExteriorNewsEvent extends ExteriornewsEvent {

  @override 
  List<Object> get props => [];
}

class RequestCustomExteriorNewsEvent extends ExteriornewsEvent {
  final String query;

  RequestCustomExteriorNewsEvent({@required this.query});

  @override 
  List<Object> get props => [query];
}
