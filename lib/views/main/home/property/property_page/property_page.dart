import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:flutter_seringueiro/common/models/property_user.dart';
import 'package:flutter_seringueiro/common/services/weather_service.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_manager.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_widgets/field_activity_control_painel.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/property_weather_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/property_weather_page.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/weather_sections/current_weather_section.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/weather_widgets/hourly_temperature_list_view.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/property_buttons_widget/property_buttons_widget.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/property_calendar.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_settings/property_settings_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_settings/property_settings_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_settings/property_settings_page.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_user/property_users_widgets/property_users_icon.dart';

class PropertyPage extends StatefulWidget {
  final Property property;

  const PropertyPage({Key? key, required this.property}) : super(key: key);

  @override
  _PropertyPageState createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  late Future<PropertyUser> _permissionsFuture;
  late User _currentUser;
  late FieldActivityManager _activityManager;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _activityManager = FieldActivityManager();
    _permissionsFuture = _getPermissionsForProperty(widget.property.id);
  }

  Future<PropertyUser> _getPermissionsForProperty(String propertyId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final docSnapshot = await _firestore
        .collection('property_users')
        .where('uid', isEqualTo: _currentUser.uid)
        .where('propertyId', isEqualTo: propertyId)
        .limit(1)
        .get();

    if (docSnapshot.docs.isEmpty) {
      throw Exception("Permissões não encontradas.");
    }
    return PropertyUser.fromFirestore(docSnapshot.docs.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property.nomeDaPropriedade.toUpperCase()),
        actions: [
          IconButton(
              onPressed: _navigateToPropertySettings,
              icon: Icon(Icons.settings))
        ],
      ),
      body: FutureBuilder<PropertyUser>(
        future: _permissionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar permissões."));
          }
          return _buildPropertyDetails(snapshot.data!);
        },
      ),
      floatingActionButton: FutureBuilder<PropertyUser>(
        future: _permissionsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton(
              onPressed: () => _showPropertyButtons(snapshot.data!),
              child: Icon(Icons.add),
            );
          } else {
            return SizedBox.shrink(); // Esconde o FAB se não houver permissões
          }
        },
      ),
    );
  }

  void _showPropertyButtons(PropertyUser propertyUser) {
    showModalBottomSheet(
      elevation: 0,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => PropertyButtonsWidget(
          user: _currentUser,
          property: widget.property,
          activityManager: _activityManager,
          propertyUser: propertyUser),
    );
  }

  Widget _buildPropertyDetails(PropertyUser permissions) {
    return Padding(
        padding: EdgeInsets.all(4),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FieldActivityControlPanel(
                  userId: _currentUser.uid, propertyId: widget.property.id),
              Divider(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      // Substitua `WeatherService()` pelo seu mecanismo de injeção de dependência ou serviço, se aplicável.
                      return BlocProvider<PropertyWeatherBloc>(
                        create: (context) => PropertyWeatherBloc(
                            weatherService: WeatherService()),
                        child: PropertyWeatherPage(
                            latitude: widget.property.localizacao.latitude,
                            longitude: widget.property.localizacao
                                .longitude), // Substitua pelas coordenadas desejadas
                      );
                    }),
                  );
                },
                child: Text('Ver Condições Climáticas'),
              ),
              CurrentWeatherSection(weather: widget.property.weather!),
              PropertyUsersIconRow(
                propertyId: widget.property.id,
              ),
              Divider(),
              PropertyCalendar(propertyId: widget.property.id),
              // Inclua outros widgets conforme necessário, baseados nas permissões
            ],
          ),
        ));
  }

  void _navigateToPropertySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<PropertySettingsBloc>(
          create: (context) => PropertySettingsBloc()
            ..add(LoadPropertySettings(widget.property.id)),
          child: PropertySettingsPage(property: widget.property),
        ),
      ),
    );
  }
}
