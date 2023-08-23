import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/controllers/registration_controller.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({Key? key}) : super(key: key);

  final RegistrationController controller = RegistrationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Criar uma nova conta',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              const SizedBox(height: 16.0),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
              ),
              const SizedBox(height: 16.0),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'CPF',
                ),
              ),
              const SizedBox(height: 16.0),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Data de nascimento',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                controller: controller.passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Confirmar senha ',
                ),
                controller: controller.confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                onPressed: () {
                  // Código para executar a ação de registro
                  controller.register(context);
                },
                text: 'Registrar',
                child:
                    const Text('Registrar'), // Texto que será mostrado no botão
              ),
            ],
          ),
        ),
      ),
    );
  }
}
