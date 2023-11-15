// views/registration/personal_info_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/blocs/registration/registration_bloc.dart';
import 'package:flutter_seringueiro/blocs/registration/registration_event.dart';
import 'package:flutter_seringueiro/validators/personal_info_validator.dart';
import 'package:flutter_seringueiro/views/user_data/adress_info_page.dart';
import 'package:intl/intl.dart';

class ProfessionalInfoPage extends StatefulWidget {
  final User user;

  ProfessionalInfoPage({Key? key, required this.user}) : super(key: key);
  @override
  _ProfessionalInfoPageState createState() => _ProfessionalInfoPageState();
}

class _ProfessionalInfoPageState extends State<ProfessionalInfoPage> {
  final List<String> professions = [
    'Seringueiro',
    'Agrônomo',
    'Proprietário Rural'
  ];
  Map<String, bool> selectedProfessions = {};

  @override
  void initState() {
    super.initState();
    for (var profession in professions) {
      selectedProfessions[profession] = false;
    }
  }

  final _formKey = GlobalKey<FormState>();

  //Focus
  final profissaoFocus = FocusNode();

  @override
  void dispose() {
    // É importante sempre descartar os controladores e os focus nodes
    profissaoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title:
            Text('Dados profissionais', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListView(
                  children: professions.map((profession) {
                    return CheckboxListTile(
                      title: Text(profession,
                          style: TextStyle(color: Colors.white)),
                      value: selectedProfessions[profession],
                      activeColor: Colors.white,
                      checkColor: Colors.green.shade900,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedProfessions[profession] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    // Verifica se todos os campos do formulário são válidos.
                  },
                  child: Text('Continuar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
