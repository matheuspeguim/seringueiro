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
import 'package:flutter_seringueiro/views/main/home/weather/weather_page.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var bloc = HomePageBloc(user: user);
        bloc.add(FetchUserDataEvent());
        bloc.add(FetchPropertiesEvent(user: user));
        return bloc;
      },
      child: Scaffold(
        backgroundColor: Colors.green.shade200,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green.shade900,
          elevation: 5.0,
          shadowColor: Colors.grey.shade900,
          title: _buildUserGreeting(context),
        ),
        body: _buildPropertiesList(context),
      ),
    );
  }

  Widget _buildUserGreeting(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        if (state is UserDataLoading) {
          return Text("");
        } else if (state is UserDataLoaded) {
          return Text("Olá, ${state.firstName}",
              style: TextStyle(color: Colors.white));
        } else if (state is UserDataError) {
          return Text("Olá, Usuário", style: TextStyle(color: Colors.white));
        }
        return Text("Olá, usuário", style: TextStyle(color: Colors.white));
      },
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
          return _errorWidget(state.message);
        }
        return _buildNewPropertyButton(context); // Default case
      },
    );
  }

  Widget _buildPropertyCard(BuildContext context, Property property) {
    return Card(
      elevation: 5.0,
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
                  WeatherWidget(location: property.localizacao),
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
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return BlocProvider<NewPropertyBloc>(
                create: (context) => NewPropertyBloc(),
                child: NewPropertyPage(user: user),
              );
            }),
          );
        },
        child: Text('Novo local de trabalho'),
      ),
    ));
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _errorWidget(String message) {
    return Center(child: Text(message));
  }

  Widget _propertiesListWidget(BuildContext context, PropertiesLoaded state) {
    if (state.properties.isEmpty) {
      return _buildNewPropertyButton(context);
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomePageBloc>().add(FetchPropertiesEvent(user: user));
      },
      child: ListView.builder(
        itemCount: state.properties.length + 1,
        itemBuilder: (context, index) {
          if (index < state.properties.length) {
            return _buildPropertyCard(context, state.properties[index]);
          }
          return _buildNewPropertyButton(context);
        },
      ),
    );
  }
}
