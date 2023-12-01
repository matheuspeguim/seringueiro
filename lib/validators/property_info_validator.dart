class PropertyInfoValidator {
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
}
