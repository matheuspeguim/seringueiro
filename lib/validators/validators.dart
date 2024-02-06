import 'package:intl/intl.dart';

class Validators {
  //VALIDATOR DE SENHA
  static String? validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe uma senha';
    }
    if (valor.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres';
    }
    if (!RegExp(r'[a-z]').hasMatch(valor)) {
      return 'A senha deve conter pelo menos uma letra minúscula';
    }
    if (!RegExp(r'[A-Z]').hasMatch(valor)) {
      return 'A senha deve conter pelo menos uma letra maiúscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(valor)) {
      return 'A senha deve conter pelo menos um número';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(valor)) {
      return 'A senha deve conter pelo menos um caractere especial';
    }
    return null;
  }

  //VALIDATOR DE CONFIRMAÇÃO DE SENHA
  static String? validarConfirmaSenha(String valor, String senha) {
    if (valor.isEmpty) {
      return 'Confirme sua senha';
    }
    if (valor != senha) {
      return 'As senhas não correspondem';
    }
    return null;
  }

  static String? validarNomeDaPropriedade(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O nome da propriedade é obrigatório';
    }
    return null;
  }

  static String? validarAreasEmHectares(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a quantidade de hectares';
    }

    final double? hectares = double.tryParse(value);
    if (hectares == null) {
      return 'Insira um número válido';
    }

    if (hectares <= 0) {
      return 'A quantidade de hectares deve ser positiva';
    }

    return null; // Retorna null se o valor passar em todas as verificações
  }

  static String? validarQuantidadeDeArvores(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a quantidade de árvores';
    }

    final double? hectares = double.tryParse(value);
    if (hectares == null) {
      return 'Insira a quantidade árvores em números';
    }

    if (hectares <= 0) {
      return 'A quantidade de árvores deve ser positiva';
    }

    return null; // Retorna null se o valor passar em todas as verificações
  }

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
    if (value.length < 5 || value.length > 50) {
      return 'O ID personalizado deve ter entre 5 e 50 caracteres';
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

  //VALIDATOR DE EMAIL
  static String? validarEmail(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu e-mail';
    }

    // Expressão regular para validar o e-mail
    RegExp regex = RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (!regex.hasMatch(valor)) {
      return 'Por favor, insira um e-mail válido';
    }

    return null; // E-mail válido
  }

  static String? validarCelular(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu número de celular';
    }

    // Remove caracteres não numéricos
    String celular = valor.replaceAll(RegExp(r'[^\d]'), '');

    // Verifica se tem 11 dígitos
    if (celular.length != 11) {
      return 'O celular deve ter 11 dígitos';
    }

    // Verifica se o número começa com 9 após o DDD
    if (!celular.startsWith('9', 2)) {
      return 'O número deve começar com 9 após o DDD';
    }

    // Verifica se o formato do número é válido
    var regex = RegExp(r'^\d{2}9\d{8}$');
    if (!regex.hasMatch(celular)) {
      return 'Insira um número de celular válido';
    }

    return null; // Número de celular válido
  }

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
