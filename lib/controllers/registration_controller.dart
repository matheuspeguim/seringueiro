import 'package:flutter/material.dart';

class RegistrationController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void register(BuildContext context) {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem!')),
      );
      return;
    }

    // Implemente o resto da lógica de registro aqui
  }

  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
