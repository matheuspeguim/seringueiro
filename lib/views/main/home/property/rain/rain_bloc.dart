import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_seringueiro/services/open_weather_api_service.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_state.dart';

class RainBloc extends Bloc<RainEvent, RainState> {
  final FirebaseFirestore firestore;
  final OpenWeatherApiService weatherApiService;

  RainBloc({required this.weatherApiService, required this.firestore})
      : super(RainInitial()) {
    on<StartRainRecording>(_onStartRainRecording);
    on<SaveRainRecord>(_onSaveRainRecord);
    on<LoadRainData>(_onLoadRainData);
    on<LoadRainHistoryFromApi>(_onLoadRainHistoryFromApi);
  }

  Future<void> _onStartRainRecording(
      StartRainRecording event, Emitter<RainState> emit) async {
    emit(RainLoading());
  }

  Future<void> _onSaveRainRecord(
      SaveRainRecord event, Emitter<RainState> emit) async {
    emit(RainLoading());
    try {
      await firestore
          .collection('properties')
          .doc(event.property.id)
          .collection('rain_records')
          .add({
        'user_id': event.user.uid,
        'date': event.date,
        'rain_amount': event.rainAmount,
      });

      emit(RainRecordSaved());
    } catch (e) {
      emit(RainRecordSaveError('Erro ao salvar o registro: $e'));
    }
  }

  Future<void> _onLoadRainData(
      LoadRainData event, Emitter<RainState> emit) async {
    try {
      emit(RainLoading());

      QuerySnapshot snapshot = await firestore
          .collection('properties')
          .doc(event.propertyId)
          .collection('rain_records')
          .orderBy('date')
          .get();

      List<RainChartData> chartData = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return RainChartData(
          date: (data['date'] as Timestamp).toDate(),
          rainAmount: data['rain_amount'] as int,
        );
      }).toList();

      emit(RainChartDataLoaded(chartData: chartData));
    } catch (e) {
      emit(RainRecordSaveError('Erro ao carregar dados de chuva: $e'));
    }
  }

  Future<void> _onLoadRainHistoryFromApi(
      LoadRainHistoryFromApi event, Emitter<RainState> emit) async {
    try {
      emit(RainLoading());
      var rainData = await weatherApiService.fetchRainHistory(event.latitude,
          event.longitude, event.startTimestamp, event.endTimestamp);
      // Converta rainData para o formato necessário
      // Emita um estado com os dados convertidos
    } catch (e) {
      emit(RainRecordSaveError(
          'Erro ao carregar dados históricos de chuva: $e'));
    }
  }
}
