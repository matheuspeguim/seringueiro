class ContactInfoValidator {
  static String? validarCelular(String? value) {
    if (value == null || value.isEmpty) {
      return 'O número do celular é obrigatório';
    }

    // Expressão regular para validar números de celular brasileiros com DDD
    // e 9 dígitos, permitindo parênteses, espaços e hífen
    var regex = RegExp(r'^\(\d{2}\)\s?\d{4,5}-?\d{4}$');

    if (!regex.hasMatch(value)) {
      return 'Insira um número de celular válido';
    }

    // Se passar na validação, retornamos null, que significa que não há erro
    return null;
  }
}
