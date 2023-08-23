import 'package:flutter/material.dart';

// Widget de botão personalizado
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget child;

  const CustomButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text), // Usando o texto aqui
    );
  }
}
