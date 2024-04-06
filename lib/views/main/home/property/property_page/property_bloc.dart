import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:flutter_seringueiro/common/models/property_user.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_page/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_page/property_state.dart';

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

      // Agora esperamos pela conclusão da operação assíncrona
      Property property = await Property.fromFirestore(propertyDoc);

      QuerySnapshot propertyUserSnapshot = await FirebaseFirestore.instance
          .collection('property_users')
          .where('propertyId', isEqualTo: event.propertyId)
          .where('uid',
              isEqualTo: event
                  .user.uid) // Assumindo que event.user.uid é o UID do Usuario
          .get();

      PropertyUser? propertyUser;
      if (propertyUserSnapshot.docs.isNotEmpty) {
        // Espera pela construção assíncrona de PropertyUser
        propertyUser =
            await PropertyUser.fromFirestore(propertyUserSnapshot.docs.first);
        emit(PropertyLoaded(property,
            propertyUser)); // Assumindo que PropertyLoaded aceita um Property e um PropertyUser
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
