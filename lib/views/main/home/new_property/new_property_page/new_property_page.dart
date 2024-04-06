import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/common/widgets/explanation_card.dart';
import 'package:flutter_seringueiro/views/main/home/new_property/new_property_page/new_property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/new_property/new_property_page/new_property_event.dart';
import 'package:flutter_seringueiro/views/main/home/new_property/new_property_page/new_property_state.dart';
import 'package:flutter_seringueiro/views/main/home/new_property/new_property_widgets/property_data_form.dart';
import 'package:flutter_seringueiro/views/main/home/new_property/new_property_widgets/property_user_form.dart';
import 'package:flutter_seringueiro/views/main/home/new_property/new_property_widgets/selectable_location_widget.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewPropertyPage extends StatefulWidget {
  NewPropertyPage({Key? key}) : super(key: key);

  @override
  _NewPropertyPageState createState() => _NewPropertyPageState();
}

class _NewPropertyPageState extends State<NewPropertyPage> {
  LatLng _propertyLocation =
      LatLng(0.0, 0.0); // Uma localização padrão, ou você pode escolher outra

  void _updatePropertyLocation(LatLng newLocation) {
    setState(() {
      _propertyLocation = newLocation;
    });
  }

  // Controladores
  late TextEditingController nomeDaPropriedadeController;
  late MaskedTextController cepDaPropriedadeController;
  late TextEditingController cidadeDaPropriedadeController;
  late TextEditingController estadoDaPropriedadeController;
  late TextEditingController areaEmHectaresController;
  late TextEditingController quantidadeDeArvoresController;
  late TextEditingController clonePredominanteController;
  late bool isSeringueiro;
  late bool isAgronomo;
  late bool isProprietario;
  late bool isAdmin;

  // FocusNodes
  late FocusNode nomeDaPropriedadeFocus;
  late FocusNode cepDaPropriedadeFocus;
  late FocusNode cidadeDaPropriedadeFocus;
  late FocusNode estadoDaPropriedadeFocus;
  late FocusNode areaEmHectaresFocus;
  late FocusNode quantidadeDeArvoresFocus;
  late FocusNode clonePredominanteFocus;

  @override
  void initState() {
    super.initState();

    // Inicialização dos Controladores
    nomeDaPropriedadeController = TextEditingController();
    cepDaPropriedadeController = MaskedTextController(mask: '00000-000');
    cidadeDaPropriedadeController = TextEditingController();
    estadoDaPropriedadeController = TextEditingController();
    areaEmHectaresController = TextEditingController();
    quantidadeDeArvoresController = TextEditingController();
    clonePredominanteController = TextEditingController();
    isSeringueiro = false;
    isAgronomo = false;
    isProprietario = false;
    isAdmin = true;

    // Inicialização dos FocusNodes
    nomeDaPropriedadeFocus = FocusNode();
    cepDaPropriedadeFocus = FocusNode();
    cidadeDaPropriedadeFocus = FocusNode();
    estadoDaPropriedadeFocus = FocusNode();
    areaEmHectaresFocus = FocusNode();
    quantidadeDeArvoresFocus = FocusNode();
    clonePredominanteFocus = FocusNode();
  }

  @override
  void dispose() {
    // Descarte dos TextEditingController
    nomeDaPropriedadeController.dispose();
    cepDaPropriedadeController.dispose();
    cidadeDaPropriedadeController.dispose();
    estadoDaPropriedadeController.dispose();
    areaEmHectaresController.dispose();
    quantidadeDeArvoresController.dispose();
    clonePredominanteController.dispose();

    // Descarte dos FocusNode
    nomeDaPropriedadeFocus.dispose();
    cepDaPropriedadeFocus.dispose();
    cidadeDaPropriedadeFocus.dispose();
    estadoDaPropriedadeFocus.dispose();
    areaEmHectaresFocus.dispose();
    quantidadeDeArvoresFocus.dispose();
    clonePredominanteFocus.dispose();

    super.dispose();
  }

