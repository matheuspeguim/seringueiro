import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/common/widgets/custom_profile_image_picker.dart';
import 'package:flutter_seringueiro/views/registration/email_verification/email_verification_bloc.dart';
import 'package:flutter_seringueiro/views/registration/email_verification/email_verification_page.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_bloc.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_event.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_state.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_widgets/acess_credentials_form.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_widgets/personal_details_form.dart';
import 'package:image_picker/image_picker.dart';

import 'signup_widgets/adress_form.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> _personalDetailsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _accessCredentialsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();

  Map<int, bool> _stepIsValid =
      {}; // Mapa para controlar a validade de cada etapa

  late XFile? _imageFile;
  // Controladores
  late TextEditingController _emailController;
  late TextEditingController _senhaController;
  late TextEditingController _confirmarSenhaController;
  late MaskedTextController
      _celularController; // Usando MaskedTextController para formato específico
  late TextEditingController _idPersonalizadoController;
  late TextEditingController _nomeController;
  late MaskedTextController
      _nascimentoController; // Usando MaskedTextController para formato específico
  late MaskedTextController
      _cpfController; // Usando MaskedTextController para formato específico
  late TextEditingController _rgController;
  late MaskedTextController
      _cepController; // Usando MaskedTextController para formato específico
  late TextEditingController _logradouroController;
  late TextEditingController _numeroController;
  late TextEditingController _bairroController;
  late TextEditingController _cidadeController;
  late TextEditingController _estadoController;

  // FocusNodes
  late FocusNode _emailFocus;
  late FocusNode _senhaFocus;
  late FocusNode _confirmarSenhaFocus;
  late FocusNode _celularFocus;
  late FocusNode _idPersonalizadoFocus;
  late FocusNode _nomeFocus;
  late FocusNode _nascimentoFocus;
  late FocusNode _cpfFocus;
  late FocusNode _rgFocus;
  late FocusNode _cepFocus;
  late FocusNode _logradouroFocus;
  late FocusNode _numeroFocus;
  late FocusNode _bairroFocus;
  late FocusNode _cidadeFocus;
  late FocusNode _estadoFocus;

  @override
  void initState() {
    super.initState();

    _stepIsValid = {
      0: true, // Inicial
      1: false, // Perfil
      2: false, // Detalhes pessoais
      3: false, // Credenciais de acesso
      4: false, // Endereço
    };
    // Inicialização dos Controladores
    _emailController = TextEditingController();
    _senhaController = TextEditingController();
    _confirmarSenhaController = TextEditingController();
    _celularController = MaskedTextController(mask: '(00) 00000-0000');
    _idPersonalizadoController = TextEditingController();
    _nomeController = TextEditingController();
    _nascimentoController = MaskedTextController(mask: '00/00/0000');
    _cpfController = MaskedTextController(mask: '000.000.000-00');
    _rgController = TextEditingController();
    _cepController = MaskedTextController(mask: '00000-000');
    _logradouroController = TextEditingController();
    _numeroController = TextEditingController();
    _bairroController = TextEditingController();
    _cidadeController = TextEditingController();
    _estadoController = TextEditingController();

    // Inicialização dos FocusNodes
    _emailFocus = FocusNode();
    _senhaFocus = FocusNode();
    _confirmarSenhaFocus = FocusNode();
    _celularFocus = FocusNode();
    _idPersonalizadoFocus = FocusNode();
    _nomeFocus = FocusNode();
    _nascimentoFocus = FocusNode();
    _cpfFocus = FocusNode();
    _rgFocus = FocusNode();
    _cepFocus = FocusNode();
    _logradouroFocus = FocusNode();
    _numeroFocus = FocusNode();
    _bairroFocus = FocusNode();
    _cidadeFocus = FocusNode();
    _estadoFocus = FocusNode();
  }

  @override
  void dispose() {
    // Descarte dos Controladores
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

    // Descarte dos FocusNodes
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

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar conta'),
      ),
      body: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error), backgroundColor: Colors.red));
          } else if (state is SignUpSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => BlocProvider<EmailVerificationBloc>(
                        create: (context) => EmailVerificationBloc(),
                        child: EmailVerificationPage())),
                (Route<dynamic> route) => false);
          }
        },
        builder: (context, state) {
          if (state is SignUpLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return _buildStepper();
          }
        },
      ),
    );
  }

  Widget _buildStepper() {
    return Stepper(
      currentStep: _currentStep,
      onStepContinue: _next,
      onStepCancel: _cancel,
      steps: _getSteps(),
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (_currentStep >= 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('VOLTAR'),
                ),
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(_currentStep == _getSteps().length - 1
                    ? 'FINALIZAR'
                    : 'CONTINUAR'),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: const Text('Detalhes pessoais'),
        content: Form(
            key: _personalDetailsFormKey,
            child: PersonalDetailsForm(
                idPersonalizadoController: _idPersonalizadoController,
                nomeController: _nomeController,
                nascimentoController: _nascimentoController,
                cpfController: _cpfController,
                rgController: _rgController,
                celularController: _celularController,
                idPersonalizadoFocus: _idPersonalizadoFocus,
                nomeFocus: _nomeFocus,
                nascimentoFocus: _nascimentoFocus,
                cpfFocus: _cpfFocus,
                rgFocus: _rgFocus,
                celularFocus: _celularFocus)),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Credenciais de acesso'),
        content: Form(
            key: _accessCredentialsFormKey,
            child: AccessCredentialsForm(
                emailController: _emailController,
                senhaController: _senhaController,
                confirmarSenhaController: _confirmarSenhaController,
                emailFocus: _emailFocus,
                senhaFocus: _senhaFocus,
                confirmarSenhaFocus: _confirmarSenhaFocus,
                celularFocus: _celularFocus)),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Perfil'),
        content: CustomProfileImagePicker(
          onImagePicked: (XFile? image) {
            setState(() {
              _imageFile = image;
            });
            // Opcionalmente, faça algo com a imagem selecionada, como pré-visualização
          },
        ), // Assumindo que este widget gerencia sua própria imagem
        isActive: _currentStep >= 3,
      ),
      Step(
        title: const Text('Endereço'),
        content: Form(
            key: _addressFormKey,
            child: AddressForm(
                cepController: _cepController,
                logradouroController: _logradouroController,
                numeroController: _numeroController,
                bairroController: _bairroController,
                cidadeController: _cidadeController,
                estadoController: _estadoController,
                cepFocus: _cepFocus,
                logradouroFocus: _logradouroFocus,
                numeroFocus: _numeroFocus,
                bairroFocus: _bairroFocus,
                cidadeFocus: _cidadeFocus,
                estadoFocus: _estadoFocus)),
        isActive: _currentStep >= 4,
      ),
    ];
  }

  void _next() {
    bool isValid = true; // Inicialmente assuma que a etapa é válida.

    // Realiza a validação condicional baseada na etapa atual do Stepper.
    switch (_currentStep) {
      case 0:
        isValid = _personalDetailsFormKey.currentState?.validate() ?? false;
        break;
      case 1:
        isValid = _accessCredentialsFormKey.currentState?.validate() ?? false;
        break;
      case 2:
        isValid = true;
        break;
      case 3:
        isValid = _addressFormKey.currentState?.validate() ?? false;
        break;
      default:
        break;
    }

    // Se a etapa atual não for válida, interrompe a função aqui.
    if (!isValid) return;

    // Avança para a próxima etapa ou submete o formulário se estiver na última etapa.
    if (_currentStep < _getSteps().length - 1) {
      setState(() {
        _currentStep += 1; // Avança para a próxima etapa.
      });
    } else {
      _submitForm(); // Chamada para a função de submissão do formulário na última etapa.
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  void _submitForm() {
    // Coletando os valores dos controladores de texto.
    String email = _emailController.text.trim();
    String senha = _senhaController.text.trim();
    String celular = _celularController.text.trim();
    String idPersonalizado = _idPersonalizadoController.text.trim();
    String nome = _nomeController.text.trim();
    String nascimento = _nascimentoController.text.trim();
    String cpf = _cpfController.text.trim();
    String rg = _rgController.text.trim();
    String cep = _cepController.text.trim();
    String logradouro = _logradouroController.text.trim();
    String numero = _numeroController.text.trim();
    String bairro = _bairroController.text.trim();
    String cidade = _cidadeController.text.trim();
    String estado = _estadoController.text.trim();
    XFile? imageFile = _imageFile; // Diretamente usando XFile? para o evento.

    // Disparando o evento de submissão com todos os dados coletados, incluindo o arquivo de imagem.
    BlocProvider.of<SignUpBloc>(context).add(
      SignUpSubmitted(
        email: email,
        senha: senha,
        celular: celular,
        idPersonalizado: idPersonalizado,
        nome: nome,
        nascimento: nascimento,
        cpf: cpf,
        rg: rg,
        cep: cep,
        logradouro: logradouro,
        numero: numero,
        bairro: bairro,
        cidade: cidade,
        estado: estado,
        imageFile: imageFile, // Passando XFile? diretamente.
      ),
    );
  }
}
