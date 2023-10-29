import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../services/via_cep_service.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int currentStep = 0;

  String typedText = '';
  List<String> phrases = [
    'Organize sua rotina.',
    'Seja mais eficiente.',
    'Compartilhe seu progresso.',
    'Participe desta transformação.',
  ];
  int phraseIndex = 0;
  int characterCount = 0;
  bool isErasing = false;

  //Dados pessoais
  final nomeController = TextEditingController();
  final nascimentoController = MaskedTextController(mask: '00/00/0000');
  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final rgController = TextEditingController();
  final profissaoController = TextEditingController();

  //Dados de contato
  final emailController = TextEditingController();
  final celularController = MaskedTextController(mask: '(00) 00000-0000');

  //Dados de endereço
  final cepController = MaskedTextController(mask: '00000-000');
  final estadoController = TextEditingController();
  final cidadeController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();

  bool isNameTouched = false;
  bool isEmailTouched = false;
  bool isFormValid = true;

  final ViaCepService viaCepService = ViaCepService();

  @override
  void dispose() {
    nomeController.dispose();
    nascimentoController.dispose();
    cpfController.dispose();
    rgController.dispose();
    profissaoController.dispose();
    emailController.dispose();
    celularController.dispose();
    cepController.dispose();
    estadoController.dispose();
    cidadeController.dispose();
    ruaController.dispose();
    numeroController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    nomeController.addListener(() {
      setState(() {
        isNameTouched = true;
      });
    });

    Future.delayed(Duration(milliseconds: 50), () {
      typeText();
    });
  }

  void typeText() {
    Future.delayed(Duration(milliseconds: 10), () {
      if (!isErasing) {
        if (characterCount < phrases[phraseIndex].length) {
          setState(() {
            typedText = phrases[phraseIndex].substring(0, characterCount++);
          });
          typeText();
        } else {
          // Começa a apagar depois de exibir toda a frase
          Future.delayed(Duration(seconds: 2), () {
            isErasing = true;
            typeText();
          });
        }
      } else {
        // Lógica para apagar
        if (characterCount > 0) {
          setState(() {
            typedText = phrases[phraseIndex].substring(0, --characterCount);
          });
          typeText();
        } else {
          // Vai para a próxima frase depois de apagar
          isErasing = false;
          phraseIndex = (phraseIndex + 1) % phrases.length;
          typeText();
        }
      }
    });
  }

  //Validator de nome
  String? validarNome(String? valor) {
    if (!isNameTouched)
      return null; // Não validar se o nome ainda não foi tocado

    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu nome';
    }
    if (valor.length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }
    final nomeRegExp = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚãõÃÕçÇ\s]+$');
    if (!nomeRegExp.hasMatch(valor)) {
      return 'O nome inserido é inválido';
    }
    return null;
  }

