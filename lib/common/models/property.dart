import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_response.dart';
import 'package:flutter_seringueiro/common/services/weather_service.dart';

class Property {
  final String id;
  final String nomeDaPropriedade;
  final double areaEmHectares;
  final int quantidadeDeArvores;
  final String cep;
  final String cidade;
  final String estado;
  final GeoPoint localizacao;
  final String clonePredominante;
  WeatherResponse? weather; // Nova propriedade para WeatherResponse

  Property({
    required this.id,
    required this.nomeDaPropriedade,
    required this.areaEmHectares,
    required this.quantidadeDeArvores,
    required this.localizacao,
    required this.cep,
    required this.estado,
    required this.cidade,
    required this.clonePredominante,
    this.weather,
  });

  // Método assíncrono para construir Property a partir do Firestore e incluir WeatherResponse
  static Future<Property> fromFirestore(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Instancia de WeatherService para buscar dados meteorológicos
    WeatherService weatherService = WeatherService();

    // Busca WeatherResponse baseado na localização
    WeatherResponse? weatherResponse = await weatherService.fetchWeather(
      data['localizacao'].latitude,
      data['localizacao'].longitude,
    );

    // Retorna a instância de Property com WeatherResponse incluído
    return Property(
      id: doc.id,
      nomeDaPropriedade: data['nomeDaPropriedade'] ?? '',
      areaEmHectares: data['areaEmHectares']?.toDouble() ?? 0.0,
      quantidadeDeArvores: data['quantidadeDeArvores'] ?? 0,
      localizacao: data['localizacao'] ?? GeoPoint(0, 0),
      cep: data['cep'] ?? '',
      estado: data['estado'] ?? '',
      cidade: data['cidade'] ?? '',
      clonePredominante: data['clonePredominante'] ?? '',
      weather: weatherResponse, // Adicionado aqui
    );
  }
}
