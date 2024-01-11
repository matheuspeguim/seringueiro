import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PropertyButtonsState extends Equatable {
  @override
  List<Object> get props => [];
}

class PropertyButtonsInitial extends PropertyButtonsState {}

class PropertyButtonsLoading extends PropertyButtonsState {}

class PropertyButtonsLoaded extends PropertyButtonsState {
  final List<Widget> buttons;

  PropertyButtonsLoaded(this.buttons);

  @override
  List<Object> get props => [buttons];
}

class PropertyButtonsError extends PropertyButtonsState {
  final String message;

  PropertyButtonsError(this.message);

  @override
  List<Object> get props => [message];
}
