import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'property_event.dart';
import 'property_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  Property? _loadedProperty;
  Timer? _timer;
  PropertyBloc() : super(PropertyInitial()) {
    on<LoadPropertyDetails>(_onLoadPropertyDetails);
    on<GetPropertyUserRole>(_onGetPropertyUserRole);
    on<DeleteProperty>(_onDeleteProperty);
  }

  Future<void> _onLoadPropertyDetails(
      LoadPropertyDetails event, Emitter<PropertyState> emit) async {
    emit(PropertyLoading());
    try {
      DocumentSnapshot propertyDoc = await FirebaseFirestore.instance
          .collection('properties')
          .doc(event.propertyId)
          .get();

      if (propertyDoc.exists) {
        Property property = Property.fromFirestore(propertyDoc);
        _loadedProperty = Property.fromFirestore(
            propertyDoc); // Armazenar a propriedade carregada
        emit(PropertyLoaded(property));
        // Disparar o evento GetPropertyUserRole após carregar a propriedade
        add(GetPropertyUserRole(
            userId: event.user.uid, propertyId: property.id));
      } else {
        emit(PropertyError("Propriedade não encontrada."));
      }
    } catch (e, stackTrace) {
      print('Erro ao carregar propriedade: $e');
      print(stackTrace); // Isso irá imprimir a stack trace completa do erro
      emit(PropertyError("Erro ao carregar propriedade: $e"));
    }
  }

  Future<void> _onGetPropertyUserRole(
      GetPropertyUserRole event, Emitter<PropertyState> emit) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      print("Iniciando busca pelo papel do usuário na propriedade");
      QuerySnapshot querySnapshot = await firestore
          .collection('properties')
          .doc(event.propertyId)
          .collection('property_users')
          .where('uid', isEqualTo: event.userId)
          .get();

      print("Busca concluída, verificando se há documentos");
      if (querySnapshot.docs.isNotEmpty) {
        var userRoleData = querySnapshot.docs.first.data();
        print("Dados do papel do usuário encontrados: $userRoleData");

        if (userRoleData is Map<String, dynamic>) {
          // Acessar o mapa 'funcoes' dentro de 'userRoleData'
          Map<String, dynamic> roles = userRoleData['funcoes'];

          // Agora acessar os valores corretos
          bool isSeringueiro = roles['seringueiro'] ?? false;
          bool isAgronomo = roles['agronomo'] ?? false;
          bool isProprietario = roles['proprietario'] ?? false;
          bool isAdmin = roles['admin'] ?? false;

          print(
              "Papéis do usuário: Seringueiro: $isSeringueiro, Agrônomo: $isAgronomo, Proprietário: $isProprietario, Admin: $isAdmin");

          if (isSeringueiro && isAgronomo && isProprietario && isAdmin) {
            print('Emitindo TodosViewStateAdmin');
            emit(TodosViewStateAdmin(_loadedProperty!));
          } else if (isSeringueiro && isAgronomo && isAdmin) {
            print('Emitindo SeringueiroAgronomoAdminViewState');
            emit(SeringueiroAgronomoAdminViewState(_loadedProperty!));
          } else if (isSeringueiro && isProprietario && isAdmin) {
            print('Emitindo SeringueiroProprietarioAdminViewState');
            emit(SeringueiroProprietarioAdminViewState(_loadedProperty!));
          } else if (isAgronomo && isProprietario && isAdmin) {
            print('Emitindo AgronomoProprietarioAdminViewState');
            emit(AgronomoProprietarioAdminViewState(_loadedProperty!));
          } else if (isSeringueiro && isAdmin) {
            print('Emitindo SeringueiroAdminViewState');
            emit(SeringueiroAdminViewState(_loadedProperty!));
          } else if (isAgronomo && isAdmin) {
            print('Emitindo AgronomoAdminViewState');
            emit(AgronomoAdminViewState(_loadedProperty!));
          } else if (isProprietario && isAdmin) {
            print('Emitindo ProprietarioAdminViewState');
            emit(ProprietarioAdminViewState(_loadedProperty!));
          } else if (isSeringueiro && isAgronomo && isProprietario) {
            print('Emitindo TodosViewState');
            emit(TodosViewState(_loadedProperty!));
          } else if (isSeringueiro && isAgronomo) {
            print('Emitindo SeringueiroAgronomoViewState');
            emit(SeringueiroAgronomoViewState(_loadedProperty!));
          } else if (isSeringueiro && isProprietario) {
            print('Emitindo SeringueiroProprietarioViewState');
            emit(SeringueiroProprietarioViewState(_loadedProperty!));
          } else if (isAgronomo && isProprietario) {
            print('Emitindo AgronomoProprietarioViewState');
            emit(AgronomoProprietarioViewState(_loadedProperty!));
          } else if (isSeringueiro) {
            print('Emitindo SeringueiroViewState');
            emit(SeringueiroViewState(_loadedProperty!));
          } else if (isAgronomo) {
            print('Emitindo AgronomoViewState');
            emit(AgronomoViewState(_loadedProperty!));
          } else if (isProprietario) {
            print('Emitindo ProprietarioViewState');
            emit(ProprietarioViewState(_loadedProperty!));
          } else if (isAdmin) {
            print('Emitindo AdminViewState');
            emit(AdminViewState(_loadedProperty!));
          }
        } else {
          emit(UserActivityFetchFailed());
        }
      } else {
        emit(UserActivityFetchFailed());
      }
    } catch (e) {
      print("Erro ao buscar papel do usuário na propriedade: $e");
      emit(PropertyError("Erro ao buscar papel do usuário na propriedade: $e"));
    }
  }

  Future<void> _onDeleteProperty(
      DeleteProperty event, Emitter<PropertyState> emit) async {
    emit(PropertyLoading());

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Referência ao documento da propriedade na coleção `properties`
      DocumentReference propertyRef =
          firestore.collection('properties').doc(event.propertyId);

      // Excluir o documento da propriedade
      await propertyRef.delete();

      emit(PropertyDeleted());
    } catch (e, stackTrace) {
      print('Erro ao excluir propriedade: $e');
      print(stackTrace);
      emit(PropertyError("Erro ao excluir propriedade: $e"));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
