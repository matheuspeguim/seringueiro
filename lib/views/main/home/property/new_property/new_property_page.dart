import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  String? _profissao;
  TextEditingController _nomeDaPropriedade = TextEditingController();
  TextEditingController _quantidadeDeArvores = TextEditingController();
  TextEditingController _areaEmHectares = TextEditingController();

  @override
  void dispose() {
    mapController.dispose();
    _nomeDaPropriedade.dispose();
    _quantidadeDeArvores.dispose();
    _areaEmHectares.dispose();
    super.dispose();
  }

  void _showProfessionPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.green.shade800,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
          ),
          child: ListView(
            children: <String>['Seringueiro', 'Agrônomo', 'Proprietário']
                .map((String profissao) {
              return ListTile(
                title: Text(profissao),
                textColor: Colors.white,
                onTap: () {
                  setState(() {
                    _profissao = profissao;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
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
                      controller: _nomeDaPropriedade,
                      validator: PropertyInfoValidator.validarNomeDaPropriedade,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Nome da propriedade',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _areaEmHectares,
                      validator: PropertyInfoValidator.validarAreasEmHectares,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Área em hectares (ha)',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _quantidadeDeArvores,
                      validator:
                          PropertyInfoValidator.validarQuantidadeDeArvores,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Quantidade de árvores ativas',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      readOnly: true, // Isso evita que o teclado apareça
                      decoration: InputDecoration(
                          labelText: 'Selecione a sua função',
                          hintText: _profissao ?? '',
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          )
                          // ... outras propriedades da decoração
                          ),
                      onTap: () {
                        _showProfessionPicker(context);
                      },
                      // ... outras propriedades do TextFormField
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_profissao != null) {
                          final String nomeDaPropriedade =
                              _nomeDaPropriedade.text;
                          final int quantidadeDeArvores =
                              int.tryParse(_quantidadeDeArvores.text) ?? 0;
                          String? atividadeSelecionada = _profissao;

                          BlocProvider.of<NewPropertyBloc>(context).add(
                            SubmitPropertyData(
                              user: widget.user,
                              nomeDaPropriedade: nomeDaPropriedade,
                              quantidadeDeArvores: quantidadeDeArvores,
                              atividadeSelecionada: atividadeSelecionada,
                              localizacao: currentMapPosition!,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Por favor, corrija os campos marcados'),
                          ));
                        }
                        ;
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
