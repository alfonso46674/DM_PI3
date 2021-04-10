part of 'formulario_bloc.dart';

abstract class FormularioEvent extends Equatable {
  const FormularioEvent();

  @override
  List<Object> get props => [];
}

class SaveNewElementEvent extends FormularioEvent {
  final NewFirebase noticia;

  SaveNewElementEvent({@required this.noticia});
  @override
  List<Object> get props => [noticia];
}

class PickImageEvent extends FormularioEvent {
  @override
  List<Object> get props => [];
}