import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';
import '../services/via_cep_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  //final User user;

  // Definindo um construtor que requer um User como parâmetro
  RegistrationPage({
    Key? key,
    /*required this.user*/
  }) : super(key: key);
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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

  //Focus
  final nomeFocus = FocusNode();
  final nascimentoFocus = FocusNode();
  final cpfFocus = FocusNode();
  final rgFocus = FocusNode();
  final profissaoFocus = FocusNode();
  final emailFocus = FocusNode();
  final celularFocus = FocusNode();
  final cepFocus = FocusNode();
  final estadoFocus = FocusNode();
  final cidadeFocus = FocusNode();
  final ruaFocus = FocusNode();
  final numeroFocus = FocusNode();
  final bairroFocus = FocusNode();
  final senhaFocus = FocusNode();
  final confirmarSenhaFocus = FocusNode();
  final cadastrarFocus = FocusNode();

  //Booleans
  bool isNameTouched = false;
  bool isFormValid = true;
  bool isSemNumero = false;

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
    bairroController.dispose();
    nomeFocus.dispose();
    nascimentoFocus.dispose();
    cpfFocus.dispose();
    rgFocus.dispose();
    profissaoFocus.dispose();
    emailFocus.dispose();
    celularFocus.dispose();
    cepFocus.dispose();
    estadoFocus.dispose();
    cidadeFocus.dispose();
    ruaFocus.dispose();
    numeroFocus.dispose();
    bairroFocus.dispose();
    senhaFocus.dispose();
    confirmarSenhaFocus.dispose();
    cadastrarFocus.dispose();
    super.dispose();
  }

  //VALIDATOR DE NOME
  String? validarNome(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu nome';
    }
    if (valor.length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }
    final nomeRegExp = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚãõÃÕçÇ\s]+$');
    if (!nomeRegExp.hasMatch(valor)) {
      return 'O nome inserido é inválido';
    } else {
      return null;
    }
  }

//VALIDATOR DE DATA DE NASCIMENTO

  String? validarNascimento(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O campo de data de nascimento é obrigatório';
    }

    DateFormat format = DateFormat("dd/MM/yyyy");
    DateTime? parsedDate;
    try {
      parsedDate = format.parseStrict(valor);
    } catch (e) {
      return 'Data de nascimento inválida';
    }

    if (parsedDate.isAfter(DateTime.now())) {
      return 'Data de nascimento inválida';
    }

    // Se a pessoa for menor de 18 anos, por exemplo
    DateTime eighteenYearsAgo =
        DateTime.now().subtract(Duration(days: 18 * 365));
    if (parsedDate.isAfter(eighteenYearsAgo)) {
      return 'Você deve ter pelo menos 18 anos';
    }

    return null;
  }

