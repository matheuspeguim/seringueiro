import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/views/registration/email_verification/email_verification_bloc.dart';
import 'package:flutter_seringueiro/views/registration/email_verification/email_verification_page.dart';
import 'package:flutter_seringueiro/views/user/account_management/account_management_bloc.dart';
import 'package:flutter_seringueiro/views/user/account_management/account_management_state.dart';
import 'package:image_picker/image_picker.dart';

class AccountManagementPage extends StatefulWidget {
  AccountManagementPage({Key? key}) : super(key: key);

  @override
  _AccountManagementPageState createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title: Text('Editar dados de usuário',
            style: TextStyle(color: Colors.white, fontSize: 33.0)),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: BlocConsumer<AccountManagementBloc, AccountManagementState>(
        listener: (context, state) {
          if (state is AccountManagementFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          } else if (state is AccountManagementSuccess) {
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
          if (state is AccountManagementLoading) {
            // Exibindo um indicador de carregamento
            return Center(child: CircularProgressIndicator());
          } else {
            // Para outros estados, retorna o formulário de cadastro
            return _buildAccountManagementViews(context);
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

  Widget _buildAccountManagementViews(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Campos do formulário aqui
          _buildProfileImage(),
          SizedBox(height: 32.0),
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  title: Text("Dados Pessoais",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _openEditPersonalDataModal(context),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nome: Fulano de Tal"),
                      Text("ID Personalizado: fulano123"),
                      // Incluir outros dados pessoais conforme necessário
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.0),
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  title: Text("Dados de contato",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Abre um modal ou uma nova tela para edição dos dados pessoais
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Celular: "),
                      Text("E-mail: "),
                      // Incluir outros dados pessoais conforme necessário
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.0),
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  title: Text("Dados de endereço",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Abre um modal ou uma nova tela para edição dos dados pessoais
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("CEP: "),
                      Text("Logradouro: "),
                      // Incluir outros dados pessoais conforme necessário
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.0),
          ElevatedButton(
            child: Text('Alterar senha'),
            onPressed: () => {},
          ),
          SizedBox(height: 32.0),
          TextButton(
            child: Text('Desativar minha conta'),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }

  void _openEditPersonalDataModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height /
              2, // Ajuste conforme necessário
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Nome'),
                enabled: false,
                // Inicialize o TextField com o valor atual, se disponível
              ),
              TextField(
                decoration: InputDecoration(labelText: 'ID Personalizado'),
                // Inicialize o TextField com o valor atual, se disponível
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Data de nascimento'),
                enabled: false,
                // Inicialize o TextField com o valor atual, se disponível
              ),
              TextField(
                decoration: InputDecoration(labelText: 'CPF'),
                enabled: false,
                // Inicialize o TextField com o valor atual, se disponível
              ),
              TextField(
                decoration: InputDecoration(labelText: 'RG'),
                enabled: false,
                // Inicialize o TextField com o valor atual, se disponível
              ),
              // Adicione mais campos conforme necessário
              ElevatedButton(
                onPressed: () {
                  // Aqui você pode adicionar a lógica para salvar/atualizar os dados
                },
                child: Text('Salvar'),
              ),
              TextButton(
                onPressed: () {
                  // Aqui você pode adicionar a lógica para salvar/atualizar os dados
                },
                child: Text('Solicitar correção de documentos pessoais'),
              ),
            ],
          ),
        );
      },
    );
  }
}
