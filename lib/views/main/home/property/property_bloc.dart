import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'property_event.dart';
import 'property_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  Timer? _timer;

  PropertyBloc() : super(PropertyInitial()) {
    on<LoadPropertyDetails>(_onLoadPropertyDetails);
    on<DeleteProperty>(_onDeleteProperty);
  }

  Future<void> _onLoadPropertyDetails(
      LoadPropertyDetails event, Emitter<PropertyState> emit) async {
    emit(PropertyLoading());
    try {
      DocumentSnapshot propertyDoc = await FirebaseFirestore.instance
          .collection('properties')
          .doc(event.propertyId)
          .get();

      if (propertyDoc.exists) {
        Property property = Property.fromFirestore(propertyDoc);
        emit(PropertyLoaded(property));
      } else {
        emit(PropertyError("Propriedade não encontrada."));
      }
    } catch (e) {
      emit(PropertyError("Erro ao carregar propriedade: $e"));
    }
  }

  Future<void> _onDeleteProperty(
      DeleteProperty event, Emitter<PropertyState> emit) async {
    emit(PropertyLoading());
    try {
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(event.propertyId)
          .delete();
      emit(PropertyDeleted());
    } catch (e) {
      emit(PropertyError("Erro ao excluir propriedade: $e"));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
