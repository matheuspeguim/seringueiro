// home_page_bloc.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'home_page_event.dart';
import 'home_page_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      // Buscando o documento do usuário
      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(user.uid).get();
      var userData = userSnapshot.data();

      // Verificando e fazendo o cast para List<dynamic>
      if (userData is Map<String, dynamic>) {
        List<dynamic> propriedadesRelacionadasList =
            userData['propriedades'] as List<dynamic>? ?? [];

        List<Property> properties = [];
        for (var propriedadeRelacionada in propriedadesRelacionadasList) {
          // Cada item é um mapa, então você pode acessar 'propertyRef' diretamente
          var propertyRef = (propriedadeRelacionada
              as Map<String, dynamic>)['propertyRef'] as DocumentReference;

          DocumentSnapshot propertySnapshot = await propertyRef.get();
          if (propertySnapshot.exists) {
            properties.add(Property.fromFirestore(propertySnapshot));
          }
        }

        emit(PropertiesLoaded(properties));
      } else {
        emit(PropertiesError("Nenhum dado de propriedade encontrado."));
      }
    } catch (e) {
      print("Erro ao buscar propriedades: $e");
      emit(PropertiesError("Erro ao buscar propriedades: $e"));
    }
  }
}
