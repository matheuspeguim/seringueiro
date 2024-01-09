import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/validators/property_info_validator.dart';
import 'package:flutter_seringueiro/views/main/home/property/new_property/full_screen_map_page.dart';
import 'package:flutter_seringueiro/views/main/home/property/new_property/new_property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/new_property/new_property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/new_property/new_property_state.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewPropertyPage extends StatefulWidget {
  final User user;
  NewPropertyPage({Key? key, required this.user}) : super(key: key);

  @override
  _NewPropertyPageState createState() => _NewPropertyPageState();
}

class _NewPropertyPageState extends State<NewPropertyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late GoogleMapController mapController;
  LatLng? currentMapPosition;
  bool isSeringueiro = false;
  bool isAgronomo = false;
  bool isProprietario = false;
  bool isAdmin = true;
  final _nomeDaPropriedadeController = TextEditingController();
  final _quantidadeDeArvoresController = TextEditingController();
  final _areaEmHectaresController = TextEditingController();
  final _nomeDaPropriedadeFocus = FocusNode();
  final _quantidadeDeArvoresFocus = FocusNode();
  final _areaEmHectaresFocus = FocusNode();
  PageController _pageController = PageController();

  @override
  void dispose() {
    mapController.dispose();
    _nomeDaPropriedadeController.dispose();
    _quantidadeDeArvoresController.dispose();
    _areaEmHectaresController.dispose();
    _nomeDaPropriedadeFocus.dispose();
    _quantidadeDeArvoresFocus.dispose();
    _areaEmHectaresFocus.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<LatLng> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifique se os serviços de localização estão ativados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Solicitar ao usuário para ativar os serviços de localização
      return LatLng(
          0, 0); // Coordenadas padrão se o serviço não estiver ativado
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissões negadas
        return LatLng(0, 0); // Coordenadas padrão se a permissão for negada
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissões negadas permanentemente
      return LatLng(0, 0); // Coordenadas padrão
    }

    // Quando tudo estiver ok, obter a localização atual
    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  bool _validateProfessionSelected() {
    return isSeringueiro || isAgronomo || isProprietario;
  }

  Widget _buildMapPage() {
    return FutureBuilder<LatLng>(
      future: _determinePosition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao obter a localização'));
        }
        if (!snapshot.hasData) {
          return Center(child: Text('Dados de localização não disponíveis'));
        }

        // Apenas atualizar currentMapPosition se ainda não estiver definido
        if (currentMapPosition == null) {
          currentMapPosition = snapshot.data ?? LatLng(0, 0);
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Abra o mapa abaixo centralize o seringal da propriedade',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: GestureDetector(
                onTap: () async {
                  final selectedLocation =
                      await Navigator.of(context).push<LatLng>(
                    MaterialPageRoute(
                      builder: (context) => FullScreenMapPage(
                          initialPosition: currentMapPosition ??
                              LatLng(0,
                                  0)), // Substitua LatLng(0, 0) pela sua localização padrão
                    ),
                  );

                  if (selectedLocation != null) {
                    setState(() {
                      currentMapPosition = selectedLocation;
                    });
                  }
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.satellite,
                        initialCameraPosition: CameraPosition(
                          target: currentMapPosition!,
                          zoom: 16.0,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        onMapCreated: (controller) =>
                            mapController = controller,
                        onCameraMove: (position) =>
                            currentMapPosition = position.target,
                        zoomControlsEnabled: false,
                      ),
                      Center(
                        child: Icon(Icons.location_pin,
                            size: 50, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              ),
              child: Text('Confirmar Localização e Continuar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFormPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo para o Nome da Propriedade
          TextFormField(
            controller: _nomeDaPropriedadeController,
            focusNode: _nomeDaPropriedadeFocus,
            validator: PropertyInfoValidator.validarNomeDaPropriedade,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: 'Nome da propriedade',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            keyboardType: TextInputType.name,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_areaEmHectaresFocus);
            },
          ),
          SizedBox(height: 16.0),

          // Campo para a Área em Hectares
          TextFormField(
            controller: _areaEmHectaresController,
            focusNode: _areaEmHectaresFocus,
            validator: PropertyInfoValidator.validarAreasEmHectares,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: 'Área em hectares (ha)',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            keyboardType: TextInputType.number,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_quantidadeDeArvoresFocus);
            },
          ),
          SizedBox(height: 16.0),

          // Campo para a Quantidade de Árvores
          TextFormField(
            controller: _quantidadeDeArvoresController,
            focusNode: _quantidadeDeArvoresFocus,
            validator: PropertyInfoValidator.validarQuantidadeDeArvores,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: 'Quantidade de árvores ativas',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.0),

          // Checkboxes para as Profissões
          _buildProfessionCheckbox('Seringueiro', isSeringueiro),
          _buildProfessionCheckbox('Agrônomo', isAgronomo),
          _buildProfessionCheckbox('Proprietário', isProprietario),
          _buildProfessionCheckbox('Administrador', isAdmin, enabled: false),

          // Botão para Submeter o Formulário
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Cadastrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionCheckbox(String title, bool value,
      {bool enabled = true}) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: enabled
          ? (bool? newValue) {
              setState(() {
                switch (title) {
                  case 'Seringueiro':
                    isSeringueiro = newValue!;
                    break;
                  case 'Agrônomo':
                    isAgronomo = newValue!;
                    break;
                  case 'Proprietário':
                    isProprietario = newValue!;
                    break;
                  // O 'Administrador' não muda
                }
              });
            }
          : null,
    );
  }

  void _submitForm() {
    // Imprimindo os dados para diagnóstico
    print('Dados do formulário:');
    print('Nome da Propriedade: ${_nomeDaPropriedadeController.text}');
    print('Área em Hectares: ${_areaEmHectaresController.text}');
    print('Quantidade de Árvores: ${_quantidadeDeArvoresController.text}');
    print('Localização Atual: $currentMapPosition');
    print(
        'Profissões Selecionadas: Seringueiro: $isSeringueiro, Agrônomo: $isAgronomo, Proprietário: $isProprietario, Admin: $isAdmin');

    // Verificar se pelo menos uma profissão foi selecionada
    print('Verificando se há profissões selecionadas');
    if (!_validateProfessionSelected()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Por favor, selecione pelo menos uma profissão')),
      );
      return;
    }

    // Preparar os dados para envio
    print('Preparando dados para enviar');
    final String nomeDaPropriedade = _nomeDaPropriedadeController.text;
    final int areaEmHectares =
        int.tryParse(_areaEmHectaresController.text) ?? 0;
    final int quantidadeDeArvores =
        int.tryParse(_quantidadeDeArvoresController.text) ?? 0;

    // Enviar os dados usando o Bloc
    print('Enviando dados pelo Bloc');
    BlocProvider.of<NewPropertyBloc>(context).add(
      SubmitPropertyData(
        user: widget.user,
        nomeDaPropriedade: nomeDaPropriedade,
        areaEmHectares: areaEmHectares,
        quantidadeDeArvores: quantidadeDeArvores,
        atividadesSelecionadas: {
          'seringueiro': isSeringueiro,
          'agronomo': isAgronomo,
          'proprietario': isProprietario,
          'admin': isAdmin,
        },
        localizacao: currentMapPosition!,
      ),
    );

    // Feedback para o usuário (opcional)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Propriedade submetida com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title: Text('Nova Propriedade', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
      ),
      body: BlocListener<NewPropertyBloc, NewPropertyState>(
        listener: (context, state) {
          if (state is PropertySubmissionSuccess) {
            // Se a propriedade foi submetida com sucesso
            print('Estado é PropertySubmissionSucess');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Propriedade cadastrada com sucesso!')),
            );
            // Navegar para outra página, se necessário
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainPage(user: widget.user)),
            );
          } else if (state is PropertySubmissionFailed) {
            // Se houve falha na submissão da propriedade
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Erro ao submeter a propriedade: ${state.error}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PageView(
            controller: _pageController,
            children: [
              _buildMapPage(),
              _buildFormPage(),
            ],
          ),
        ),
      ),
    );
  }
}