  int _currentStep = 0;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Propriedade'),
      ),
      body: BlocConsumer<NewPropertyBloc, NewPropertyState>(
        listener: (context, state) {
          if (state is NewPropertyLoaded) {
            // Aqui, navegue para a MainPage e resete a pilha de navegação
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => MainPage(
                        user: user!,
                      )), // Substitua MainPage pelo seu widget de página principal
              (Route<dynamic> route) => false,
            );
          } else if (state is NewPropertyError) {
            // Exiba uma mensagem de erro se algo der errado
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          // Adicione mais condições aqui para outros estados, como NewPropertyLoading
        },
        builder: (context, state) {
          if (state is NewPropertyLoading) {
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
                  child: const Text('ANTERIOR'),
                ),
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(_currentStep == _getSteps().length - 1
                    ? 'FINALIZAR'
                    : 'PRÓXIMO'),
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
        title: const Text('Coleta de localização'),
        content: Column(
          children: [
            ExplanationCard(
                titulo: 'Selecionar localização',
                explicacao:
                    'Abra o mapa abaixo e selecione o local da propriedade.',
                tipo: MessageType.explicativo),
            SizedBox(
              height: 8,
            ),
            SelectableLocationWidget(
              onLocationSelected: _updatePropertyLocation,
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Dados da propriedade'),
        content: Column(
          children: [
            PropertyDataForm(
              nomeDaPropriedadeController: nomeDaPropriedadeController,
              cepDaPropriedadeController: cepDaPropriedadeController,
              cidadeDaPropriedadeController: cidadeDaPropriedadeController,
              estadoDaPropriedadeController: estadoDaPropriedadeController,
              areaEmHectaresController: areaEmHectaresController,
              quantidadeDeArvoresController: quantidadeDeArvoresController,
              clonePredominanteController: clonePredominanteController,
              nomeDaPropriedadeFocus: nomeDaPropriedadeFocus,
              cepDaPropriedadeFocus: cepDaPropriedadeFocus,
              cidadeDaPropriedadeFocus: cidadeDaPropriedadeFocus,
              estadoDaPropriedadeFocus: estadoDaPropriedadeFocus,
              areaEmHectaresFocus: areaEmHectaresFocus,
              quantidadeDeArvoresFocus: quantidadeDeArvoresFocus,
              clonePredominanteFocus: clonePredominanteFocus,
            )
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Dados do usuário'),
        content: Column(
          children: [
            PropertyUserForm(
              initialIsSeringueiro: isSeringueiro,
              initialIsAgronomo: isAgronomo,
              initialIsProprietario: isProprietario,
              onSeringueiroChanged: (bool newValue) {
                setState(() => isSeringueiro = newValue);
              },
              onAgronomoChanged: (bool newValue) {
                setState(() => isAgronomo = newValue);
              },
              onProprietarioChanged: (bool newValue) {
                setState(() => isProprietario = newValue);
              },
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
      Step(
        title: const Text('Confirmação'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumo da Propriedade',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ListTile(
                title: Text('Nome da Propriedade'),
                subtitle: Text(nomeDaPropriedadeController.text),
              ),
              ListTile(
                title: Text('CEP'),
                subtitle: Text(cepDaPropriedadeController.text),
              ),
              ListTile(
                title: Text('Cidade'),
                subtitle: Text(cidadeDaPropriedadeController.text),
              ),
              ListTile(
                title: Text('Estado'),
                subtitle: Text(estadoDaPropriedadeController.text),
              ),
              ListTile(
                title: Text('Área em Hectares'),
                subtitle: Text(areaEmHectaresController.text),
              ),
              ListTile(
                title: Text('Quantidade de Árvores'),
                subtitle: Text(quantidadeDeArvoresController.text),
              ),
              ListTile(
                title: Text('Clone Predominante'),
                subtitle: Text(clonePredominanteController.text),
              ),
              Divider(),
              Text(
                'Informações do Usuário',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              CheckboxListTile(
                title: Text("Seringueiro"),
                value: isSeringueiro,
                onChanged: null, // Inativo, apenas para visualização
              ),
              CheckboxListTile(
                title: Text("Agrônomo"),
                value: isAgronomo,
                onChanged: null, // Inativo, apenas para visualização
              ),
              CheckboxListTile(
                title: Text("Proprietário"),
                value: isProprietario,
                onChanged: null, // Inativo, apenas para visualização
              ),
              CheckboxListTile(
                title: Text("Administrador"),
                value: isAdmin,
                onChanged: null, // Inativo, apenas para visualização
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 4,
      ),
    ];
  }

  void _next() {
    final bool isLastStep = _currentStep == _getSteps().length - 1;

    if (_currentStep < _getSteps().length - 1) {
      // Se não é o último passo, simplesmente avance para o próximo passo
      setState(() {
        _currentStep++;
      });
    } else if (isLastStep) {
      // Se é o último passo, dispare o evento para adicionar a nova propriedade
      _submitProperty();
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _submitProperty() {
    // Dispara o evento para começar o processo de adição (pode ser útil para iniciar algum estado de carregamento)
    BlocProvider.of<NewPropertyBloc>(context).add(NewPropertyAddStart());

    // Coleta todos os dados necessários dos controladores e variáveis de estado
    // Substitua 'GeoPoint(0, 0)' pela localização real obtida
    final propertyLocationGeoPoint =
        GeoPoint(_propertyLocation.latitude, _propertyLocation.longitude);

    // Dispara o evento para submeter a nova propriedade com todos os dados coletados
    BlocProvider.of<NewPropertyBloc>(context).add(
      NewPropertySubmit(
        nomeDaPropriedade: nomeDaPropriedadeController.text,
        areaEmHectares: double.parse(areaEmHectaresController.text),
        quantidadeDeArvores: int.parse(quantidadeDeArvoresController.text),
        cep: cepDaPropriedadeController.text,
        cidade: cidadeDaPropriedadeController.text,
        estado: estadoDaPropriedadeController.text,
        localizacao: propertyLocationGeoPoint,
        clonePredominante: clonePredominanteController.text,
        isSeringueiro: isSeringueiro,
        isAgronomo: isAgronomo,
        isProprietario: isProprietario,
        isAdmin: isAdmin,
      ),
    );
  }
}
