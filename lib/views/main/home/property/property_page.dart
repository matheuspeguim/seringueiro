import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_widgets/field_activity_control_painel.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/property_buttons_widget/property_buttons_widget.dart';
import 'package:flutter_seringueiro/views/main/home/weather/hourly_weather_widget.dart';
import 'package:flutter_seringueiro/widgets/custom_Circular_Progress_indicator.dart';

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
              backgroundColor: Colors.green.shade900,
              elevation: 50,
            ),
            body: _buildBody(context, state),
            backgroundColor: Colors.green,
            floatingActionButton: FloatingActionButton(
              onPressed: _showPropertyButtons,
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.green.shade900, // Cor do botão
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
      enableDrag: true,
      backgroundColor: Colors.white.withOpacity(0.0),
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
              HourlyWeatherWidget(location: state.property.localizacao),
              Divider(
                color: Colors.white,
              ),
              FieldActivityControlPanel(
                userId: widget.user.uid,
                propertyId: widget.propertyId,
              )
            ],
          ),
        ),

        // Outros componentes relacionados à propriedade podem ser adicionados aqui
      );
    } else {
      return Center(child: Text('Estado não reconhecido!'));
    }
  }
}
