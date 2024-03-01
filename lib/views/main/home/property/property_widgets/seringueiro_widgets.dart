import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/services/open_weather_api_service.dart';
import 'package:flutter_seringueiro/models/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_manager.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_dialog_content.dart';
import 'package:flutter_seringueiro/widgets/custom_button.dart';

class SeringueiroWidgets {
  static List<Widget> buildSeringueiroWidgets(BuildContext context, User user,
      Property property, FieldActivityManager activityManager) {
    List<Widget> widgets = [];

    widgets.add(buildSangriaButton(context, user, property, activityManager));
    widgets.add(buildPluviometroButton(context, user, property));
    widgets
        .add(buildEstimulacaoButton(context, user, property, activityManager));
    widgets
        .add(buildTratamentoButton(context, user, property, activityManager));

    return widgets;
  }

  static Widget buildSangriaButton(
    BuildContext context,
    User user,
    Property property,
    FieldActivityManager activityManager,
  ) {
    String activity = "Sangria";
    return CustomButton(
      label: 'Sangria',
      icon: Icons.add,
      onPressed: () async {
        await activityManager.iniciarAtividade(
          context,
          user,
          property,
          activity,
        );
        // Após iniciar a atividade, fecha o ModalBottomSheet
        Navigator.pop(context);
      },
    );
  }

  static Widget buildPluviometroButton(
      BuildContext context, User user, Property property) {
    return CustomButton(
      label: 'Chuva',
      icon: Icons.add,
      onPressed: () => showRainRecordingDialog(context, user, property),
    );
  }

  static Widget buildEstimulacaoButton(BuildContext context, User user,
      Property property, FieldActivityManager activityManager) {
    String activity = "Estimulação";
    return CustomButton(
      label: 'Estimulação',
      icon: Icons.add,
      onPressed: () async {
        await activityManager.iniciarAtividade(
          context,
          user,
          property,
          activity,
        );
        // Após iniciar a atividade, fecha o ModalBottomSheet
        Navigator.pop(context);
      },
    );
  }

  static Widget buildTratamentoButton(BuildContext context, User user,
      Property property, FieldActivityManager activityManager) {
    String activity = "Tratamento";
    return CustomButton(
      label: "Tratamento",
      icon: Icons.add,
      onPressed: () async {
        await activityManager.iniciarAtividade(
          context,
          user,
          property,
          activity,
        );
        // Após iniciar a atividade, fecha o ModalBottomSheet
        Navigator.pop(context);
      },
    );
  }

  static Future<void> showRainRecordingDialog(
      BuildContext context, User user, Property property) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider<RainBloc>(
          create: (_) => RainBloc(
              firestore: FirebaseFirestore.instance,
              weatherApiService: OpenWeatherApiService(
                  apiKey: dotenv.env['OPENWEATHER_API_KEY']!)),
          child: RainDialogContent(
            property: property,
            user: user,
          ),
        );
      },
    );
  }
}
