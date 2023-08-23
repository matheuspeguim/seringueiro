import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/widgets/shared_widgets.dart';
import 'package:flutter_seringueiro/views/registration_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Entrar na conta',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CustomTextField(
                hintText: 'E-mail',
              ),
              const SizedBox(height: 16.0),
              PasswordField(), // Usando o novo widget PasswordField
              const SizedBox(height: 16.0),
              const CustomCheckBox(
                text: 'Lembrar-me',
              ),

              CustomButton(
                onPressed: () {
                  // Lógica de login aqui
                },
                text: 'Entrar',
                child: const Text('Entrar'),
              ),
              const SizedBox(height: 8.0), // Espaço entre os botões
              const Text('ou'), // Adicione a frase "ou"
              const SizedBox(height: 8.0), // Espaço entre os botões
              CustomButton(
                onPressed: () {
                  // Navegar para a página de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationPage(),
                    ),
                  );
                },
                text: 'Cadastrar',
                child: const Text("Criar conta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Senha',
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_isPasswordVisible,
    );
  }
}
