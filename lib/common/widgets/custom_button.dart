import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double? elevation;
  final TextStyle? textStyle;
  final EdgeInsets? padding;

  const CustomButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.elevation,
    this.textStyle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Acessa as cores do tema
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          // Define a cor do ícone baseada na cor do texto se especificada, senão usa a cor sobre a cor primária do tema
          color: textStyle?.color ?? colorScheme.onPrimary,
        ),
        label: Text(
          label,
          style: textStyle ??
              textTheme.labelLarge?.copyWith(
                  color: colorScheme
                      .onPrimary), // Usa textTheme.button com a cor sobre a primária
        ),
        style: ElevatedButton.styleFrom(
          // Define a cor de fundo para a especificada ou a cor primária do tema
          backgroundColor: backgroundColor ?? colorScheme.primary,
          elevation: elevation ?? 50,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
