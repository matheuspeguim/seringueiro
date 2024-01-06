import 'package:intl/intl.dart';

class PersonalInfoValidator {
  static String? validarNome(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu nome';
    }
    if (valor.length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }
    final nomeRegExp = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚãõÃÕçÇ\s]+$');
    if (!nomeRegExp.hasMatch(valor)) {
      return 'O nome inserido é inválido';
    }
    // Adicionando a verificação para pelo menos duas palavras
    if (valor.trim().split(RegExp(r'\s+')).length < 2) {
      return 'Por favor, insidera nome e sobrenome';
    }
    return null;
  }

  static String? validarIdPersonalizado(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um ID personalizado';
    }
    if (value.length < 5 || value.length > 15) {
      return 'O ID personalizado deve ter entre 5 e 15 caracteres';
    }
    // Regex para verificar se o ID contém apenas letras e números
    RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!regex.hasMatch(value)) {
      return 'O ID personalizado deve conter apenas letras e números, sem espaços ou caracteres especiais';
    }
    return null;
  }

  static String? validarNascimento(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O campo de data de nascimento é obrigatório';
    }

    DateFormat format = DateFormat("dd/MM/yyyy");
    DateTime? parsedDate;
    try {
      parsedDate = format.parseStrict(valor);
    } catch (e) {
      return 'Data de nascimento inválida';
    }

    if (parsedDate.isAfter(DateTime.now())) {
      return 'Data de nascimento inválida';
    }

    // Se a pessoa for menor de 18 anos
    DateTime eighteenYearsAgo =
        DateTime.now().subtract(Duration(days: 18 * 365));
    if (parsedDate.isAfter(eighteenYearsAgo)) {
      return 'Você deve ter pelo menos 18 anos';
    }

    DateTime oneHundredNinetyYearsAgo =
        DateTime.now().subtract(Duration(days: 190 * 365));

    if (parsedDate.isBefore(oneHundredNinetyYearsAgo)) {
      return 'Data de nascimento inválida';
    }

    return null;
  }

  static String? validarCPF(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu CPF';
    }

    // Remove pontos e traços
    String cpf = valor.replaceAll(RegExp(r'\D'), '');

    // Verifica se o CPF tem 11 dígitos
    if (cpf.length != 11) {
      return 'O CPF deve ter 11 dígitos';
    }

    // Verifica se o CPF possui todos os números iguais, que são considerados inválidos
    if (RegExp(r'^(.)\1*$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    // Calcula o primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int mod = sum % 11;
    int firstDigit = (mod < 2) ? 0 : 11 - mod;

    // Calcula o segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    sum += firstDigit * 2;
    mod = sum % 11;
    int secondDigit = (mod < 2) ? 0 : 11 - mod;

    // Verifica se os dígitos verificadores estão corretos
    if (firstDigit == int.parse(cpf[9]) && secondDigit == int.parse(cpf[10])) {
      return null; // CPF válido
    } else {
      return 'CPF inválido'; // CPF inválido
    }
  }

  static String? validarRG(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu RG';
    }

    // Remove pontos e traços
    String rg = valor.replaceAll(RegExp(r'\D'), '');

    if (rg.length < 8 || rg.length > 10) {
      return 'O RG deve ter entre 8 e 10 dígitos';
    }

    // Verifica se o RG possui todos os números iguais, que são considerados inválidos
    if (RegExp(r'^(.)\1*$').hasMatch(rg)) {
      return 'RG inválido';
    }

    return null; // RG válido
  }
}
