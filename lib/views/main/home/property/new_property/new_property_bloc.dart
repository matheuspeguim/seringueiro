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
    print('Evento SubmitPropertyData acionado!');
    try {
      emit(PropertySubmissionInProgress());
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Criando o documento da propriedade na coleção 'properties' e capturando a referência do documento criado
      DocumentReference propertyRef =
          await firestore.collection('properties').add({
        'nomeDaPropriedade': event.nomeDaPropriedade,
        'quantidadeDeArvores': event.quantidadeDeArvores,
        'localizacao':
            GeoPoint(event.localizacao.latitude, event.localizacao.longitude),
      });

      // Usar a propriedade 'id' do DocumentReference para obter o ID da propriedade recém-criada
      String propertyId = propertyRef.id;

      // Criar o documento em 'property_users' com a propertyId da propriedade recém-criada
      await firestore.collection('property_users').add({
        'uid': event.user.uid,
        'propertyId': propertyId,
        'seringueiro': event.atividadesSelecionadas['seringueiro'] ?? false,
        'agronomo': event.atividadesSelecionadas['agronomo'] ?? false,
        'proprietario': event.atividadesSelecionadas['proprietario'] ?? false,
        'admin': event.atividadesSelecionadas['admin'] ?? true,
      });

      emit(PropertySubmissionSuccess());
    } catch (e) {
      emit(PropertySubmissionFailed(error: e.toString()));
    }
  }
}
