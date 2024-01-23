import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final VoidCallback onButtonPressed;
  final String buttonText;
  final ColorScheme? colorScheme;

  CustomCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.body,
    required this.onButtonPressed,
    this.buttonText = "Mais informações",
    this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define o esquema de cores padrão se nenhum for fornecido
    ColorScheme colors =
        colorScheme ?? ColorScheme.fromSwatch(primarySwatch: Colors.green);

    return Card(
      elevation: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: colors.primary,
      margin: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onPrimary,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (subtitle != null) // Verifica se o subtítulo foi fornecido
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                subtitle!, // Exibe o subtítulo
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.onPrimary,
                  fontSize:
                      14.0, // Ajuste o tamanho da fonte conforme necessário
                ),
              ),
            ),

          // Corpo
          Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: body,
            ),
          ),

          // Rodapé com botão
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.0),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(15.0)),
            ),
            child: TextButton(
              style: TextButton.styleFrom(),
              onPressed: onButtonPressed,
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.onSecondaryContainer,
                  fontSize: 13.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
