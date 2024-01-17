import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/property_buttons_widget/property_buttons_widget.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_widgets.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_page.dart';
import 'package:flutter_seringueiro/widgets/custom_card.dart';

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
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              title: Text(
                _getAppBarTitle(state),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green.shade800,
              elevation: 50,
            ),
            body: _buildBody(context, state),
            backgroundColor: Colors.green.shade100,
            floatingActionButton: FloatingActionButton(
              onPressed: _showPropertyButtons,
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.green, // Cor do botão
              elevation: 10,

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

  void _showPropertyButtons() {
    showModalBottomSheet(
      backgroundColor: Colors.grey.shade200,
      context: context,
      builder: (BuildContext context) {
        return PropertyButtonsWidget(
            user: widget.user, propertyId: widget.propertyId);
      },
    );
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
            SizedBox(height: 32),
            CustomCard(
              title: "Previsão do tempo",
              onButtonPressed: () => {},
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal),
              body: HourlyWeatherWidget(location: state.property.localizacao),
            ),
            SizedBox(height: 32),
            CustomCard(
              title: "Chuvas por mês",
              onButtonPressed: () => {},
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
              body: Container(
                height: 300,
                child: BlocProvider<RainBloc>(
                  create: (context) =>
                      RainBloc(firestore: FirebaseFirestore.instance),
                  child: RainChartWidget(propertyId: state.property.id),
                ),
              ),
            ),
            SizedBox(height: 32),
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
    return CustomCard(
      title: 'Painel de atividades',
      body: Column(),
      onButtonPressed: () {
        // Ação do botão
      },
    );
  }
}