//Validator de CPF
  String? validarCPF(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu CPF';
    }

    // Remove pontos e traços
    String cpf = valor.replaceAll(RegExp(r'\D'), '');

    // Verifica se o CPF tem 11 dígitos
    if (cpf.length != 11) {
      return 'O CPF deve ter 11 dígitos';
    }

    // Verifica se o CPF possui todos os números iguais, que são considerados inválidos
    if (RegExp(r'^(.)\1*$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    // Calcula o primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int mod = sum % 11;
    int firstDigit = (mod < 2) ? 0 : 11 - mod;

    // Calcula o segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    sum += firstDigit * 2;
    mod = sum % 11;
    int secondDigit = (mod < 2) ? 0 : 11 - mod;

    // Verifica se os dígitos verificadores estão corretos
    if (firstDigit == int.parse(cpf[9]) && secondDigit == int.parse(cpf[10])) {
      return null; // CPF válido
    } else {
      return 'CPF inválido'; // CPF inválido
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget;

    switch (currentStep) {
      case 0:
        currentWidget = SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha os widgets à esquerda
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Olá, produtor rural! Faça seu cadastro abaixo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 33.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: typedText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 33.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        break;

      case 1:
        currentWidget = SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha os widgets à esquerda
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Digite o seu CPF",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33.0,
                    ),
                  ),
                ),
              ),
              CustomTextField(
                controller: cpfController,
                hintText: "",
                textColor: Colors.white,
                hintTextColor: Colors.white38,
                fontSize: 33.0,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator: validarCPF,
                onChanged: (valor) {
                  setState(() {
                    isFormValid = validarCPF(valor) == null;
                  });
                },
              ),
            ],
          ),
        );
        break;
      case 2:
        currentWidget = SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha os widgets à esquerda
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Digite o seu RG",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33.0,
                    ),
                  ),
                ),
              ),
              CustomTextField(
                controller: rgController,
                hintText: "",
                textColor: Colors.white,
                hintTextColor: Colors.white38,
                fontSize: 33.0,
                keyboardType: TextInputType.name,
              ),
            ],
          ),
        );
        break;
      case 3:
        currentWidget = SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha os widgets à esquerda
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Digite o CEP da cidade que você mora",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33.0,
                    ),
                  ),
                ),
              ),
              CustomTextField(
                controller: cepController,
                hintText: "",
                textColor: Colors.white,
                hintTextColor: Colors.white38,
                fontSize: 33.0,
                keyboardType: TextInputType.name,
              ),
            ],
          ),
        );
        break;
      case 4:
        currentWidget = SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha os widgets à esquerda
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Digite abaixo o seu Endereço",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33.0,
                    ),
                  ),
                ),
              ),
              CustomTextField(
                controller: ruaController,
                hintText: "Nome da Rua ou Sítio",
                textColor: Colors.white,
                hintTextColor: Colors.white38,
                fontSize: 33.0,
                keyboardType: TextInputType.name,
              ),
              CustomTextField(
                controller: numeroController,
                hintText: "Número",
                textColor: Colors.white,
                hintTextColor: Colors.white38,
                fontSize: 33.0,
                keyboardType: TextInputType.name,
              ),
              CustomTextField(
                controller: bairroController,
                hintText: "Bairro",
                textColor: Colors.white,
                hintTextColor: Colors.white38,
                fontSize: 33.0,
                keyboardType: TextInputType.name,
              ),
              CustomTextField(
                controller: cidadeController,
                hintText: "Cidade",
                textColor: Colors.white,
                hintTextColor: Colors.white38,
                fontSize: 33.0,
                keyboardType: TextInputType.name,
              ),
              CustomTextField(
                controller: estadoController,
                hintText: "Estado",
                textColor: Colors.white,
                hintTextColor: Colors.white38,
                fontSize: 33.0,
                keyboardType: TextInputType.name,
              ),
            ],
          ),
        );
        break;
      case 5:
        currentWidget = CustomTextField(
          controller: celularController,
          hintText: "Número do seu celular",
          textColor: Colors.white,
          hintTextColor: Colors.white38,
          fontSize: 33.0,
          keyboardType: TextInputType.phone,
        );
        break;
      case 6:
        currentWidget = CustomTextField(
          controller: emailController,
          hintText: "Digite seu e-mail",
          textColor: Colors.white,
          hintTextColor: Colors.white38,
          fontSize: 33.0,
          keyboardType: TextInputType.emailAddress,
        );
        break;
      default:
        currentWidget = Text(
          'Passo não definido',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 26.0,
          ),
        );
    }

    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: CustomAppBar(
        title: 'Criar uma nova conta',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              switchInCurve: Curves.linear,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0),
                    end: Offset(0.0, 0.0),
                  ).animate(animation),
                  child: child,
                );
              },
              child: currentWidget,
              key: ValueKey<int>(currentStep),
            ),
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: currentStep > 0
                ? FloatingActionButton(
                    child: Icon(Icons.arrow_back),
                    onPressed: isFormValid
                        ? () {
                            setState(() {
                              currentStep--;
                              isFormValid = true;
                            });
                          }
                        : null,
                    backgroundColor: isFormValid ? Colors.red : Colors.grey,
                  )
                : null,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              autofocus: true,
              onPressed: isFormValid // Verifica se o formulário é válido
                  ? () {
                      if (currentStep < 6) {
                        setState(() {
                          currentStep++;
                          isFormValid = false;
                          isFormValid ? () {} : {null};
                        });
                      } else {
                        // Execute a ação de registro
                      }
                    }
                  : null, // Desativa o botão se o formulário não for válido
              backgroundColor: isFormValid ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
