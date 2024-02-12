import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/validators/validators.dart';
import 'package:flutter_seringueiro/views/registration/email_verification/email_verification_bloc.dart';
import 'package:flutter_seringueiro/views/registration/email_verification/email_verification_page.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_bloc.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_event.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_state.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_info_page.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _celularController = MaskedTextController(mask: '(00)00000-0000');
  final _idPersonalizadoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _nascimentoController = MaskedTextController(mask: '00/00/0000');
  final _cpfController = MaskedTextController(mask: '000.000.000-00');
  final _rgController = TextEditingController();
  final _cepController = MaskedTextController(mask: '00000-0000');
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();

  //Focus
  final _emailFocus = FocusNode();
  final _senhaFocus = FocusNode();
  final _confirmarSenhaFocus = FocusNode();
  final _celularFocus = FocusNode();
  final _idPersonalizadoFocus = FocusNode();
  final _nomeFocus = FocusNode();
  final _nascimentoFocus = FocusNode();
  final _cpfFocus = FocusNode();
  final _rgFocus = FocusNode();
  final _cepFocus = FocusNode();
  final _logradouroFocus = FocusNode();
  final _numeroFocus = FocusNode();
  final _bairroFocus = FocusNode();
  final _cidadeFocus = FocusNode();
  final _estadoFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title: Text('Criar conta',
            style: TextStyle(color: Colors.white, fontSize: 33.0)),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          } else if (state is SignUpSuccess) {
            // Navega para a tela seguinte após o sucesso do cadastro
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => BlocProvider<EmailVerificationBloc>(
                  create: (context) => EmailVerificationBloc(),
                  child: EmailVerificationPage(),
                ),
              ),
              (Route<dynamic> route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is SignUpLoading) {
            // Exibindo um indicador de carregamento
            return Center(child: CircularProgressIndicator());
          } else {
            // Para outros estados, retorna o formulário de cadastro
            return _buildSignUpForm(context);
          }
        },
      ),
    );
  }

  Widget _buildProfileImage() {
    return InkWell(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 60, // Tamanho do avatar
        backgroundColor: Colors.grey.shade300,
        backgroundImage:
            _imageFile != null ? FileImage(File(_imageFile!.path)) : null,
        child: _imageFile == null
            ? Icon(Icons.person, size: 60) // Ícone padrão se não houver imagem
            : null,
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      // Tratar erro
    }
  }

  Widget _buildSignUpForm(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Campos do formulário aqui
          _buildProfileImage(),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _emailController,
            label: 'E-mail',
            validator: Validators.validarEmail,
            focusNode: _emailFocus,
            nextFocusNode: _senhaFocus,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
              context: context,
              controller: _senhaController,
              label: 'Senha',
              validator: Validators.validarSenha,
              focusNode: _senhaFocus,
              nextFocusNode: _confirmarSenhaFocus,
              keyboardType: TextInputType.text,
              obscureText: true),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _confirmarSenhaController,
            label: 'Confirmar senha',
            validator: (valor) => Validators.validarConfirmaSenha(
                valor ?? '', _senhaController.text),
            focusNode: _confirmarSenhaFocus,
            nextFocusNode: _celularFocus,
            keyboardType: TextInputType.text,
            obscureText: true,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _celularController,
            label: 'Número de celular',
            validator: Validators.validarCelular,
            focusNode: _celularFocus,
            nextFocusNode: _idPersonalizadoFocus,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _idPersonalizadoController,
            label: 'Nome de usuário (sem espaço)',
            validator: Validators.validarIdPersonalizado,
            focusNode: _idPersonalizadoFocus,
            nextFocusNode: _nomeFocus,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _nomeController,
            label: 'Nome completo',
            validator: Validators.validarNome,
            focusNode: _nomeFocus,
            nextFocusNode: _nascimentoFocus,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _nascimentoController,
            label: 'Data de nascimento',
            validator: Validators.validarNascimento,
            focusNode: _nascimentoFocus,
            nextFocusNode: _cpfFocus,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _cpfController,
            label: 'CPF',
            validator: Validators.validarCPF,
            focusNode: _cpfFocus,
            nextFocusNode: _rgFocus,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _rgController,
            label: 'RG',
            validator: Validators.validarRG,
            focusNode: _rgFocus,
            nextFocusNode: _cepFocus,
            keyboardType: TextInputType.text,
          ),
          Divider(),

          //Dados de endereço
          _buildTextField(
            context: context,
            controller: _cepController,
            label: 'CEP',
            validator: Validators.validarCEP,
            focusNode: _cepFocus,
            nextFocusNode: _logradouroFocus,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _logradouroController,
            label: 'Logradouro',
            validator: Validators.validarRuaOuSitio,
            focusNode: _logradouroFocus,
            nextFocusNode: _numeroFocus,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _numeroController,
            label: 'Número',
            validator: Validators.validarNumero,
            focusNode: _numeroFocus,
            nextFocusNode: _bairroFocus,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _bairroController,
            label: 'Bairro',
            validator: Validators.validarBairro,
            focusNode: _bairroFocus,
            nextFocusNode: _cidadeFocus,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _cidadeController,
            label: 'Cidade',
            validator: Validators.validarCidade,
            focusNode: _cidadeFocus,
            nextFocusNode: _estadoFocus,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 32.0),
          _buildTextField(
            context: context,
            controller: _estadoController,
            label: 'Estado',
            validator: Validators.validarEstado,
            focusNode: _estadoFocus,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 32.0),
          ElevatedButton(
            child: Text('Próximo'),
            onPressed: () => _submitForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required dynamic
        controller, // Alterado para aceitar qualquer tipo de controlador
    required String label,
    required String? Function(String?) validator,
    bool obscureText = false,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    TextInputType keyboardType =
        TextInputType.text, // Tornando o tipo de teclado configurável
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode, // Usando FocusNode
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType, // Usando o tipo de teclado configurável
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
      style: TextStyle(color: Colors.white, fontSize: 18.0),
      obscureText: obscureText,
      onFieldSubmitted: (value) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
    );
  }

  void _submitForm(BuildContext context) {
    if (_validateForm()) {
      BlocProvider.of<SignUpBloc>(context).add(
        SignUpSubmitted(
          email: _emailController.text,
          senha: _senhaController.text,
          celular: _celularController.text,
          idPersonalizado: _idPersonalizadoController.text,
          nome: _nomeController.text,
          nascimento: _nascimentoController.text,
          cpf: _cpfController.text,
          rg: _rgController.text,
          cep: _cepController.text,
          logradouro: _logradouroController.text,
          numero: _numeroController.text,
          bairro: _bairroController.text,
          cidade: _cidadeController.text,
          estado: _estadoController.text,
          imageFile: _imageFile,
        ),
      );
    } else {
      // Mostrar feedback ao usuário de que a validação falhou
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, corrija os erros no formulário.")),
      );
    }
  }

  bool _validateForm() {
    // Lista de validadores para cada campo. Cada validador retorna null se o campo for válido, ou uma mensagem de erro se não for.
    List<String? Function()> validadores = [
      () => Validators.validarEmail(_emailController.text),
      () => Validators.validarSenha(_senhaController.text),
      () => Validators.validarConfirmaSenha(
          _confirmarSenhaController.text, _senhaController.text),
      () => Validators.validarCelular(_celularController.text),
      () => Validators.validarIdPersonalizado(_idPersonalizadoController.text),
      () => Validators.validarNome(_nomeController.text),
      () => Validators.validarNascimento(_nascimentoController.text),
      () => Validators.validarCPF(_cpfController.text),
      () => Validators.validarRG(_rgController.text),
      () => Validators.validarCEP(_cepController.text),
      () => Validators.validarRuaOuSitio(_logradouroController.text),
      () => Validators.validarNumero(_numeroController.text),
      () => Validators.validarBairro(_bairroController.text),
      () => Validators.validarCidade(_cidadeController.text),
      () => Validators.validarEstado(_estadoController.text),
    ];

    // Executa cada validador. Se algum validador retornar uma mensagem de erro (não null), retorna false.
    for (var validar in validadores) {
      if (validar() != null) {
        return false;
      }
    }

    // Se todos os validadores passarem (todos retornarem null), retorna true.
    return true;
  }

  @override
  void dispose() {
    // Libera os controladores de texto
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _celularController.dispose();
    _idPersonalizadoController.dispose();
    _nomeController.dispose();
    _nascimentoController.dispose();
    _cpfController.dispose();
    _rgController.dispose();
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();

    // Libera os focos de texto
    _emailFocus.dispose();
    _senhaFocus.dispose();
    _confirmarSenhaFocus.dispose();
    _celularFocus.dispose();
    _idPersonalizadoFocus.dispose();
    _nomeFocus.dispose();
    _nascimentoFocus.dispose();
    _cpfFocus.dispose();
    _rgFocus.dispose();
    _cepFocus.dispose();
    _logradouroFocus.dispose();
    _numeroFocus.dispose();
    _bairroFocus.dispose();
    _cidadeFocus.dispose();
    _estadoFocus.dispose();

    super.dispose();
  }
}
