import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;

  const CustomButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor, // Não mais definindo um valor padrão aqui
    this.textStyle, // Não mais definindo um valor padrão aqui
    this.padding, // Não mais definindo um valor padrão aqui
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: textStyle?.color ?? Colors.white),
        label: Text(label,
            style: textStyle ??
                const TextStyle(fontSize: 16, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.green,
          elevation: 50,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
