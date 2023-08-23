import 'package:flutter/material.dart';

// Widget de Campo de Texto Personalizado
class CustomTextField extends StatelessWidget {
  final String hintText;

  const CustomTextField({Key? key, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
