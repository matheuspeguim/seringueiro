class ContactInfoValidator {
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
}
