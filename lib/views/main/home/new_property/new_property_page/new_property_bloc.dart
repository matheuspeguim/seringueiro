// new_property_bloc.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_property_event.dart';
import 'new_property_state.dart';

class NewPropertyBloc extends Bloc<NewPropertyEvent, NewPropertyState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  NewPropertyBloc() : super(NewPropertyInitial()) {
    on<NewPropertyAddStart>(_onAddStart);
    on<NewPropertySubmit>(_onSubmit);
  }

  void _onAddStart(NewPropertyAddStart event, Emitter<NewPropertyState> emit) {
    // Aqui você pode adicionar lógica inicial, como validações
    emit(NewPropertyLoading());
  }

  Future<void> _onSubmit(
      NewPropertySubmit event, Emitter<NewPropertyState> emit) async {
    emit(NewPropertyLoading());
    try {
      // Cria uma instancia do usuário
      User? user = _auth.currentUser;
      // Cria uma nova instância do Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Adiciona a nova propriedade à coleção 'properties'
      DocumentReference propertyRef =
          await firestore.collection('properties').add({
        'nomeDaPropriedade':
            event.nomeDaPropriedade, // Ajuste conforme necessário
        'areaEmHectares': event.areaEmHectares,
        'quantidadeDeArvores': event.quantidadeDeArvores,
        'cep': event.cep,
        'cidade': event.cidade,
        'estado': event.estado,
        'localizacao': event
            .localizacao, // Certifique-se de converter LatLng para GeoPoint
        'clonePredominante': event.clonePredominante,
      });

      // A partir daqui, supõe-se que 'event.propertyData' contém todos os dados necessários

      // Adiciona o PropertyUser associado à propriedade recém-criada
      await firestore.collection('property_users').add({
        'uid': user!.uid,
        'propertyId': propertyRef.id, // Referência da propriedade criada
        'administrador': true,
        'seringueiro': event.isSeringueiro,
        'agronomo': event.isAgronomo,
        'proprietario': event.isProprietario,
        'usuarioAutorizado': true,
        'propriedadeAutorizada': true,
        // Adicione o campo 'usuario' conforme a estrutura do seu 'Usuario'
      });

      emit(NewPropertyLoaded("Propriedade adicionada com sucesso!"));
    } catch (e) {
      emit(NewPropertyError("Erro ao adicionar propriedade. ${e.toString()}"));
    }
  }
}
