import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_property_event.dart';
import 'new_property_state.dart';

class NewPropertyBloc extends Bloc<NewPropertyEvent, NewPropertyState> {
  NewPropertyBloc() : super(LocationSelectionState()) {
    on<StartLocationSelection>(_onStartLocationSelection);
    on<ConfirmLocation>(_onConfirmLocation);
    on<EnterPropertyName>(_onEnterPropertyName);
    on<SubmitPropertyData>(_onSubmitPropertyData);
  }

  void _onStartLocationSelection(
      StartLocationSelection event, Emitter<NewPropertyState> emit) {
    // Implementar a lógica para iniciar a seleção de localização
  }

  void _onConfirmLocation(
      ConfirmLocation event, Emitter<NewPropertyState> emit) {
    // Implementar a lógica para confirmar a localização e transição para inserir o nome da propriedade
    emit(PropertyNameEntryState(event.location));
  }

  void _onEnterPropertyName(
      EnterPropertyName event, Emitter<NewPropertyState> emit) {
    // Implementar a lógica para o usuário inserir o nome da propriedade
  }

  void _onSubmitPropertyData(
      SubmitPropertyData event, Emitter<NewPropertyState> emit) async {
    try {
      emit(PropertySubmissionInProgress());
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Criando o documento da propriedade na coleção 'properties'
      DocumentReference propertyRef =
          await firestore.collection('properties').add({
        'nomeDaPropriedade': event.nomeDaPropriedade,
        'quantidadeDeArvores': event.quantidadeDeArvores,
        'localizacao':
            GeoPoint(event.localizacao.latitude, event.localizacao.longitude),
      });

      // Criar a subcoleção 'property_users' para armazenar os usuários relacionados à propriedade
      CollectionReference usersRef = propertyRef.collection('property_users');
      await usersRef.add({
        'uid': event.user.uid,
        'funcoes': {
          'seringueiro': event.atividadesSelecionadas['seringueiro'] ?? false,
          'agronomo': event.atividadesSelecionadas['agronomo'] ?? false,
          'proprietario': event.atividadesSelecionadas['proprietario'] ?? false,
        },
        'isAdmin': true, // A pessoa que cria a propriedade é o admin por padrão
      });

      emit(PropertySubmissionSuccess());
    } catch (e) {
      emit(PropertySubmissionFailed(error: e.toString()));
    }
  }
}
