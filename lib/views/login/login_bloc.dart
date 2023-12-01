// login_bloc.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/views/main/home/home_page.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      // Tente autenticar o usuário com Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.senha,
      );
      User? user = userCredential.user;

      if (userCredential.user != null) {
        // Chama o método para verificar as informações do usuário
        await _checkUserInformation(userCredential.user!, emit);
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }

  Future<void> _checkUserInformation(
      User user, Emitter<LoginState> emit) async {
    // Verifica se as informações pessoais estão presentes
    var personalInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('personal_info')
        .get();

    if (personalInfo.docs.isEmpty) {
      emit(PersonalInfoMissing(
          user: user)); // Estado para informação pessoal faltante
      return;
    }

    var adressInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('adress_info')
        .get();
    if (adressInfo.docs.isEmpty) {
      emit(AdressInfoMissing(
          user: user)); //Estado para infomação de endereço faltante
      return;
    }

    var contactInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('contact_info')
        .get();
    if (contactInfo.docs.isEmpty) {
      emit(ContactInfoMissing(
          user: user)); //Estado para infomação de contato faltante
      return;
    }
    emit(LoginSuccess(user: user));
  }
}
