import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/views/registration/signup_bloc.dart';
import 'package:flutter_seringueiro/views/registration/signup_event.dart';
import 'package:flutter_seringueiro/views/registration/signup_state.dart';
import 'package:flutter_seringueiro/views/registration/signup_user_views/celular_view.dart';
import 'package:flutter_seringueiro/views/registration/signup_user_views/confirmar_celular_view.dart';
import 'package:flutter_seringueiro/views/registration/signup_user_views/confirmar_email_view.dart';
import 'package:flutter_seringueiro/views/registration/signup_user_views/endereco_view.dart';
import 'package:flutter_seringueiro/views/registration/signup_user_views/nome_view.dart';
import 'package:flutter_seringueiro/views/registration/signup_user_views/pessoal_view.dart';
import 'package:flutter_seringueiro/views/registration/signup_user_views/signup_view.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKeySignUp = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyConfirmarEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyNome = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPessoal = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCelular = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyConfirmarCelular = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEndereco = GlobalKey<FormState>();
  bool _isNextButtonEnabled = false;
  final _pageController = PageController();
  int _currentPage = 0;
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _idPersonalizadoController = TextEditingController();
  final _nascimentoController = MaskedTextController(mask: '00/00/0000');
  final _cpfController = MaskedTextController(mask: '000.000.000-00');
  final _rgController = TextEditingController();
  final _celularController = MaskedTextController(mask: '(00)00000-0000');
  final _codigoConfirmarCelularController = TextEditingController();
  final _cepController = MaskedTextController(mask: '00000-000');
  final _ruaOuSitioController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();

  bool _validateCurrentForm() {
    switch (_currentPage) {
      case 0:
        return _formKeySignUp.currentState?.validate() ?? false;
      case 1:
        return _formKeyConfirmarEmail.currentState?.validate() ?? false;
      case 2:
        return _formKeyNome.currentState?.validate() ?? false;
      case 3:
        return _formKeyPessoal.currentState?.validate() ?? false;
      case 4:
        return _formKeyCelular.currentState?.validate() ?? false;
      case 5:
        return _formKeyConfirmarCelular.currentState?.validate() ?? false;
      case 6:
        return _formKeyEndereco.currentState?.validate() ?? false;
      // Adicione mais casos para outras páginas
      default:
        return false;
    }
  }

  void updateNextButtonState() {
    bool isFormValid = _validateCurrentForm();
    setState(() {
      _isNextButtonEnabled = isFormValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
          CircularProgressIndicator();
        }
        // Verificação de e-mail enviada
        if (state is SignUpEmailVerificationSent) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        // Usuário já existe
        else if (state is SignUpUserAlreadyExists) {
          _showUserExistsDialog(context);
        }
        // E-mail verificado
        else if (state is SignUpEmailVerified) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        // Informações pessoais salvas
        else if (state is SignUpPersonalInfoSaved) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        // Celular verificado
        else if (state is SignUpCelularVerified) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        // Informações de endereço atualizadas
        else if (state is SignUpSuccess) {
          // Navegar para a próxima tela ou finalizar o fluxo de cadastro
        }
        // Erro durante o processo de cadastro
        else if (state is SignUpFailure) {
          _showErrorDialog(context, state.error);
        }
        // Caso o tempo de verificação de e-mail expire
        else if (state is SignUpEmailVerificationTimeout) {
          // Mostrar botão para tentar novamente ou mensagem
        }
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.green.shade900),
        backgroundColor: Colors.green.shade900,
        body: _buildPageView(),
        bottomNavigationBar: _buildBottomAppBar(),
      ),
    );
  }

  void _showUserExistsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Usuário Existente'),
          content: Text('Já existe uma conta com o e-mail fornecido.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageView() {
    final state = context.watch<SignUpBloc>().state;
    bool isLoadin = state is SignUpLoading;
    return isLoadin
        ? Center(child: CircularProgressIndicator())
        : PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: <Widget>[
              SignUpView(
                formKey: _formKeySignUp,
                emailController: _emailController,
                senhaController: _senhaController,
                confirmarSenhaController: _confirmarSenhaController,
              ),
              ConfirmarEmailView(
                formKey: _formKeyConfirmarEmail,
              ),
              NomeView(
                formKey: _formKeyNome,
                nomeController: _nomeController,
              ),
              PessoalView(
                nomeController: _nomeController,
                cpfController: _cpfController,
                rgController: _rgController,
                nascimentoController: _nascimentoController,
                idPersonalizadoController: _idPersonalizadoController,
              ),
              CelularView(
                formKey: _formKeyCelular,
                celularController: _celularController,
              ),
              ConfirmarCelularView(
                  formKey: _formKeyConfirmarCelular,
                  codigoConfirmarCelularController:
                      _codigoConfirmarCelularController),
              EnderecoView(
                cepController: _cepController,
                ruaOuSitioController: _ruaOuSitioController,
                complementoController: _complementoController,
                bairroController: _bairroController,
                numeroController: _numeroController,
                cidadeController: _cidadeController,
                estadoController: _estadoController,
              ),

              // Adicione mais widgets de formulário conforme necessário
            ],
          );
  }

  Widget _buildBottomAppBar() {
    final state = context.watch<SignUpBloc>().state;
    bool isNextButtonEnabled =
        _isNextButtonEnabled && !(state is SignUpLoading);
    return BottomAppBar(
      color: Colors.green.shade900,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (_currentPage > 0)
            ElevatedButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Text('Anterior'),
            ),
          Spacer(),
          ElevatedButton(
            onPressed: _onNextPressed,
            child: Text('Próximo'),
          ),
        ],
      ),
    );
  }

  void _onNextPressed() {
    if (_validateCurrentForm()) {
      if (_currentPage == 0) {
        BlocProvider.of<SignUpBloc>(context).add(SignUpSubmitted(
          email: _emailController.text,
          senha: _senhaController.text,
        ));
      } else if (_currentPage < 7 - 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // Lógica final de submissão
        // Exemplo: Emitir evento para submissão de dados pessoais
      }
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }
}
