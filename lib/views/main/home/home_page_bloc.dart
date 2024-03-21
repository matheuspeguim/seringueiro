import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:flutter_seringueiro/views/main/home/home_page_event.dart';
import 'package:flutter_seringueiro/views/main/home/home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final User user;

  HomePageBloc({required this.user}) : super(HomePageInitial()) {
    on<FetchPropertiesEvent>(_onFetchProperties);
  }

  void _onFetchProperties(
      FetchPropertiesEvent event, Emitter<HomePageState> emit) async {
    emit(PropertiesLoading());
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Primeiro, buscar as relações de usuário-propriedade
      final propertyUsersSnapshot = await firestore
          .collection('property_users')
          .where('uid', isEqualTo: user.uid)
          .get();

      List<Property> properties = [];

      // Para cada relação encontrada, buscar os detalhes da propriedade
      for (var propertyUserDoc in propertyUsersSnapshot.docs) {
        var propertyId = propertyUserDoc.data()['propertyId'];
        if (propertyId != null) {
          var propertySnapshot =
              await firestore.collection('properties').doc(propertyId).get();
          if (propertySnapshot.exists) {
            properties.add(Property.fromFirestore(propertySnapshot));
          }
        }
      }

      emit(PropertiesLoaded(properties));
    } catch (e) {
      print("Erro ao buscar propriedades: $e");
      emit(PropertiesError("Erro ao buscar propriedades: $e"));
    }
  }
}
