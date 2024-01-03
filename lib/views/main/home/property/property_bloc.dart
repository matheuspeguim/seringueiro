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
    on<FetchUserActivity>(_onFetchUserActivity);
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
    } catch (e, stackTrace) {
      print('Erro ao carregar propriedade: $e');
      print(stackTrace); // Isso irá imprimir a stack trace completa do erro
      emit(PropertyError("Erro ao carregar propriedade: $e"));
    }
  }

  Future<void> _onFetchUserActivity(
      FetchUserActivity event, Emitter<PropertyState> emit) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Buscar o documento do usuário
      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(event.userId).get();
      var userData = userSnapshot.data();

      if (userData is Map<String, dynamic>) {
        List<dynamic> propriedadesRelacionadas =
            userData['propriedadesRelacionadas'] as List<dynamic>? ?? [];

        // Encontrar a propriedade específica e a função do usuário
        var userProperty = propriedadesRelacionadas.firstWhere(
          (prop) =>
              (prop as Map<String, dynamic>)['propertyRef'].id ==
              event.propertyId,
          orElse: () => null,
        );

        if (userProperty != null) {
          String activity = (userProperty as Map<String, dynamic>)['funcao'];
          emit(UserActivityFetched(activity: activity));
        } else {
          emit(UserActivityFetchFailed());
        }
      } else {
        emit(UserActivityFetchFailed());
      }
    } catch (e) {
      print("Erro ao buscar atividade do usuário: $e");
      emit(UserActivityFetchFailed());
    }
  }

  Future<void> _onDeleteProperty(
      DeleteProperty event, Emitter<PropertyState> emit) async {
    emit(PropertyLoading());

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    try {
      // Excluir o documento da propriedade na coleção `properties`
      DocumentReference propertyRef =
          firestore.collection('properties').doc(event.propertyId);
      batch.delete(propertyRef);

      // Encontrar todos os usuários que têm essa propriedade em `propriedadesRelacionadas`
      QuerySnapshot usersSnapshot = await firestore
          .collection('users')
          .where('propriedadesRelacionadas', arrayContains: propertyRef)
          .get();

      for (var userDoc in usersSnapshot.docs) {
        // Obter dados do documento do usuário como um Map<String, dynamic>
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        // Extrair a lista atual de propriedadesRelacionadas do usuário
        List<dynamic> updatedProperties =
            List.from(userData['propriedadesRelacionadas'] ?? []);
        // Remover a propriedade que está sendo excluída
        updatedProperties.removeWhere((prop) =>
            (prop as Map<String, dynamic>)['propertyRef'] == propertyRef);

        DocumentReference userRef =
            firestore.collection('users').doc(userDoc.id);
        batch.update(userRef, {'propriedadesRelacionadas': updatedProperties});
      }

      // Executar o lote de operações
      await batch.commit();

      emit(PropertyDeleted());
    } catch (e, stackTrace) {
      print('Erro ao excluir propriedade e atualizar usuários: $e');
      print(stackTrace);
      emit(PropertyError(
          "Erro ao excluir propriedade e atualizar usuários: $e"));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
