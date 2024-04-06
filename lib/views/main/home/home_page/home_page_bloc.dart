import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:flutter_seringueiro/views/main/home/home_page/home_page_event.dart';
import 'package:flutter_seringueiro/views/main/home/home_page/home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final User user;

  HomePageBloc({required this.user}) : super(HomePageInitial()) {
    on<FetchPropertiesEvent>(_onFetchProperties);
  }

  Future<void> _onFetchProperties(
      FetchPropertiesEvent event, Emitter<HomePageState> emit) async {
    emit(PropertiesLoading());
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Buscar as relações de usuário-propriedade
      final propertyUsersSnapshot = await firestore
          .collection('property_users')
          .where('uid', isEqualTo: user.uid)
          .get();

      // Preparar uma lista de Futures para propriedades
      List<Future<Property>> propertyFutures = [];

      // Adicionar cada propriedade na lista de Futures
      for (var propertyUserDoc in propertyUsersSnapshot.docs) {
        var propertyId = propertyUserDoc.data()['propertyId'];
        if (propertyId != null) {
          propertyFutures.add(
              firestore.collection('properties').doc(propertyId).get().then(
            (propertySnapshot) {
              if (propertySnapshot.exists) {
                return Property.fromFirestore(propertySnapshot);
              } else {
                // Lançar um erro ou retornar um valor padrão se a propriedade não existir
                throw Exception("Propriedade não encontrada");
              }
            },
          ));
        }
      }

      // Aguardar a conclusão de todas as chamadas assíncronas
      List<Property> properties = await Future.wait(propertyFutures);

      emit(PropertiesLoaded(properties));
    } catch (e) {
      print("Erro ao buscar propriedades: $e");
      emit(PropertiesError("Erro ao buscar propriedades: $e"));
    }
  }
}
