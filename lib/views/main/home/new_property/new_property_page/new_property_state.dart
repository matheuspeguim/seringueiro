// new_property_state.dart

import 'package:equatable/equatable.dart';

abstract class NewPropertyState extends Equatable {
  const NewPropertyState();

  @override
  List<Object> get props => [];
}

class NewPropertyInitial extends NewPropertyState {}

class NewPropertyLoading extends NewPropertyState {}

class NewPropertyLoaded extends NewPropertyState {
  final String result; // Exemplo de resultado, ajuste conforme necessário

  const NewPropertyLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class NewPropertyError extends NewPropertyState {
  final String message;

  const NewPropertyError(this.message);

  @override
  List<Object> get props => [message];
}
