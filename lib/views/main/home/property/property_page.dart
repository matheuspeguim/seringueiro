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
      return _buildPropertyContent(context, state.property);
    } else if (state is SeringueiroViewState) {
      return _buildPropertyContent(context, state.property);
    } else if (state is AgronomoViewState) {
      return _buildPropertyContent(context, state.property);
    } else if (state is ProprietarioViewState) {
      return _buildPropertyContent(context, state.property);
    } else if (state is AdminViewState) {
      return _buildPropertyContent(context, state.property);
    }
    // Inclua outros estados aqui, como SeringueiroAgronomoViewState, etc.
    else if (state is PropertyError) {
      return Center(child: Text('Erro ao carregar a propriedade'));
    } else {
      // Caso padrão para estados não reconhecidos
      return Center(child: Text('Estado não reconhecido!'));
    }
  }

  Widget _buildPropertyContent(BuildContext context, Property property) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...CommonWidgets.buildCommonWidgets(property),
          buildRoleSpecificWidgets(context, property),
        ],
      ),
    );
  }

  Widget buildRoleSpecificWidgets(BuildContext context, Property state) {
    List<Widget> widgets = [];
    Property? property;

    // Extrair o objeto Property dos diferentes estados
    if (state is PropertyLoaded) {
    } else if (state is SeringueiroViewState) {
    } else if (state is AgronomoViewState) {
    } else if (state is ProprietarioViewState) {
    } else if (state is AdminViewState) {
    } else if (state is SeringueiroAgronomoViewState ||
        state is SeringueiroProprietarioViewState ||
        state is AgronomoProprietarioViewState ||
        state is TodosViewState ||
        state is SeringueiroAgronomoAdminViewState ||
        state is SeringueiroProprietarioAdminViewState ||
        state is AgronomoProprietarioAdminViewState ||
        state is SeringueiroAdminViewState ||
        state is AgronomoAdminViewState ||
        state is ProprietarioAdminViewState ||
        state is TodosViewStateAdmin) {}

    // Adicionar widgets específicos com base na propriedade e no papel do usuário
    if (property != null) {
      widgets.addAll(CommonWidgets.buildCommonWidgets(property));

      if (state is SeringueiroViewState ||
          state is SeringueiroAgronomoViewState ||
          state is SeringueiroProprietarioViewState ||
          state is SeringueiroAgronomoAdminViewState ||
          state is SeringueiroProprietarioAdminViewState ||
          state is SeringueiroAdminViewState ||
          state is TodosViewState ||
          state is TodosViewStateAdmin) {
        widgets.addAll(SeringueiroWidgets.buildSeringueiroWidgets(
            context, widget.user, property, sangriaManager));
      }
      if (state is AgronomoViewState ||
          state is SeringueiroAgronomoViewState ||
          state is AgronomoProprietarioViewState ||
          state is SeringueiroAgronomoAdminViewState ||
          state is AgronomoProprietarioAdminViewState ||
          state is AgronomoAdminViewState ||
          state is TodosViewState ||
          state is TodosViewStateAdmin) {
        widgets.addAll(AgronomoWidgets.buildAgronomoWidgets(property));
      }
      if (state is ProprietarioViewState ||
          state is SeringueiroProprietarioViewState ||
          state is AgronomoProprietarioViewState ||
          state is SeringueiroProprietarioAdminViewState ||
          state is AgronomoProprietarioAdminViewState ||
          state is ProprietarioAdminViewState ||
          state is TodosViewState ||
          state is TodosViewStateAdmin) {
        widgets.addAll(ProprietarioWidgets.buildProprietarioWidgets(property));
      }
      if (state is AdminViewState ||
          state is SeringueiroAgronomoAdminViewState ||
          state is SeringueiroProprietarioAdminViewState ||
          state is AgronomoProprietarioAdminViewState ||
          state is SeringueiroAdminViewState ||
          state is AgronomoAdminViewState ||
          state is ProprietarioAdminViewState ||
          state is TodosViewStateAdmin) {
        widgets.addAll(AdminWidgets.buildAdminWidgets(context, property));
      }
    }

    // Caso padrão ou se nenhum papel específico for encontrado
    if (widgets.isEmpty) {
      widgets.add(
          Center(child: Text('Nenhuma visualização específica disponível')));
    }

    // Envolver a lista de widgets em um Column
    return Column(children: widgets);
  }
}
