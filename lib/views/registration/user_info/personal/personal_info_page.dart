// views/registration/personal_info_page.dart

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/services/via_cep_service.dart';
import 'package:flutter_seringueiro/validators/form_validators.dart';
import 'package:flutter_seringueiro/views/registration/user_info/adress/adress_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/adress/adress_info_page.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_event.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PersonalInfoPage extends StatefulWidget {
  final User user;

  PersonalInfoPage({Key? key, required this.user}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final nomeController = TextEditingController();
  final idPersonalizadoController = TextEditingController();
  final nascimentoController = MaskedTextController(mask: '00/00/0000');
  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final rgController = TextEditingController();

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  User? currentUser;

  final _formKey = GlobalKey<FormState>();

  //Focus
  final nomeFocus = FocusNode();
  final idPersonalizadoFocus = FocusNode();
  final nascimentoFocus = FocusNode();
  final cpfFocus = FocusNode();
  final rgFocus = FocusNode();

  @override
  void dispose() {
    // É importante sempre descartar os controladores e os focus nodes
    nomeController.dispose();
    idPersonalizadoController.dispose();
    nascimentoController.dispose();
    cpfController.dispose();
    rgController.dispose();
    nomeFocus.dispose();
    nascimentoFocus.dispose();
    cpfFocus.dispose();
    rgFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title: Text('Dados Pessoais', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: BlocListener<PersonalBloc, PersonalState>(
        listener: (context, state) {
          if (state is PersonalLoading) {
            // Mostrar um diálogo de carregamento ou um widget de carregamento
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(child: CircularProgressIndicator()),
            );
          } else if (state is PersonalInfoSuccess) {
            // Lógica para navegar para a próxima página
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) =>
                      AdressBloc(viaCepService: ViaCepService()),
                  child: AdressInfoPage(user: widget.user),
                ),
              ),
            );
          } else if (state is PersonalFailure) {
            // Fechar o diálogo de carregamento se aberto
            Navigator.pop(context);
            // Mostrar um erro
            // ...
          } else if (state is PersonalInitial) {
            // Opcional: Fechar diálogos abertos ou resetar a UI
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildProfileImage(),
                  TextFormField(
                    controller: nomeController,
                    focusNode: nomeFocus,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Nome completo',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    validator: FormValidators.validarNome,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(nascimentoFocus);
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: idPersonalizadoController,
                    decoration: InputDecoration(
                      labelText: 'ID Personalizado',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    validator: FormValidators.validarIdPersonalizado,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: nascimentoController,
                    focusNode: nascimentoFocus,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Data de nascimento',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    validator: FormValidators.validarNascimento,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(cpfFocus);
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: cpfController,
                    focusNode: cpfFocus,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CPF',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    validator: FormValidators.validarCPF,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(rgFocus);
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: rgController,
                    focusNode: rgFocus,
                    decoration: InputDecoration(
                      labelText: 'RG',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    validator: FormValidators.validarRG,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (value) => _onSubmitForm(),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _onSubmitForm,
                    child: Text('Continuar'),
                  ),
                ],
              ),
            ),
          ),
        ),
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
        source: ImageSource.gallery, // ou ImageSource.camera
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      // Tratar erro
    }
  }

  void _onSubmitForm() {
    // Verifica se todos os campos do formulário são válidos.
    bool isFormValid = _formKey.currentState?.validate() ?? false;
    if (isFormValid) {
      try {
        DateTime dataDeNascimento =
            DateFormat("dd/MM/yyyy").parseStrict(nascimentoController.text);

        // Envie o evento para o BLoC aqui
        BlocProvider.of<PersonalBloc>(context).add(
          PersonalInfoSubmitted(
            user: widget.user,
            nome: nomeController.text,
            idPersonalizado: idPersonalizadoController.text,
            dataDeNascimento: dataDeNascimento,
            cpf: cpfController.text,
            rg: rgController.text,
            imageFile: _imageFile,
          ),
        );
      } on FormatException {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data de nascimento inválida')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Por favor, corrija os erros no formulário antes de continuar.')),
      );
    }
  }
}
