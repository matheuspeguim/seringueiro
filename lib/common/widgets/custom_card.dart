import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final VoidCallback onButtonPressed;
  final String buttonText;
  final ColorScheme? colorScheme;
  final double? elevation;

  CustomCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.body,
    required this.onButtonPressed,
    this.buttonText = "Mais informações",
    this.colorScheme,
    this.elevation = 1.0, // Ajuste o padrão de elevação se necessário
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usa o esquema de cores do tema do app se nenhum for fornecido
    ColorScheme colors = colorScheme ?? Theme.of(context).colorScheme;

    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: colors
          .surface, // Utiliza surface em vez de primary para o fundo do card
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: colors
                  .surface, // A cor do cabeçalho pode permanecer como primary
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (subtitle != null) // Verifica se o subtítulo foi fornecido
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                subtitle!, // Exibe o subtítulo
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      colors.onSurface, // Usar onSurface para melhor contraste
                  fontSize: 14.0,
                ),
              ),
            ),

          // Corpo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: body,
          ),

          // Rodapé com botão
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: colors.surface, // Utiliza secondary para o rodapé
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(15.0)),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: colors
                    .onSurface, // Ajusta para onSecondary para o texto do botão
              ),
              onPressed: onButtonPressed,
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors
                      .onSurface, // Garante que o texto do botão use onSecondary para contraste
                  fontSize: 16.0, // Ajustado para melhor legibilidade
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
