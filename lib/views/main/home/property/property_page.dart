import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/property_buttons_widget/property_buttons_widget.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_page.dart';

class PropertyPage extends StatefulWidget {
  final User user;
  final String propertyId;

  PropertyPage({Key? key, required this.user, required this.propertyId})
      : super(key: key);

  @override
  _PropertyPageState createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final propertyId = widget.propertyId;

    void _showPropertyButtons() {
      showModalBottomSheet(
        backgroundColor: Colors.green.shade900,
        context: context,
        builder: (BuildContext context) {
          return PropertyButtonsWidget(
              user: widget.user, propertyId: widget.propertyId);
        },
      );
    }

    return BlocProvider(
      create: (context) =>
          PropertyBloc()..add(LoadPropertyDetails(user, propertyId)),
      child: BlocConsumer<PropertyBloc, PropertyState>(
        listener: (context, state) {
          // Listener logic here
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(_getAppBarTitle(state)),
              backgroundColor: Colors.green.shade100,
              elevation: 50,
            ),
            body: _buildBody(context, state),
            backgroundColor: Colors.green.shade100,
            floatingActionButton: FloatingActionButton(
              onPressed: _showPropertyButtons,
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.green, // Cor do botão
              elevation: 50,
              // Você pode adicionar mais personalizações aqui se necessário
            ),
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
    } else if (state is PropertyError) {
      return Center(child: Text(state.message));
    } else if (state is PropertyLoaded) {
      return SingleChildScrollView(
        child: Column(
          children: [
            HourlyWeatherWidget(location: state.property.localizacao),
            _buildPainelDeAtividades(state.property),
            // Outros componentes relacionados à propriedade podem ser adicionados aqui
          ],
        ),
      );
    } else {
      return Center(child: Text('Estado não reconhecido!'));
    }
  }

  Widget _buildPainelDeAtividades(Property property) {
    // Conteúdo do Painel de Atividades aqui
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.green.shade100,
      margin: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            child: Text(
              "Painel de atividades",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green.shade900,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Corpo do Painel de Atividades
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Aqui você pode adicionar os detalhes específicos do Painel de Atividades
              ],
            ),
          ),
          // Rodapé, se necessário
        ],
      ),
    );
  }
}
