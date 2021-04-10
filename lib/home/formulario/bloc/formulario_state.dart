part of 'formulario_bloc.dart';

abstract class FormularioState extends Equatable {
  const FormularioState();
  
  @override
  List<Object> get props => [];
}

class FormularioInitial extends FormularioState {}

class LoadingFormularioState extends FormularioState {}

class PickedImageState extends FormularioState {
  final File image;

  PickedImageState({@required this.image});
  @override
  List<Object> get props => [image];
}

class SavedNewState extends FormularioState {
  List<Object> get props => [];
}

class ErrorMessageState extends FormularioState {
  final String errorMsg;

  ErrorMessageState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}