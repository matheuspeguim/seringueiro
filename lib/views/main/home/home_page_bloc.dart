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

      // Nova consulta para buscar propriedades relacionadas ao usuário
      QuerySnapshot propertiesSnapshot = await firestore
          .collectionGroup('property_users')
          .where('uid', isEqualTo: user.uid)
          .get();

      List<Property> properties = [];
      for (var doc in propertiesSnapshot.docs) {
        // Obter o documento da propriedade principal
        DocumentReference propertyRef = doc.reference.parent.parent!;
        DocumentSnapshot propertySnapshot = await propertyRef.get();
        if (propertySnapshot.exists) {
          properties.add(Property.fromFirestore(propertySnapshot));
        }
      }

      emit(PropertiesLoaded(properties));
    } catch (e) {
      print("Erro ao buscar propriedades: $e");
      emit(PropertiesError("Erro ao buscar propriedades: $e"));
    }
  }
}