//VALIDATOR DE CPF
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

  //VALIDATOR DE RG
  String? validarRG(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu RG';
    }

    // Remove pontos e traços
    String rg = valor.replaceAll(RegExp(r'\D'), '');

    if (rg.length < 8 || rg.length > 10) {
      return 'O RG deve ter entre 8 e 10 dígitos';
    }

    // Verifica se o RG possui todos os números iguais, que são considerados inválidos
    if (RegExp(r'^(.)\1*$').hasMatch(rg)) {
      return 'RG inválido';
    }

    return null; // RG válido
  }

  //VALIDATOR DE CELULAR
  String? validarCelular(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu número de celular';
    }

    // Remove espaços, traços e parênteses
    String celular = valor.replaceAll(RegExp(r'[^\d]'), '');

    if (celular.length != 11) {
      return 'O celular deve ter 11 dígitos';
    }

    if (!celular.startsWith('9', 2)) {
      return 'O número deve começar com 9 após o DDD';
    }

    return null; // Número de celular válido
  }

  //VALIDATOR DE EMAIL
  String? validarEmail(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu e-mail';
    }

    // Expressão regular para validar o e-mail
    RegExp regex = RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (!regex.hasMatch(valor)) {
      return 'Por favor, insira um e-mail válido';
    }

    return null; // E-mail válido
  }

  //VALIDATOR DE CEP
  String? validarCEP(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O CEP é obrigatório';
    }

    // Regex para validar o CEP
    final RegExp cepRegex = RegExp(r'^\d{5}-\d{3}$');

    if (!cepRegex.hasMatch(valor)) {
      return 'Digite um CEP válido';
    }

    return null;
  }

  //VALIDATOR DE RUA OU SÍTIO
  String? validarRuaOuSitio(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O nome da rua ou sítio é obrigatório';
    }

    // Regex para validar que o nome contém apenas letras, números, espaços e alguns caracteres especiais
    final RegExp nomeRuaOuSitioRegex =
        RegExp(r'^[a-zA-Z0-9\sáéíóúÁÉÍÓÚãõÃÕçÇâêôÂÊÔ\-]+$');

    if (!nomeRuaOuSitioRegex.hasMatch(valor)) {
      return 'Digite um nome válido, contendo apenas letras, números, espaços e caracteres especiais permitidos';
    }

    return null;
  }

  //VALIDATOR DE NÚMERO
  String? validarNumeroEndereco(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O número do endereço é obrigatório';
    }

    // Regex para validar que o número do endereço contém apenas números e/ou "s/n"
    final RegExp numeroEnderecoRegex = RegExp(r'^\d+|SN$');

    if (!numeroEnderecoRegex.hasMatch(valor)) {
      return 'Digite um número de endereço válido ou marque a opção sem número';
    }

    return null;
  }

  //VALIDATOR DE BAIRRO
  // VALIDATOR DE BAIRRO
  String? validarBairro(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O campo bairro é obrigatório';
    }

    // Regex para validar que o nome contém apenas letras, números, espaços e alguns caracteres especiais
    final RegExp nomeBairroRegex =
        RegExp(r'^[a-zA-Z0-9\sáéíóúÁÉÍÓÚãõÃÕçÇâêôÂÊÔ\-]+$');

    if (!nomeBairroRegex.hasMatch(valor)) {
      return 'Digite um nome de bairro válido, contendo apenas letras, números, espaços e caracteres especiais permitidos';
    }

    return null; // Bairro válido
  }

  //VALIDATOR DE CIDADE
  String? validarCidade(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O campo cidade é obrigatório';
    }

    // Regex para validar que o nome da cidade contém apenas letras, espaços e alguns caracteres especiais
    final RegExp nomeCidadeRegex =
        RegExp(r'^[a-zA-Z\sáéíóúÁÉÍÓÚãõÃÕçÇâêôÂÊÔ\-]+$');

    if (!nomeCidadeRegex.hasMatch(valor)) {
      return 'Digite um nome de cidade válido, contendo apenas letras, espaços e caracteres especiais permitidos';
    }

    return null; // Cidade válida
  }

  //VALIDATOR DE ESTADO
  String? validarEstado(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'O campo estado é obrigatório';
    }

    // Lista de estados brasileiros
    const List<String> estadosBrasileiros = [
      'AC',
      'AL',
      'AP',
      'AM',
      'BA',
      'CE',
      'DF',
      'ES',
      'GO',
      'MA',
      'MT',
      'MS',
      'MG',
      'PA',
      'PB',
      'PR',
      'PE',
      'PI',
      'RJ',
      'RN',
      'RS',
      'RO',
      'RR',
      'SC',
      'SP',
      'SE',
      'TO'
    ];

    if (!estadosBrasileiros.contains(valor.toUpperCase())) {
      return 'Insira um estado válido';
    }

    return null;
  }

  void enviarParaFirebase() {
    final usuario = {
      'nome': nomeController.text,
      'data_nascimento': nascimentoController.text,
      'cpf': cpfController.text,
      'rg': rgController.text,
      'profissao': profissaoController.text,
      'email': emailController.text,
      'celular': celularController.text,
      'cep': cepController.text,
      'estado': estadoController.text,
      'cidade': cidadeController.text,
      'rua': ruaController.text,
      'numero': numeroController.text,
      'bairro': bairroController.text,
    };
    final collection = FirebaseFirestore.instance.collection('usuarios');
    // Enviando os dados para a coleção especificada
    collection.add(usuario).then((_) {
      // Feedback de sucesso para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      // Você pode querer limpar os campos ou realizar outras ações após o cadastro bem-sucedido.
    }).catchError((error) {
      // Feedback de erro para o usuário
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro ao cadastrar. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title: Text(
          'Crie o seu perfil',
          style: TextStyle(fontSize: 33.0, color: Colors.white),
        ),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),

              // Dados Pessoais
              TextFormField(
                controller: nomeController,
                validator: validarNome,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (valor) {
                  setState(() {
                    isFormValid = validarNome(valor) == null;
                  });
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    labelText: 'Nome completo',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 33.0),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nascimentoController,
                      validator: validarNascimento,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (valor) {
                        setState(() {
                          isFormValid = validarNascimento(valor) == null;
                        });
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: 'Data de nascimento',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 23.0)),
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: cpfController,
                validator: validarCPF,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (valor) {
                  setState(() {
                    isFormValid = validarCPF(valor) == null;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'CPF',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 33.0),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: rgController,
                validator: validarRG,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (valor) {
                  setState(() {
                    isFormValid = validarRG(valor) == null;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'RG',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 33.0),
              ),
              SizedBox(height: 16.0),
              // Dados de Contato
              TextFormField(
                controller: celularController,
                validator: validarCelular,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (valor) {
                  setState(() {
                    isFormValid = validarCelular(valor) == null;
                  });
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: 'Celular',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 33.0),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: emailController,
                validator: validarEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (valor) {
                  setState(() {
                    isFormValid = validarEmail(valor) == null;
                  });
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 33.0),
              ),
              SizedBox(height: 16.0),
              // Dados de Endereço
              TextFormField(
                controller: cepController,
                validator: validarCEP,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (valor) {
                  setState(() {
                    isFormValid = validarCEP(valor) == null;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'CEP da sua cidade',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 33.0),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: ruaController,
                validator: validarRuaOuSitio,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (valor) {
                  setState(() {
                    isFormValid = validarRuaOuSitio(valor) == null;
                  });
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    labelText: 'Nome da Rua ou Sítio',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 33.0),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: numeroController,
                      validator: validarNumeroEndereco,
                      enabled: !isSemNumero,
                      onChanged: (valor) {
                        setState(() {
                          isFormValid = validarNumeroEndereco(valor) == null;
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Número da residência',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 23.0,
                          )),
                      style: TextStyle(
                        color: isSemNumero ? Colors.grey : Colors.white,
                        fontSize: 33.0,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: isSemNumero,
                    onChanged: (bool? value) {
                      setState(() {
                        isSemNumero = value ?? false;
                        if (isSemNumero) {
                          numeroController.text = "SN";
                        } else {
                          numeroController.text = "";
                        }
                      });
                    },
                  ),
                  Text(
                    "Sem número",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: bairroController,
                validator: validarBairro,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (valor) {
                  setState(() {
                    isFormValid = validarBairro(valor) == null;
                  });
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    labelText: 'Bairro',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 33.0),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: cidadeController,
                validator: validarCidade,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (valor) {
                  setState(() {
                    isFormValid = validarCidade(valor) == null;
                  });
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    labelText: 'Cidade',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 33.0),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: estadoController,
                validator: validarEstado,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (valor) {
                  setState(() {
                    isFormValid = validarEstado(valor) == null;
                  });
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    labelText: 'Estado',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 33.0),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Revalidar todos os campos
                  bool isNomeValid = validarNome(nomeController.text) == null;
                  bool isNascimentoValid =
                      validarNascimento(nascimentoController.text) == null;
                  bool isCpfValid = validarCPF(cpfController.text) == null;
                  bool isRgValid = validarRG(rgController.text) == null;
                  // bool isProfissaoValid = validarProfissao(profissaoController.text) == null;
                  bool isEmailValid =
                      validarEmail(emailController.text) == null;
                  bool isCelularValid =
                      validarCelular(celularController.text) == null;
                  bool isCepValid = validarCEP(cepController.text) == null;
                  bool isEstadoValid =
                      validarEstado(estadoController.text) == null;
                  bool isCidadeValid =
                      validarCidade(cidadeController.text) == null;
                  bool isRuaValid =
                      validarRuaOuSitio(ruaController.text) == null;
                  bool isNumeroValid =
                      validarNumeroEndereco(numeroController.text) == null;

                  if (isNomeValid &&
                      isNascimentoValid &&
                      isCpfValid &&
                      isRgValid &&
                      isEmailValid &&
                      isCelularValid &&
                      isCepValid &&
                      isEstadoValid &&
                      isCidadeValid &&
                      isRuaValid &&
                      isNumeroValid) {
                    enviarParaFirebase();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Por favor, corrija os erros no formulário.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Cadastrar'),
                focusNode: cadastrarFocus,
              )
            ],
          ),
        ),
      ),
    );
  }
}
