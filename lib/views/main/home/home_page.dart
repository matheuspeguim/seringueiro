import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/home_page_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/home_page_event.dart';
import 'package:flutter_seringueiro/views/main/home/home_page_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/new_property/new_property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/new_property/new_property_page.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_page.dart';
import 'package:flutter_seringueiro/views/main/home/property/searcher/search_property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/searcher/search_property_page.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_page.dart';
import 'package:flutter_seringueiro/widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var bloc = HomePageBloc(user: user);
        bloc.add(FetchPropertiesEvent(user: user));
        return bloc;
      },
      child: Scaffold(
        backgroundColor: Colors.green.shade100,
        body: _buildPropertiesList(context),
      ),
    );
  }

  Widget _buildPropertiesList(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        if (state is PropertiesLoading) {
          return _loadingWidget();
        } else if (state is PropertiesLoaded) {
          return _propertiesListWidget(context, state);
        } else if (state is PropertiesError) {
          return _errorWidget(state.message, context);
        }
        return _buildNewPropertyButton(context); // Default case
      },
    );
  }

  Widget _buildPropertyCard(BuildContext context, Property property) {
    return Card(
      elevation: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.green.shade200,
      margin: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.green.shade800,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            child: Text(
              property.nomeDaPropriedade.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Corpo
          Container(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DailyWeatherWidget(location: property.localizacao),
                  // Outras informações da propriedade aqui
                ],
              ),
            ),
          ),

          // Rodapé com botão
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.0),
            decoration: BoxDecoration(
              color: Colors.green.shade300,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(15.0)),
            ),
            child: TextButton(
              style: TextButton.styleFrom(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => PropertyBloc()
                        ..add(LoadPropertyDetails(user, property.id)),
                      child: PropertyPage(user: user, propertyId: property.id),
                    ),
                  ),
                );
              },
              child: Text(
                "Mais informações",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 13.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPropertyButton(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              label: 'Adicionar propriedade',
              icon: Icons.add,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return BlocProvider<SearchPropertyBloc>(
                      create: (context) => SearchPropertyBloc(),
                      child: SearchPropertyPage(user: user),
                    );
                  }),
                );
              },
            )));
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _errorWidget(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => _showNewPropertyPage(context),
            child: Text('Cadastrar novo local de trabalho'),
          ),
        ],
      ),
    );
  }

  void _showNewPropertyPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return BlocProvider<NewPropertyBloc>(
          create: (context) => NewPropertyBloc(),
          child: NewPropertyPage(user: user),
        );
      }),
    );
  }

  Widget _propertiesListWidget(BuildContext context, PropertiesLoaded state) {
    // Ajuste o itemCount para ser sempre o número de propriedades + 1 (para o botão)
    int itemCount = state.properties.length + 1;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomePageBloc>().add(FetchPropertiesEvent(user: user));
      },
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          // Se o índice for o último, mostre o botão "Nova Propriedade"
          if (index == state.properties.length) {
            return _buildNewPropertyButton(context);
          }

          // Caso contrário, construa o card da propriedade
          return _buildPropertyCard(context, state.properties[index]);
        },
      ),
    );
  }
}
