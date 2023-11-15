import 'dart:convert';
import 'package:http/http.dart' as http;

class ViaCepService {
  Future<Map<String, dynamic>> fetchEnderecoByCep(String cepUnmasked) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cepUnmasked/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('API ouviu');
      return json.decode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load address');
    }
  }
}
