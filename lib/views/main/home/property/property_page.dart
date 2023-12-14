import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/services/local_storage_service.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_page.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';

class PropertyPage extends StatefulWidget {
  final User user;
  final String propertyId;

  PropertyPage({Key? key, required this.user, required this.propertyId})
      : super(key: key);

  @override
  _PropertyPageState createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  Timer? _timer;
  Duration _duration = Duration.zero;
  bool _isSangriaIniciada = false;
  Property? _currentProperty;

  final SangriaService sangriaService = SangriaService();
  final LocalStorageService localStorageService = LocalStorageService();

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final propertyId = widget.propertyId;

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
      _currentProperty = state.property;
      return state.property.nomeDaPropriedade.toUpperCase();
    }
    return 'Detalhes da Propriedade';
  }

  Widget _buildBody(BuildContext context, PropertyState state) {
    if (state is PropertyLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is PropertyLoaded) {
      return Scaffold(
        backgroundColor: Colors.green.shade200,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 8),
              _buildWeatherAndDetails(state.property),
              SizedBox(height: 8),
              _buildSangriasSection(context),
              SizedBox(height: 8),
              _buildDeleteButton(context, state.property),
            ],
          ),
        ),
        floatingActionButton: _buildSangriaButton(),
      );
    } else if (state is PropertyError) {
      return Center(child: Text('Erro ao carregar a propriedade'));
    } else {
      return Container();
    }
  }

  Widget _buildWeatherAndDetails(Property property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HourlyWeatherWidget(location: property.localizacao),
        // Adicione aqui outros widgets importantes
      ],
    );
  }

  Widget _buildSangriasSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildSangriasHeader(),
          _buildSangriasList(
              context), // Implemente esta função para mostrar a lista de sangrias
          _buildSangriasFooter(
              context), // Implemente esta função para adicionar botões de ação
        ],
      ),
    );
  }

  Widget _buildSangriasHeader() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          'Painel de sangrias',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSangriasList(BuildContext context) {
    // Aqui você pode buscar os dados das sangrias e montar uma lista
    // Por exemplo, usando um ListView.builder ou widgets semelhantes
    return Container(); // Substitua por sua implementação
  }

  Widget _buildSangriasFooter(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Implemente a ação desejada, como abrir uma nova tela com todas as sangrias
      },
      child: Text(
        'Ver todas as sangrias',
        style: TextStyle(color: Colors.green.shade900),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, Property property) {
    return TextButton(
      onPressed: () => _confirmDeletion(context, property),
      child: Text('Excluir Propriedade', style: TextStyle(color: Colors.red)),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void _toggleSangria() {
    if (_currentProperty == null) {
      print("Erro: a propriedade atual é nula.");
      return; // Não continue se a propriedade atual for nula
    }

    setState(() {
      _isSangriaIniciada = !_isSangriaIniciada;
    });

    if (_isSangriaIniciada) {
      _startSangria(_currentProperty!); // Inicia a sangria
    } else {
      _finalizeSangria(); // Finaliza a sangria
    }
  }

  void _startSangria(Property property) {
    print("Iniciando Sangria para a propriedade: ${property.id}");
    _duration = Duration.zero;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _duration += Duration(seconds: 1));
    });
    // Assumindo que property.localizacao já é do tipo GeoPoint
    sangriaService.gerenciarSangria(context, property.localizacao, widget.user,
        iniciar: true);
  }

  void _finalizeSangria() {
    _timer?.cancel();
    setState(() {
      _duration = Duration.zero;
      _isSangriaIniciada = false;
    });
    sangriaService.gerenciarSangria(context, GeoPoint(0, 0), widget.user,
        iniciar: false); // Assume a localização padrão
  }

  Widget _buildSangriaButton() {
    return FloatingActionButton.extended(
      elevation: 5,
      onPressed: _toggleSangria,
      backgroundColor:
          _isSangriaIniciada ? Colors.red.shade700 : Colors.green.shade700,
      icon: Icon(_isSangriaIniciada ? Icons.stop : Icons.add,
          color: Colors.white),
      label: Text(
        _isSangriaIniciada ? 'Finalizar Sangria' : 'Iniciar Sangria',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildSangriaControlPanel() {
    return _isSangriaIniciada
        ? Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Tempo de Sangria: ${_formatDuration(_duration)}"),
                  // Adicione outros elementos necessários ao painel
                ],
              ),
            ),
          )
        : Container(); // Não exibe nada se a sangria não estiver ativa
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
                    .add(DeleteProperty(widget.user, property.id));
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
}
