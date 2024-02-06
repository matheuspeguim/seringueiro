import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_seringueiro/models/property.dart';
import 'property_event.dart';
import 'property_state.dart';

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
      // Lista de nomes de subcoleções a serem excluídas
      final subcollectionsToDelete = [
        'property_users',
        'rain_records',
        //'outra_subcolecao'
      ];

      // Iterar e excluir cada subcoleção
      for (final subcollectionName in subcollectionsToDelete) {
        await _deleteSubcollection(event.propertyId, subcollectionName);
      }

      await FirebaseFirestore.instance
          .collection('properties')
          .doc(event.propertyId)
          .delete();

      emit(PropertyDeleted());
    } catch (e) {
      emit(PropertyError("Erro ao excluir propriedade: $e"));
    }
  }

  Future<void> _deleteSubcollection(
      String propertyId, String subcollectionName) async {
    final subcollectionRef = FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection(subcollectionName);

    final documents = await subcollectionRef.get();

    for (final doc in documents.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
