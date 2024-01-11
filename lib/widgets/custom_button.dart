import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor; // Tornando opcional com um valor padrão nulo
  final TextStyle? textStyle; // Tornando opcional com um valor padrão nulo
  final EdgeInsets? padding; // Tornando opcional com um valor padrão nulo

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
    return Center(
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton.icon(
          icon: Icon(icon, color: textStyle?.color ?? Colors.white),
          label: Text(label,
              style: textStyle ??
                  const TextStyle(fontSize: 16, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ??
                Colors.green, // Usando valor padrão se nenhum for fornecido
            elevation: 50,
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
