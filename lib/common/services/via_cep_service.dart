import 'dart:convert';
import 'package:http/http.dart' as http;

class ViaCepService {
  Future<Map<String, dynamic>> fetchEnderecoByCep(String cep) async {
    // Remove caracteres não numéricos para "limpar" o CEP
    final cepUnmasked = cep.replaceAll(RegExp(r'\D'), '');

    // Verifica se o CEP limpo tem exatamente 8 dígitos
    if (cepUnmasked.length != 8) {
      throw FormatException('O CEP deve conter exatamente 8 dígitos.');
    }

    final url = Uri.parse('https://viacep.com.br/ws/$cepUnmasked/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Verifica se a resposta indica um erro, como um CEP inexistente
      if (data.containsKey('erro') && data['erro']) {
        throw Exception('CEP não encontrado.');
      }
      return data;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Falha ao carregar endereço');
    }
  }
}
