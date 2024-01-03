import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/services/local_storage_service.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria/sangria.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria/sangria_manager.dart';
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
  bool _isSangriaIniciada = false;
  Property? _currentProperty;
  final SangriaManager sangriaManager = SangriaManager();
  Sangria? sangriaAtual;

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
              _buildSangriaPainel(state.property),
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

  Widget _buildSangriaPainel(Property property) {
    return SingleChildScrollView(
      child: Card(
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
                "Painel de sangria",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Corpo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Adicione mais Widgets aqui para exibir os detalhes da propriedade
                ],
              ),
            ),

            // Rodapé (se necessário, adicione funcionalidades similares ao _buildPropertyCard)
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, Property property) {
    return TextButton(
      onPressed: () => _confirmDeletion(context, property),
      child: Text('Excluir Propriedade', style: TextStyle(color: Colors.red)),
    );
  }

  Future<String?> _escolherTabela(BuildContext context) async {
    String? tabelaSelecionada;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Escolha uma Tabela'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                for (var i = 1; i <= 5; i++)
                  ListTile(
                    title: Text('Tabela $i'),
                    onTap: () {
                      tabelaSelecionada = 'Tabela $i';
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );

    return tabelaSelecionada;
  }

  void _toggleSangria() async {
    print("Estado inicial de _isSangriaIniciada: $_isSangriaIniciada");

    setState(() {
      _isSangriaIniciada = !_isSangriaIniciada;
    });

    print("Estado final de _isSangriaIniciada: $_isSangriaIniciada");
    if (_isSangriaIniciada) {
      String? tabelaSelecionada = await _escolherTabela(context);

      if (tabelaSelecionada != null) {
        // Iniciar uma nova sangria com a tabela selecionada
        sangriaAtual = await sangriaManager.iniciarSangria(
            _currentProperty!, widget.user, tabelaSelecionada);
        if (sangriaAtual == null) {
          print("Falha ao iniciar a sangria.");
          setState(() {
            _isSangriaIniciada = false;
          });
          return;
        }
        // Continuar com a lógica de sangria iniciada
        // Por exemplo, mostrar uma notificação ou atualizar a UI
      } else {
        // O usuário não escolheu uma tabela, cancelar a iniciação da sangria
        print("Iniciação da sangria cancelada pelo usuário.");
        setState(() {
          _isSangriaIniciada = false;
        });
      }
    } else {
      // Finalizar a sangria atual
      if (sangriaAtual != null) {
        await sangriaManager.finalizarSangria(sangriaAtual!);
        // Tratar o pós-finalização da sangria
        // Por exemplo, atualizar a UI ou salvar dados
      }
    }
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
        _isSangriaIniciada ? 'Finalizar Sangria' : 'Nova Sangria',
        style: TextStyle(color: Colors.white),
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
