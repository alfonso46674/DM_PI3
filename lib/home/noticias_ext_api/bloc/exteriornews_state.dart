part of 'exteriornews_bloc.dart';

abstract class ExteriornewsState extends Equatable {
  const ExteriornewsState();
  
  @override
  List<Object> get props => [];
}

class ExteriornewsInitial extends ExteriornewsState {}

class LoadingExternalNewsState extends ExteriornewsState {}

class LoadedExternalNewsState extends ExteriornewsState {
  final List<New> noticiasExternasList;

  LoadedExternalNewsState({@required this.noticiasExternasList});
  @override 
  List<Object> get props => [noticiasExternasList];
}
//Se manda cuando  no hay conexion
class ErrorMessageExternalNewsState extends ExteriornewsState{
  final String errorMsg;

   ErrorMessageExternalNewsState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg]; 
}
