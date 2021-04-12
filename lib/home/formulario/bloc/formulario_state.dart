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
class SavedExteriorNewState extends FormularioState {
  List<Object> get props => [];
}

class FormularioErrorMessageState extends FormularioState {
  final String errorMsg;

  FormularioErrorMessageState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}