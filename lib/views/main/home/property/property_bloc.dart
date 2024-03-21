import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:flutter_seringueiro/common/models/property_user.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
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

      if (!propertyDoc.exists) {
        emit(PropertyError("Propriedade não encontrada."));
        return;
      }

      Property property = Property.fromFirestore(propertyDoc);

      QuerySnapshot propertyUserSnapshot = await FirebaseFirestore.instance
          .collection('property_users')
          .where('propertyId', isEqualTo: event.propertyId)
          .where('uid', isEqualTo: event.user.uid)
          .get();

      PropertyUser? propertyUser;
      if (propertyUserSnapshot.docs.isNotEmpty) {
        propertyUser =
            PropertyUser.fromFirestore(propertyUserSnapshot.docs.first);
        emit(PropertyLoaded(property, propertyUser));
      } else {
        // Emite um estado indicando que a propriedade foi carregada, mas o usuário não tem permissões registradas.
        emit(PropertyError('Usuário sem permissão.'));
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

      final propertyUsersSnapshot = await FirebaseFirestore.instance
          .collection('property_users')
          .where('propertyId', isEqualTo: event.propertyId)
          .get();

      for (final doc in propertyUsersSnapshot.docs) {
        await doc.reference.delete();
      }

      emit(PropertyDeleted());
    } catch (e) {
      emit(PropertyError("Erro ao excluir propriedade: $e"));
    }
  }
}
