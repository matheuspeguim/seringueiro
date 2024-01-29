import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/services/open_weather_api_service.dart';
import 'package:flutter_seringueiro/models/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/property_buttons_widget/property_buttons_widget.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_widgets.dart';
import 'package:flutter_seringueiro/views/main/home/weather/hourly_weather_widget.dart';
import 'package:flutter_seringueiro/widgets/custom_Circular_Progress_indicator.dart';
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
        listener: (context, state) {},
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
      return Center(child: CustomCircularProgressIndicator());
    } else if (state is PropertyError) {
      return Center(child: Text(state.message));
    } else if (state is PropertyLoaded) {
      bool _useManualData = false;
      return RefreshIndicator(
        onRefresh: () async {
          context
              .read<PropertyBloc>()
              .add(LoadPropertyDetails(widget.user, widget.propertyId));
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 8),
              CustomCard(
                title: "Previsão do tempo",
                onButtonPressed: () => {},
                colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal),
                body: HourlyWeatherWidget(location: state.property.localizacao),
              ),
              SizedBox(height: 8),
              _buildPainelDeAtividades(state.property),
              SizedBox(height: 8),
              CustomCard(
                title: "Histórico de Chuvas",
                onButtonPressed: () => {},
                colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
                body: Column(
                  children: [
                    SwitchListTile(
                      title: Text('Usar Dados Próprios'),
                      value:
                          _useManualData, // Esta é uma variável de estado do widget
                      onChanged: (bool value) {
                        setState(() {
                          _useManualData = value;
                          // Aqui, dependendo do estado, dispare o evento apropriado no RainBloc
                        });
                      },
                    ),
                    Expanded(
                      child: BlocProvider<RainBloc>(
                        create: (context) => RainBloc(
                            firestore: FirebaseFirestore.instance,
                            weatherApiService: OpenWeatherApiService(
                                apiKey: dotenv.env['OPENWEATHER_API_KEY']!)),
                        child: RainChartWidget(propertyId: state.property.id),
                      ),
                    ),
                  ],
                ),
              ),

              // Outros componentes relacionados à propriedade podem ser adicionados aqui
            ],
          ),
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
