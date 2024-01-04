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

  @override
  void dispose() {
    mapController.dispose();
    _nomeDaPropriedadeController.dispose();
    _quantidadeDeArvoresController.dispose();
    _areaEmHectaresController.dispose();
    _nomeDaPropriedadeFocus.dispose();
    _quantidadeDeArvoresFocus.dispose();
    _areaEmHectaresFocus.dispose();
    super.dispose();
  }

  bool _validateProfessionSelected() {
    return isSeringueiro || isAgronomo || isProprietario;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green.shade900,
        appBar: AppBar(
          title:
              Text('Nova Propriedade', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.green.shade900,
        ),
        body: BlocListener<NewPropertyBloc, NewPropertyState>(
          listener: (context, state) {
            // Lógica para tratar os estados do bloc
            if (state is PropertySubmissionSuccess) {
              // Aqui você pode redirecionar o usuário para a HomePage ou mostrar uma mensagem de sucesso.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(user: widget.user)),
              );
            } else if (state is PropertySubmissionFailed) {
              // Aqui você pode mostrar uma mensagem de erro.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Erro ao submeter a propriedade: ${state.error}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<LatLng>(
                      future: _determinePosition(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Erro ao obter a localização'));
                        }
                        if (!snapshot.hasData) {
                          return Center(
                              child:
                                  Text('Dados de localização não disponíveis'));
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Abra o mapa abaixo e selecione o local exato da propriedade',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () async {
                                  if (currentMapPosition != null) {
                                    final selectedLocation =
                                        await Navigator.of(context)
                                            .push<LatLng>(
                                      MaterialPageRoute(
                                        builder: (context) => FullScreenMapPage(
                                            initialPosition:
                                                currentMapPosition!),
                                      ),
                                    );

                                    if (selectedLocation != null) {
                                      setState(() {
                                        currentMapPosition = selectedLocation;
                                      });
                                      if (currentMapPosition != null) {
                                        BlocProvider.of<NewPropertyBloc>(
                                                context)
                                            .add(ConfirmLocation(
                                                currentMapPosition!));
                                      }
                                    }
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
                                          target: currentMapPosition ??
                                              snapshot.data!,
                                          zoom: 16.0,
                                        ),
                                        myLocationEnabled: true,
                                        myLocationButtonEnabled: false,
                                        onMapCreated: (controller) =>
                                            mapController = controller,
                                        onCameraMove: (position) =>
                                            currentMapPosition =
                                                position.target,
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
                          ],
                        );
                      },
                    ),
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
                        FocusScope.of(context)
                            .requestFocus(_areaEmHectaresFocus);
                      },
                    ),
                    SizedBox(height: 16.0),
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
                        FocusScope.of(context)
                            .requestFocus(_quantidadeDeArvoresFocus);
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _quantidadeDeArvoresController,
                      focusNode: _quantidadeDeArvoresFocus,
                      validator:
                          PropertyInfoValidator.validarQuantidadeDeArvores,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Quantidade de árvores ativas',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.0),

                    // Checkbox para Seringueiro
                    CheckboxListTile(
                      title: Text('Seringueiro'),
                      value: isSeringueiro,
                      onChanged: (bool? value) {
                        setState(() {
                          isSeringueiro = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),

                    // Checkbox para Agrônomo
                    CheckboxListTile(
                      title: Text('Agrônomo'),
                      value: isAgronomo,
                      onChanged: (bool? value) {
                        setState(() {
                          isAgronomo = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),

                    // Checkbox para Proprietário
                    CheckboxListTile(
                      title: Text('Proprietário'),
                      value: isProprietario,
                      onChanged: (bool? value) {
                        setState(() {
                          isProprietario = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    CheckboxListTile(
                      enabled: false,
                      title: Text('Administrador'),
                      value: isAdmin,
                      onChanged: (bool? value) {
                        setState(() {
                          isAdmin = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        final String nomeDaPropriedade =
                            _nomeDaPropriedadeController.text;
                        final int areaEmHectares =
                            int.tryParse(_areaEmHectaresController.text) ?? 0;
                        final int quantidadeDeArvores =
                            int.tryParse(_quantidadeDeArvoresController.text) ??
                                0;

                        // Garantir que pelo menos uma profissão seja selecionada
                        if (isSeringueiro || isAgronomo || isProprietario) {
                          BlocProvider.of<NewPropertyBloc>(context).add(
                            SubmitPropertyData(
                              user: widget.user,
                              nomeDaPropriedade: nomeDaPropriedade,
                              areaEmHectares: areaEmHectares,
                              quantidadeDeArvores: quantidadeDeArvores,
                              // Novos parâmetros passados como um Map
                              atividadesSelecionadas: {
                                'seringueiro': isSeringueiro,
                                'agronomo': isAgronomo,
                                'proprietario': isProprietario,
                                'admin': isAdmin,
                              },
                              localizacao: currentMapPosition!,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Por favor, selecione pelo menos uma profissão'),
                            ),
                          );
                        }
                      },
                      child: Text('Cadastrar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
