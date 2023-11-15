// registration_bloc.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/services/via_cep_service.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final ViaCepService viaCepService;

  RegistrationBloc({required this.viaCepService})
      : super(RegistrationInitialState()) {
    on<RegistrationPersonalInfoSubmitted>(_onPersonalInfoSubmitted);
    on<RegistrationContactInfoSubmitted>(_onContactInfoSubmitted);
    on<RegistrationAdressInfoSubmitted>(_onAdressInfoSubmitted);
    on<FetchAdressByCep>(_onFetchAdressByCep);
  }

  Future<void> _onPersonalInfoSubmitted(
    RegistrationPersonalInfoSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());
    try {
      var userDocument =
          FirebaseFirestore.instance.collection('users').doc(event.user.uid);
      await userDocument.collection('personal_info').doc('info').set({
        'nome': event.nome,
        'nascimento': event.dataDeNascimento.toIso8601String(),
        'cpf': event.cpf,
        'rg': event.rg,
      });

      emit(RegistrationPersonalInfoSuccess());
    } catch (error) {
      emit(RegistrationFailure(error: error.toString()));
    }
  }

  Future<void> _onContactInfoSubmitted(
    RegistrationContactInfoSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    // Lógica para tratar RegistrationContactInfoSubmitted
  }

  Future<void> _onAdressInfoSubmitted(
    RegistrationAdressInfoSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());
    try {
      var userDocument =
          FirebaseFirestore.instance.collection('users').doc(event.user.uid);
      await userDocument.collection('adress_info').doc('info').set({
        'cep': event.cep,
        'rua': event.rua,
        'numero': event.numero,
        'bairro': event.bairro,
        'cidade': event.cidade,
        'estado': event.estado,
        // Adicione outros campos conforme necessário
      });

      emit(RegistrationAdressInfoSuccess()); // Estado de sucesso
    } catch (error) {
      emit(RegistrationFailure(error: error.toString())); // Estado de falha
    }
  }

  Future<void> _onFetchAdressByCep(
    FetchAdressByCep event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());

    // Resetando os campos de endereço antes da nova busca
    emit(RegistrationAdressInfoState(
      isAdressInfoValid: false,
      rua: '',
      bairro: '',
      cidade: '',
      estado: '',
    ));

    try {
      final cepUnmasked = event.cep.replaceAll('-', '');
      final endereco = await viaCepService.fetchEnderecoByCep(cepUnmasked);
      emit(RegistrationAdressInfoState(
        isAdressInfoValid: true,
        rua: endereco['logradouro'] ?? '',
        bairro: endereco['bairro'] ?? '',
        cidade: endereco['localidade'] ?? '',
        estado: endereco['uf'] ?? '',
      ));
    } catch (error) {
      emit(RegistrationFailure(error: error.toString()));
    }
  }
}
