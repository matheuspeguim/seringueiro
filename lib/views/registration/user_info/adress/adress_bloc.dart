import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/services/via_cep_service.dart';
import 'adress_event.dart';
import 'adress_state.dart';

class AdressBloc extends Bloc<AdressEvent, AdressState> {
  final ViaCepService viaCepService;
  AdressBloc({required this.viaCepService}) : super(AdressInitial()) {
    on<FetchAdressByCep>(_onFetchAdressByCep);
    on<AdressInfoSubmitted>(_onAdressInfoSubmitted);
  }

  Future<void> _onFetchAdressByCep(
    FetchAdressByCep event,
    Emitter<AdressState> emit,
  ) async {
    emit(AdressLoading());

    // Resetando os campos de endereço antes da nova busca
    emit(AdressInfoState(
      isAdressInfoValid: false,
      rua: '',
      bairro: '',
      cidade: '',
      estado: '',
    ));

    try {
      final cepUnmasked = event.cep.replaceAll('-', '');
      final endereco = await viaCepService.fetchEnderecoByCep(cepUnmasked);
      emit(AdressInfoState(
        isAdressInfoValid: true,
        rua: endereco['logradouro'] ?? '',
        bairro: endereco['bairro'] ?? '',
        cidade: endereco['localidade'] ?? '',
        estado: endereco['uf'] ?? '',
      ));
    } catch (error) {
      emit(AdressFailure(error: error.toString()));
    }
  }

  void _onAdressInfoSubmitted(
      AdressInfoSubmitted event, Emitter<AdressState> emit) async {
    try {
      emit(AdressLoading());
      // Lógica para salvar informações de endereço no Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(event.user.uid)
          .collection('adress_info')
          .doc('info')
          .set({
        'rua': event.rua,
        'bairro': event.bairro,
        'cidade': event.cidade,
        'estado': event.estado,
        'numero': event.numero,
      });
      emit(AdressInfoSuccess(message: 'Endereço salvo com sucesso!'));
    } catch (e) {
      emit(AdressFailure(error: e.toString()));
    }
  }
}
