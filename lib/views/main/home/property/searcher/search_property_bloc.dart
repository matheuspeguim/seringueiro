import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'search_property_event.dart';
import 'search_property_state.dart';

class SearchPropertyBloc
    extends Bloc<SearchPropertyEvent, SearchPropertyState> {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Instância direta

  SearchPropertyBloc() : super(SearchInitial()) {
    on<StartSearch>(_onStartSearch);
    on<SearchByName>(_onSearchByName);
  }

  void _onStartSearch(StartSearch event, Emitter<SearchPropertyState> emit) {
    // Lógica inicial para a busca, se necessário
  }

  void _onSearchByName(
      SearchByName event, Emitter<SearchPropertyState> emit) async {
    try {
      emit(SearchInProgress());
      QuerySnapshot querySnapshot = await firestore
          .collection('properties')
          .where('nomeDaPropriedade', isEqualTo: event.propertyName)
          .get();

      // Prepara uma lista para armazenar os futures de Property
      var propertyFutures =
          querySnapshot.docs.map((doc) => Property.fromFirestore(doc)).toList();

      // Aguarda todos os futures serem resolvidos
      List<Property> properties = await Future.wait(propertyFutures);

      emit(SearchSuccess(properties));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }
}
