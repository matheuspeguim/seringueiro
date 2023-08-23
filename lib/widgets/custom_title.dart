import 'package:flutter/material.dart';
import 'custom_colors.dart'; // Certifique-se de importar o arquivo correto para as cores personalizadas

// Widget de Título Personalizado
class CustomTitle extends StatelessWidget {
  final String text;

  const CustomTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: CustomColors.primaryGreen, // Aplicando a cor verde
      ),
    );
  }
}
