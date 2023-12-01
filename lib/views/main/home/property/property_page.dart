import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_state.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Outros imports necessários...

class PropertyPage extends StatelessWidget {
  final User user;
  final String propertyId;

  PropertyPage({Key? key, required this.user, required this.propertyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PropertyBloc()..add(LoadPropertyDetails(user, propertyId)),
      child: BlocConsumer<PropertyBloc, PropertyState>(
        listener: (context, state) {
          if (state is PropertyDeleted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainPage(user: user)),
              (Route<dynamic> route) => false,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.green.shade200,
            appBar: AppBar(
              centerTitle: true,
              title: Text(_getAppBarTitle(state)),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 23.0),
              backgroundColor: Colors.green.shade900,
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  String _getAppBarTitle(PropertyState state) {
    if (state is PropertyLoaded) {
      return state.property.nomeDaPropriedade.toUpperCase();
    }
    return 'Detalhes da Propriedade';
  }

  Widget _buildBody(BuildContext context, PropertyState state) {
    if (state is PropertyLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is PropertyLoaded) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildPropertyDetailsCard(state.property),
            SizedBox(height: 8),
            _buildSangriaCard(context),
            SizedBox(height: 8),
            _buildDeleteButton(context, state.property),
          ],
        ),
      );
    } else if (state is PropertyError) {
      return Center(child: Text('Erro ao carregar a propriedade'));
    } else {
      return Container();
    }
  }

  Widget _buildPropertyDetailsCard(Property property) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Localização'),
          ),
          Container(
            height: 200, // Defina uma altura fixa para o container do mapa
            child: GoogleMap(
              mapType: MapType
                  .satellite, // Isso define o mapa para mostrar imagens de satélite
              initialCameraPosition: CameraPosition(
                target: LatLng(property.localizacao.latitude,
                    property.localizacao.longitude),
                zoom: 16, // Defina o nível de zoom adequado para sua aplicação
              ),
              markers: {
                Marker(
                  // Este é o marcador para a localização
                  markerId: MarkerId(property.id.toString()),
                  position: LatLng(property.localizacao.latitude,
                      property.localizacao.longitude),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSangriaCard(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _startSangria(context),
      child: Text('Iniciar Sangria',
          style: TextStyle(
            color: Colors.white,
          )),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade800,
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, Property property) {
    return ElevatedButton(
      onPressed: () => _confirmDeletion(context, property),
      child: Text('Excluir Propriedade', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
    );
  }

  void _confirmDeletion(BuildContext blocContext, Property property) {
    showDialog(
      context: blocContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text(
              'Deseja realmente excluir a propriedade ${property.nomeDaPropriedade.toUpperCase()}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fecha o diálogo
              },
            ),
            ElevatedButton(
              child: Text(
                'Excluir',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(); // Fecha o diálogo após a ação
                blocContext
                    .read<PropertyBloc>()
                    .add(DeleteProperty(user, property.id));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void _startSangria(BuildContext context) {
    context.read<PropertyBloc>().add(StartSangria());
  }
}
