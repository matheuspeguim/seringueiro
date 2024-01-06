import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/services/local_storage_service.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/admin_widgets.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/agronomo_widgets.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/comum_widgets.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/propietario_widgets.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/seringueiro_widgets.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria/sangria.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria/sangria_manager.dart';
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
            backgroundColor: Colors.green.shade100,
          );
        },
      ),
    );
  }

  String _getAppBarTitle(PropertyState state) {
    if (state is PropertyLoaded ||
        state is SeringueiroViewState ||
        state is AgronomoViewState ||
        state is ProprietarioViewState ||
        state is AdminViewState ||
        state is SeringueiroAgronomoViewState ||
        state is SeringueiroProprietarioViewState ||
        state is AgronomoProprietarioViewState ||
        state is SeringueiroAgronomoAdminViewState ||
        state is SeringueiroProprietarioAdminViewState ||
        state is AgronomoProprietarioAdminViewState ||
        state is SeringueiroAdminViewState ||
        state is AgronomoAdminViewState ||
        state is ProprietarioAdminViewState ||
        state is TodosViewState ||
        state is TodosViewStateAdmin) {
      Property property = (state as dynamic).property;
      return property.nomeDaPropriedade.toUpperCase();
    }
    return 'Detalhes da Propriedade';
  }

  Widget _buildBody(BuildContext context, PropertyState state) {
    if (state is PropertyLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is PropertyError) {
      return Center(child: Text('Erro ao carregar a propriedade'));
    } else if (state is PropertyDeleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
      return Center(child: CircularProgressIndicator());
    } else if (state is PropertyLoaded ||
        state is SeringueiroViewState ||
        state is AgronomoViewState ||
        state is ProprietarioViewState ||
        state is AdminViewState ||
        state is SeringueiroAgronomoViewState ||
        state is SeringueiroProprietarioViewState ||
        state is AgronomoProprietarioViewState ||
        state is TodosViewState ||
        state is AdminViewState ||
        state is SeringueiroAgronomoAdminViewState ||
        state is SeringueiroProprietarioAdminViewState ||
        state is AgronomoProprietarioAdminViewState ||
        state is SeringueiroAdminViewState ||
        state is AgronomoAdminViewState ||
        state is ProprietarioAdminViewState ||
        state is TodosViewStateAdmin) {
      // Para todos os estados de carregamento bem-sucedido, chame a função de construção de conteúdo
      return _buildPropertyContent(context, state.property);
    } else {
      // Caso padrão para estados não reconhecidos
      return Center(child: Text('Estado não reconhecido!'));
    }
  }

  Widget _buildPropertyContent(BuildContext context, Property property) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 10.0, // Espaçamento horizontal
        runSpacing: 10.0, // Espaçamento vertical
        children: [
          // Adiciona os widgets comuns e específicos de função com espaçamento
          ...CommonWidgets.buildCommonWidgets(property),
          ...buildRoleSpecificWidgets(context, property),
        ],
      ),
    );
  }

  // Método para construir widgets baseados no papel do usuário
  List<Widget> buildRoleSpecificWidgets(
      BuildContext context, Property property) {
    final currentState = context.read<PropertyBloc>().state;
    List<Widget> widgets = [];

    // Lógica para adicionar widgets com base no estado específico
    if (currentState is SeringueiroViewState ||
        currentState is SeringueiroAgronomoViewState ||
        currentState is SeringueiroProprietarioViewState ||
        currentState is SeringueiroAgronomoAdminViewState ||
        currentState is SeringueiroProprietarioAdminViewState ||
        currentState is SeringueiroAdminViewState ||
        currentState is TodosViewState ||
        currentState is TodosViewStateAdmin) {
      widgets.addAll(SeringueiroWidgets.buildSeringueiroWidgets(
          context, widget.user, property, sangriaManager));
    }

    if (currentState is AgronomoViewState ||
        currentState is SeringueiroAgronomoViewState ||
        currentState is AgronomoProprietarioViewState ||
        currentState is SeringueiroAgronomoAdminViewState ||
        currentState is AgronomoProprietarioAdminViewState ||
        currentState is AgronomoAdminViewState ||
        currentState is TodosViewState ||
        currentState is TodosViewStateAdmin) {
      widgets.addAll(AgronomoWidgets.buildAgronomoWidgets(property));
    }

    if (currentState is ProprietarioViewState ||
        currentState is SeringueiroProprietarioViewState ||
        currentState is AgronomoProprietarioViewState ||
        currentState is SeringueiroProprietarioAdminViewState ||
        currentState is AgronomoProprietarioAdminViewState ||
        currentState is ProprietarioAdminViewState ||
        currentState is TodosViewState ||
        currentState is TodosViewStateAdmin) {
      widgets.addAll(ProprietarioWidgets.buildProprietarioWidgets(property));
    }

    if (currentState is AdminViewState ||
        currentState is SeringueiroAgronomoAdminViewState ||
        currentState is SeringueiroProprietarioAdminViewState ||
        currentState is AgronomoProprietarioAdminViewState ||
        currentState is SeringueiroAdminViewState ||
        currentState is AgronomoAdminViewState ||
        currentState is ProprietarioAdminViewState ||
        currentState is TodosViewStateAdmin) {
      widgets.addAll(AdminWidgets.buildAdminWidgets(context, property));
    }

    return widgets;
  }
}
