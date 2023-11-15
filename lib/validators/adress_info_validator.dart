import 'package:intl/intl.dart';

class AdressInfoValidator {
  //VALIDAR CEP
  static String? validarCEP(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O CEP é obrigatório';
    }

    // Regex para validar o CEP
    final RegExp cepRegex = RegExp(r'^\d{5}-\d{3}$');

    if (!cepRegex.hasMatch(valor)) {
      return 'Digite um CEP válido';
    }

    return null;
  }

  //VALIDAR RUA OU SÍTIO
  static String? validarRuaOuSitio(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O nome da rua ou sítio é obrigatório';
    }

    // Regex para validar que o nome contém apenas letras, números, espaços e alguns caracteres especiais
    final RegExp nomeRuaOuSitioRegex =
        RegExp(r'^[a-zA-Z0-9\sáéíóúÁÉÍÓÚãõÃÕçÇâêôÂÊÔ\-\(\)]+$');

    if (!nomeRuaOuSitioRegex.hasMatch(valor)) {
      return 'Digite um nome válido, contendo apenas letras, números, espaços e caracteres especiais permitidos';
    }

    return null;
  }

  //VALIDAR NUMERO
  static String? validarNumero(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O número do endereço é obrigatório';
    }

    // Regex para validar que o número do endereço contém apenas números e/ou "s/n"
    final RegExp numeroEnderecoRegex = RegExp(r'^\d+|SN$');

    if (!numeroEnderecoRegex.hasMatch(valor)) {
      return 'Digite um número de endereço válido ou marque a opção sem número';
    }

    return null;
  }

  //VALIDAR BAIRRO
  static String? validarBairro(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O campo bairro é obrigatório';
    }

    // Regex para validar que o nome contém apenas letras, números, espaços e alguns caracteres especiais
    final RegExp nomeBairroRegex =
        RegExp(r'^[a-zA-Z0-9\sáéíóúÁÉÍÓÚãõÃÕçÇâêôÂÊÔ\-]+$');

    if (!nomeBairroRegex.hasMatch(valor)) {
      return 'Digite um nome de bairro válido, contendo apenas letras, números, espaços e caracteres especiais permitidos';
    }

    return null; // Bairro válido
  }

  //VALIDAR CIDADE
  static String? validarCidade(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O campo cidade é obrigatório';
    }

    // Regex para validar que o nome da cidade contém apenas letras, espaços e alguns caracteres especiais
    final RegExp nomeCidadeRegex =
        RegExp(r'^[a-zA-Z\sáéíóúÁÉÍÓÚãõÃÕçÇâêôÂÊÔ\-]+$');

    if (!nomeCidadeRegex.hasMatch(valor)) {
      return 'Digite um nome de cidade válido, contendo apenas letras, espaços e caracteres especiais permitidos';
    }

    return null; // Cidade válida
  }

  //VALIDAR ESTADO
  static String? validarEstado(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O campo estado é obrigatório';
    }

    // Lista de estados brasileiros
    const List<String> estadosBrasileiros = [
      'AC',
      'AL',
      'AP',
      'AM',
      'BA',
      'CE',
      'DF',
      'ES',
      'GO',
      'MA',
      'MT',
      'MS',
      'MG',
      'PA',
      'PB',
      'PR',
      'PE',
      'PI',
      'RJ',
      'RN',
      'RS',
      'RO',
      'RR',
      'SC',
      'SP',
      'SE',
      'TO'
    ];

    if (!estadosBrasileiros.contains(valor.toUpperCase())) {
      return 'Insira um estado válido';
    }

    return null;
  }
}
